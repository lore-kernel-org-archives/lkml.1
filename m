Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbYHEAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbYHEAdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbYHEAdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:33:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155AbYHEAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:33:08 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080804223249.GA10517@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 20:32:54 -0400
Message-Id: <1217896374.27684.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 15:32 -0700, Greg KH wrote:
> On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:

> > Security vendors, Linux distributors and other interested parties have
> > come together on the malware-list mailing list to discuss this problem
> > and see if they can work together to propose a solution. During these
> > talks couple of requirement sets were posted with the aim of fleshing
> > out common needs as a prerequisite of creating an interface prototype.
> 
> These requirements were posted?  Where?  I don't recall seeing them.

they were collected from the comments of Sophos, CA, and McAfee on
malware-list@lists.printk.net back in January 2008.  I can't find the
lists archived on the net so I will post the raw messages tomorrow from
my local mail store and send a link.

> 
> > Collated requirements
> > +++++++++++++++++++++
> >   1. Intercept file opens (exec also) for vetting (block until
> >   decision is made) and allow some userspace black magic to make
> >   decisions.
> >   2. Intercept file closes for scanning post access
> >   3. Cache scan results so the same file is not scanned on each and every access
> >   4. Ability to flush the cache and cause all files to be re-scanned when accessed
> >   5. Define which filesystems are cacheable and which are not
> >   6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
> >   7. Report other relevant file, process and user information associated with each interception
> >   8. Report file pathnames to userspace (relative to process root, current working directory)
> >   9. Mark a processes as exempt from on access scanning
> >  10. Exclude sub-trees from scanning based on filesystem (exclude procfs, sysfs, devfs)
> >  11. Exclude sub-trees from scanning based on filesystem path
> >  12. Include only certain sub-trees from scanning based on filesystem path
> >  13. Register more than one userspace client in which case behavior is restrictive
> 
> I don't see anything in the list above that make this a requirement that
> the code to do this be placed within the kernel.
> 
> What is wrong with doing it in glibc or some other system-wide library
> (LD_PRELOAD hooks, etc.)?

It may be possible to do in glibc, LD_PRELOAD doesn't exactly work for
suid binaries

> 
> > 1., 2. Basic interception
> > -------------------------
> > Core requirement is to intercept access to files and prevent it if
> > malicious content is detected.  This is done on open, not on read.  It
> > may be possible to do read time checking with minimal performance impact
> > although not currently implemented.  This means that the following race
> > is possible
> > 
> >    Process1              Process2
> >     - open file RD
> >                           - open file WR
> >                           - write virus data (1)
> >     - read virus data
> 
> Wonderful, we are going to implement a solution that is known to not
> work, with a trivial way around it?
> 
> Sorry, that's not going to fly.

The model only makes claims about open and I want to be forthright with
its shortcomings.  It sounds rather unreasonable to think that every
time I want to read one bite from a file which is being concurrently
written by another process some virus scanner should have to reread and
validate the entire file.  I think as some point we have to accept the
fact that there is no feasible perfect solution (no you can't do write
time checking since circumventing that is as simple as splitting your
bad bits into two writes...)

> 
> > *note that any open after (1) will get properly vetted.  At this time
> > the likely hood of this being a problem vs the performance impact of
> > scanning on read and the increased complexity of the code means this is
> > left out.  This should not be a problem for local executables as writes
> > to files opened to be run typically return ETXTBSY.
> 
> Are you sure about this?

I'm willing to say that opens after (1) are going to be validated.  I am
not certain that all executables opened for write while they are being
executed return ETXTBSY (I do know it happens at least sometimes) so I'm
willing to drop that idea.

> > One of the most important filters in the evaluation chain implements an
> > interface through which an userspace process can register and receive
> > vetting requests. Userspace process opens a misc character device to
> > express its interest and then receives binary structures from that
> > device describing basic interception information. After file contents
> > have been scanned a vetting response is sent by writing a different
> > binary structure back to the device and the intercepted process
> > continues its execution.  These are not done over network sockets and no
> > endian conversions are done.  The client and the kernel must have the
> > same endian configuration.
> 
> How about the same 64/32bit requirement?  Your implementation is
> incorrect otherwise.

I'll definitely go back and look, but I think I use bit lengths for
everything in the communication channel so its only endian issues to
worry about.

> (hint, your current patch is also wrong in this area, you should fix
> that up...)

> And a binary structure?  Ick, are you trying to make it hard for future
> expansions and such?

As long as the requirement that the first 32 bits be a version it might
make ugly code but any future expansions are easy to deal with.  Read
from userspace, get the first 32 bits, cast the read from userspace to
the correct structure.  What would you suggest?

> 
> And why not netlink/network socket?  Why a character device?  You are
> already using securityfs, why not use a file node in there?

Opps, old description.  I do just use an inode in securityfs, not a misc
character device.  I'm not clear what netlink would buy here.  I might
be able to make my async close vetting code a little cleaner, but it
would make other things more complex (like registration and actually
having to track userspace clients)

