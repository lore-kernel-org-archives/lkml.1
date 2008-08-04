Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYHDVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYHDVBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYHDVAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:00:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbYHDVAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:00:37 -0400
Subject: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 04 Aug 2008 17:00:16 -0400
Message-Id: <1217883616.27684.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please contact me privately or (preferably the list) for questions,
comments, discussions, flames, names, or anything.  I'll do complete
rewrites of the patches if someone tells me how they don't meet their
needs or how they can be done better.  I'm here to try to bridge the
needs (and wants) of the anti-malware vendors with the technical
realities of the kernel.  So everyone feel free to throw in your two
cents and I'll try to reconcile it all.  These 5 patches are part 1.
They give us a working able solution.

>From my point of view patches forthcoming and mentioned below should
help with performance for those who actually have userspace scanners but
also could presents be implemented using this framework.


Background
++++++++++
There is a consensus in the security industry that protecting against
malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
of so-called on-access scanning is usable and reasonable approach.
Currently the Linux kernel does not offer a completely suitable
interface to implement such security solutions.  Present solutions
involve overwriting function pointers in the LSM, in filesystem
operations, in the sycall table, and other fragile hacks.  The purpose
of this project is to create a fast, clean interface for userspace
programs to look for malware when files are accessed.  This malware may
be ultimately intended for this or some other Linux machine or may be
malware intended to attack a host running a different operating system
and is merely in transit across the Linux server.  Since there are
almost an infinite number of ways in which information can enter and
exit a server it is not seen as reasonable to move these checks to all
the applications at the boundary (MTA, NFS, CIFS, SSH, rsync, et al.) to
look for such malware on at the border.

For this Linux kernel interface speed is of particular interest for
those who have it compiled into the kernel but have no userspace client.
There must be no measurable performance hit to just compiling this into
the kernel.

Security vendors, Linux distributors and other interested parties have
come together on the malware-list mailing list to discuss this problem
and see if they can work together to propose a solution. During these
talks couple of requirement sets were posted with the aim of fleshing
out common needs as a prerequisite of creating an interface prototype.

Collated requirements
+++++++++++++++++++++
  1. Intercept file opens (exec also) for vetting (block until decision is made) and allow some userspace black magic to make decisions.
  2. Intercept file closes for scanning post access
  3. Cache scan results so the same file is not scanned on each and every access
  4. Ability to flush the cache and cause all files to be re-scanned when accessed
  5. Define which filesystems are cacheable and which are not
  6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
  7. Report other relevant file, process and user information associated with each interception
  8. Report file pathnames to userspace (relative to process root, current working directory)
  9. Mark a processes as exempt from on access scanning
 10. Exclude sub-trees from scanning based on filesystem (exclude procfs, sysfs, devfs)
 11. Exclude sub-trees from scanning based on filesystem path
 12. Include only certain sub-trees from scanning based on filesystem path
 13. Register more than one userspace client in which case behavior is restrictive


Discussion of requirements
++++++++++++++++++++++++++
The initial patch set with NOT meet all of these 'requirements.'  Some
will be implemented at a later time and some will never be implemented.
Specifics are detailed below.  There is no intention to (abu)use the LSM
for this purpose.  The LSM provides complete internal kernel mandatory
access controls.  It is not intended for userspace scanning and
detection.  Users should not be forced to choose between an in kernel
mandatory access control policy and this additional userspace file
access.  LSM stacking is NOT as option as has been demonstrated
repeatedly.

1., 2. Basic interception
-------------------------
Core requirement is to intercept access to files and prevent it if
malicious content is detected.  This is done on open, not on read.  It
may be possible to do read time checking with minimal performance impact
although not currently implemented.  This means that the following race
is possible

   Process1              Process2
    - open file RD
                          - open file WR
                          - write virus data (1)
    - read virus data

*note that any open after (1) will get properly vetted.  At this time
the likely hood of this being a problem vs the performance impact of
scanning on read and the increased complexity of the code means this is
left out.  This should not be a problem for local executables as writes
to files opened to be run typically return ETXTBSY.

To accomplish that two hooks were inserted, on file open in
__dentry_open and in filp_close on file close. In both cases the file
object in question is passed as a parameter for further processing. In
case of an open the operation can actually be blocked, while closes are
always immediately successful and will not cause additional blocking.
Results of a close are returned to the kernel asynchronously and may be
used to cache answers to speed up a future open.

Interception processing is done by way of three chains of filters.
Access requests are first send to the "evaluation" chain.  Depending on
the results of the evaluation the decision is then send to either the
allow chain or the deny chain.

There are three basic responses each filter can make - to be indifferent
or either allow or deny access to the file.  The filter may also allow
or deny access to a file while not caching that result.

One of the most important filters in the evaluation chain implements an
interface through which an userspace process can register and receive
vetting requests. Userspace process opens a misc character device to
express its interest and then receives binary structures from that
device describing basic interception information. After file contents
have been scanned a vetting response is sent by writing a different
binary structure back to the device and the intercepted process
continues its execution.  These are not done over network sockets and no
endian conversions are done.  The client and the kernel must have the
same endian configuration.

3., 4. Caching
---------------
To avoid scanning unchanged files on every access which would be very
bad for performance some sort of caching is needed.  Although possible
to implement a cache in userspace having two context switches required
for every open is clearly not fast.  We implemented it per inode object
as a serial number compared with a single global monotonically
increasing system serial number.

The cache filter is inserted into the evaluation chain before the
userspace client filter and if the inode serial number is equal to the
system one it allows access to the file.

If the file is seen for the first time, has been modified, or for any
other reason has a serial number less than the system one the cache
filter will be 'indifferent' and processing of the given vetting request
will continue down the evaluation chain.  When some filter (only
Userspace in the first patch set) allows access to a file its inode
serial number is set to the system global which effectively makes it
cached. Also, when a write access is gained for a file the serial number
will automatically be reset as well as when any process actually writes
to that file.

Cache flushing is possible by simply increasing the global system serial
number.

Both positive and negative vetting results are cached by the means of
positive and negative serial numbers.

This method of caching has minimal impact on system resources while
providing maximal effectiveness and simple implementation.

5. Fine-grained caching
-----------------------
It is necessary to select which filesystems can be safely cached and
which must not be. For example it is not a good idea to allow caching of
network filesystems because their content can be changed invisibly. Disk
based and some virtual filesystems can be cached safely on the other
hand.

This first proposal only partially implements this requirement. Only
block device backed filesystems will be cached while there is no way to
enable caching for things like tmpfs. Improving this is left out of the
initial prototype.  Although there may be additional work to implement
caching for certain FS types there is no plan to greatly increase the
scope of the cache granularity.  There is no plan to cache based on the
operation or things of that nature.  Caching of this nature can be
implemented in userspace if the vendor so chooses.  We include only a
minimal safe cache for performance reasons.