> 
> > 6. Direct access to file content
> > --------------------------------
> > When an userspace daemon receives a vetting request, it also receives a
> > new RO file descriptor which provides direct access to the inode in
> > question. This is to enable access to the file regardless of it
> > accessibility from the scanner environment (consider process namespaces,
> > chroot's, NFS).  The userspace client is responsible for closing this
> > file when it is finished scanning.
> 
> Is this secondary file handle properly checked for the security issues
> involved with such a thing?  What happens if the userspace client does
> not close the file handle?

I'm not sure the security issues that you are refering too, do you mean
do we make LSM checks and regular DAC checks for the userspace client on
the file in question?  yes.

The userspace client is forced to respond to all fd's it is handed.  If
userspace decided to respond to a request but never close the file the
client will eventually run out of fds and I really should make sure I
have decent error handling for that case.  No real damage done aside
from extra references outstanding until the client program dies.  Much
the same way as any program that calls open on files it doesn't ever
close....

> 
> > 7. Other reporting
> > ------------------
> > Along with the fd being installed in the scanning process the process
> > gets a binary structure of data including: 
> 
> What's with the love of binary structures? :)

Its only the one structure (ok and the response)

include/linux/talpa.h

struct talpa_packet_client
struct talpa_packet_kernel

> > +       uint32_t version;
> > +       uint32_t type;
> > +       int32_t fd;
> > +       uint32_t operation;
> > +       uint32_t flags;
> > +       uint32_t mode;
> > +       uint32_t uid;
> > +       uint32_t gid;
> > +       uint32_t tgid;
> > +       uint32_t pid;
> 
> What happens when the world moves to 128bit or 64bit uids?  (yes, I've
> seen proposals for such a thing...)

The same things that happens to every other subsystem that uses uint32_t
to describe uid (like audit?)  It either gets truncated massive main
ensues...

> Why would userspace care about these meta-file things, what does it want
> with them?

Honstely?  I don't know.  Maybe someone with access to the black magic
source code will stand up and say if most of this metadata is important
and if so how.

> 
> > 8. Path name reporting
> > ----------------------
> > When a malicious content is detected in a file it is important to be
> > able to report its location so the user or system administrator can take
> > appropriate actions.
> > 
> > This is implemented in a amazingly simple way which will hopefully avoid
> > the controversy of some other solutions. Path name is only needed for
> > reporting purposes and it is obtained by reading the symlink of the
> > given file descriptor in /proc.  Its as simple as userspace calling:
> > 
> > snprintf(link, sizeof(link), "/proc/self/fd/%d", details.fd);
> > ret = readlink(link, buf, sizeof(buf)-1);
> 
> Cute hack.  What's to keep it from racing with the fd changing from the
> original program?

Not sure what you mean here.  On sys_open the original program is
blocking until the userspace client answers allow or deny.  Both the
original program fd and the fd that magically appeared in the client
point to the same dentry.  Names may move around but its going to be the
same 'name' for both of them.  I don't see a race here....

> 
> > 9. Process exclusion
> > --------------------
> > Sometimes it is necessary to exclude certain processes from being
> > intercepted. For example it might be a userspace root kit scanner which
> > would not be able to find root kits if access to them was blocked by the
> > on-access scanner.
> > 
> > To facilitate that we have created a special file a process can open and
> > register itself as excluded. A flag is then put into its kernel
> > structure (task_struct) which makes it excluded from scanning.
> > 
> > This implementation is very simple and provides greatest performance. In
> > the proposed implementation access to the exclusion device is controlled
> > though permissions on the device node which are not sufficient.  An LSM
> > call will need to be made for this type or access in a later patch.
> 
> Heh, so if you want to write a "virus" for Linux, just implement this
> flag.  What's to keep a "rogue" program from telling the kernel that all
> programs on the system are to be excluded?

Processes can only get this flag one of 2 ways.

1) register as a client to make access decisions
2) echo 1 into the magic file to enable the flag for themselves

A process can only set this flag on itself and having this flag only
means that your opens and closes will not be scanned.  And exculded
program could write a virus and it would not be caught on close, but it
would be caught on the next open.

> > 10. Filesystem exclusions
> > -------------------------
> > One pretty important optimization is not to scan things like /proc, /sys
> > or similar. Basically all filesystems where user can not store
> > arbitrary, potentially malicious, content could and should be excluded
> > from scanning.
> 
> Why, does scanning these files take extra time?  Just curious.

Perf win, why bothering looking for malware in /proc when it can't
exist?  It doesn't take longer it just takes time having to do

userspace -> kernel -> userspace -> kernel -> userspace

just to cat /proc/mounts, all of this could probably be alliviated if we
cached access on non block backed files but then we have to come up with
a way to exclude only nfs/cifs.  I'd rather list the FSs that don't need
scanning every time than those that do....

> 
> > 11. Path exclusions
> > -------------------
> > The need for exclusions can be demonstrated with an example of a MySQL
> > server. It's data files are frequently modified which means they would
> > need to be constantly rescanned which is very bad for performance. Also,
> > it is most often not even possible to reasonably scan them. Therefore
> > the best solution is not to scan its database store which can simply be
> > implemented by excluding the store subdirectory.
> > 
> > It is a relatively simple implementation which allows run-time
> > configuration of a list of sub directories or files to exclude.
> > Exclusion paths are relative to each process root. So for example if we
> > want to exclude /var/lib/mysql/ and we have a mysql running in a chroot
> > where from the outside that directory actually lives
> > in /chroot/mysql/var/lib/mysql, /var/lib/mysql should actually be added
> > to the exclusion list.
> > 
> > This is also not included in the initial patch set but will be coming
> > shortly after.
> 
> Again, what's to keep all files to be marked as excluded?

You have to be root and I'll probably add an LSM hook?

> > Closing remarks
> > ---------------
> > Although some may argue some of the filters are not necessary or may
> > better be implemented in userspace, we think it is better to have them
> > in kernel primarily for performance reasons.
> 
> Why?  What numbers do you have that say the kernel is faster in
> implementing this?  This is the first mention of such a requirement, we
> need to see real data to back it up please.

In kernel caching is clearly a huge perf win.  I couldn't even measure a
change in kernel build time when I didn't run a userspace client.  If
anyone can explain a way to get race free in kernel caching and out of
kernel redirection and scanning I'd love it   :)

I'll post numbers on perf in the next day or 2.

> > Secondly, it is all simple code not introducing much baggage or risk
> > into the kernel itself.
> 
> I disagree, see above.