6. Direct access to file content
--------------------------------
When an userspace daemon receives a vetting request, it also receives a
new RO file descriptor which provides direct access to the inode in
question. This is to enable access to the file regardless of it
accessibility from the scanner environment (consider process namespaces,
chroot's, NFS).  The userspace client is responsible for closing this
file when it is finished scanning.

7. Other reporting
------------------
Along with the fd being installed in the scanning process the process
gets a binary structure of data including: 

+       uint32_t version;
+       uint32_t type;
+       int32_t fd;
+       uint32_t operation;
+       uint32_t flags;
+       uint32_t mode;
+       uint32_t uid;
+       uint32_t gid;
+       uint32_t tgid;
+       uint32_t pid;

8. Path name reporting
----------------------
When a malicious content is detected in a file it is important to be
able to report its location so the user or system administrator can take
appropriate actions.

This is implemented in a amazingly simple way which will hopefully avoid
the controversy of some other solutions. Path name is only needed for
reporting purposes and it is obtained by reading the symlink of the
given file descriptor in /proc.  Its as simple as userspace calling:

snprintf(link, sizeof(link), "/proc/self/fd/%d", details.fd);
ret = readlink(link, buf, sizeof(buf)-1);

9. Process exclusion
--------------------
Sometimes it is necessary to exclude certain processes from being
intercepted. For example it might be a userspace root kit scanner which
would not be able to find root kits if access to them was blocked by the
on-access scanner.

To facilitate that we have created a special file a process can open and
register itself as excluded. A flag is then put into its kernel
structure (task_struct) which makes it excluded from scanning.

This implementation is very simple and provides greatest performance. In
the proposed implementation access to the exclusion device is controlled
though permissions on the device node which are not sufficient.  An LSM
call will need to be made for this type or access in a later patch.

10. Filesystem exclusions
-------------------------
One pretty important optimization is not to scan things like /proc, /sys
or similar. Basically all filesystems where user can not store
arbitrary, potentially malicious, content could and should be excluded
from scanning.

This interface prototype implements it as a run-time configurable list
of filesystem names. Again it is a filter in the evaluation chain which
can allow access before the request gets routed to the userspace client.

This will not be implemented in the first patch set but should be soon
to follow.  It is done by simply comparing strings between those
supplied and the s_type->name field in an associated superblock.

11. Path exclusions
-------------------
The need for exclusions can be demonstrated with an example of a MySQL
server. It's data files are frequently modified which means they would
need to be constantly rescanned which is very bad for performance. Also,
it is most often not even possible to reasonably scan them. Therefore
the best solution is not to scan its database store which can simply be
implemented by excluding the store subdirectory.

It is a relatively simple implementation which allows run-time
configuration of a list of sub directories or files to exclude.
Exclusion paths are relative to each process root. So for example if we
want to exclude /var/lib/mysql/ and we have a mysql running in a chroot
where from the outside that directory actually lives
in /chroot/mysql/var/lib/mysql, /var/lib/mysql should actually be added
to the exclusion list.

This is also not included in the initial patch set but will be coming
shortly after.

12. Path Inclusions
-------------------

Path-based inclusions are not implemented due to concerns with
hard-linked files both inside and outside the included directories.  It
is too easy to fall into a sense of false security with path inclusions
since the pathname is almost meaningless.  If a vendor feels this is
particularly important for them they will have to implement it in
userspace by use of a judicious list of exclusion filters.


13. Multiple client registration with restrictive behavior
-----------------------------------------------------------
This is currently not implemented. Multiple clients can register but
they will be used for (crappy) load balancing only.  Not all will be
called for a single interception. Only one of the registered clients
will process a single interception. Desire here is to enable multiple
clients servicing interceptions in parallel for performance and
reliability reasons.

Requirement for serial and restrictive behavior would be slightly more
complicated to implement because we would want to keep the current
behavior as well. Or in other words we would need to have groups of
multiple clients, where each interception would go through one client
from each group with the desired restrictive behavior.

This may be left for a future implementation for simplicity reasons but
I find it unlikely.  If a vendor needs to send requests to multiple
scanners they should be able to implement that serialization in
userspace.  I see no need for an in kernel event dispatcher.  Note that
the audit system had this same need and has done it as a userspace event
dispatcher.  We have also seen in the LSM that restrictive access
stacking is not as easy as it sounds and has been abandoned.

Closing remarks
---------------
Although some may argue some of the filters are not necessary or may
better be implemented in userspace, we think it is better to have them
in kernel primarily for performance reasons. Secondly, it is all simple
code not introducing much baggage or risk into the kernel itself.  The
most complex filter and the only one with locking ramifications is the
userspace client vetting which calls into dentry_open() on both open and
close operations.  There is no locking around caching or process
exclusions or other work.

**************************

The patches can be found in a git tree located:

http://git.infradead.org/users/eparis/talpa.git

since:

commit 2b12a4c524812fb3f6ee590a02e65b95c8c32229
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 1 14:59:11 2008 -0700

    Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6

This tree will be rebased regularly, so please do not just start pulling
and hoping it will continue to always merge.  My current plan is to
commit changes and comments on the end of this tree and eventually
reroll those changes into these 5 patches for finally submission to
upstream.  Likely this will be an iterative process.

The 5 patches in the following e-mails can also be found at
http://people.redhat.com/~eparis/talpa

 Documentation/talpa/allow_most.c        |  138 ++++++++
 Documentation/talpa/cache               |   17 +
 Documentation/talpa/client              |   85 +++++
 Documentation/talpa/design.txt          |  266 +++++++++++++++
 Documentation/talpa/tecat.c             |   50 ++
 Documentation/talpa/test_deny.c         |  356 ++++++++++++++++++++
 Documentation/talpa/thread_exclude      |    6 
 fs/inode.c                              |    6 
 fs/namei.c                              |    2 
 fs/open.c                               |   10 
 include/linux/fs.h                      |    5 
 include/linux/sched.h                   |    1 
 include/linux/talpa.h                   |  188 +++++++++++
 security/Kconfig                        |    1 
 security/Makefile                       |    2 
 security/talpa/Kconfig                  |   51 +++
 security/talpa/Makefile                 |   17 -
 security/talpa/talpa.h                  |  115 ++++++
 security/talpa/talpa_allow_calls.h      |   12 
 security/talpa/talpa_cache.c            |  207 ++++++++++++
 security/talpa/talpa_cache.h            |   22 +
 security/talpa/talpa_client.c           |  543 ++++++++++++++++++++++++++++++++
 security/talpa/talpa_common.c           |   56 +++
 security/talpa/talpa_configuration.c    |  156 +++++++++
 security/talpa/talpa_deny_calls.h       |   11 
 security/talpa/talpa_evaluation_calls.h |   42 ++
 security/talpa/talpa_interceptor.c      |  121 +++++++
 security/talpa/talpa_thread_exclude.c   |   67 +++
 28 files changed, 2546 insertions(+), 7 deletions(-)

