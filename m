Return-Path: <linux-kernel-owner+w=401wt.eu-S1763720AbYHEAye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763720AbYHEAye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbYHEAx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:53:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbYHEAxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:53:54 -0400
Date: Mon, 4 Aug 2008 17:51:32 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805005132.GA3661@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217896374.27684.53.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 08:32:54PM -0400, Eric Paris wrote:
> On Mon, 2008-08-04 at 15:32 -0700, Greg KH wrote:
> > On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:
> > > Collated requirements
> > > +++++++++++++++++++++
> > >   1. Intercept file opens (exec also) for vetting (block until
> > >   decision is made) and allow some userspace black magic to make
> > >   decisions.
> > >   2. Intercept file closes for scanning post access
> > >   3. Cache scan results so the same file is not scanned on each and every access
> > >   4. Ability to flush the cache and cause all files to be re-scanned when accessed
> > >   5. Define which filesystems are cacheable and which are not
> > >   6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
> > >   7. Report other relevant file, process and user information associated with each interception
> > >   8. Report file pathnames to userspace (relative to process root, current working directory)
> > >   9. Mark a processes as exempt from on access scanning
> > >  10. Exclude sub-trees from scanning based on filesystem (exclude procfs, sysfs, devfs)
> > >  11. Exclude sub-trees from scanning based on filesystem path
> > >  12. Include only certain sub-trees from scanning based on filesystem path
> > >  13. Register more than one userspace client in which case behavior is restrictive
> > 
> > I don't see anything in the list above that make this a requirement that
> > the code to do this be placed within the kernel.
> > 
> > What is wrong with doing it in glibc or some other system-wide library
> > (LD_PRELOAD hooks, etc.)?
> 
> It may be possible to do in glibc, LD_PRELOAD doesn't exactly work for
> suid binaries

Are suid binaries something that you feel is necessary to scan from?

I don't see it on the list above :)

> > > 1., 2. Basic interception
> > > -------------------------
> > > Core requirement is to intercept access to files and prevent it if
> > > malicious content is detected.  This is done on open, not on read.  It
> > > may be possible to do read time checking with minimal performance impact
> > > although not currently implemented.  This means that the following race
> > > is possible
> > > 
> > >    Process1              Process2
> > >     - open file RD
> > >                           - open file WR
> > >                           - write virus data (1)
> > >     - read virus data
> > 
> > Wonderful, we are going to implement a solution that is known to not
> > work, with a trivial way around it?
> > 
> > Sorry, that's not going to fly.
> 
> The model only makes claims about open and I want to be forthright with
> its shortcomings.  It sounds rather unreasonable to think that every
> time I want to read one bite from a file which is being concurrently
> written by another process some virus scanner should have to reread and
> validate the entire file.  I think as some point we have to accept the
> fact that there is no feasible perfect solution (no you can't do write
> time checking since circumventing that is as simple as splitting your
> bad bits into two writes...)

So, if this isn't really going to protect anything, how can anyone
justify adding it to the kernel?  I sure would not allow that.

> > > One of the most important filters in the evaluation chain implements an
> > > interface through which an userspace process can register and receive
> > > vetting requests. Userspace process opens a misc character device to
> > > express its interest and then receives binary structures from that
> > > device describing basic interception information. After file contents
> > > have been scanned a vetting response is sent by writing a different
> > > binary structure back to the device and the intercepted process
> > > continues its execution.  These are not done over network sockets and no
> > > endian conversions are done.  The client and the kernel must have the
> > > same endian configuration.
> > 
> > How about the same 64/32bit requirement?  Your implementation is
> > incorrect otherwise.
> 
> I'll definitely go back and look, but I think I use bit lengths for
> everything in the communication channel so its only endian issues to
> worry about.

No, your field definitions are incorrect.

You must use __u8 and friends for variables that cross the
userspace/kernel boundry.  None of the uint_* crap :)

> > (hint, your current patch is also wrong in this area, you should fix
> > that up...)
> 
> > And a binary structure?  Ick, are you trying to make it hard for future
> > expansions and such?
> 
> As long as the requirement that the first 32 bits be a version it might
> make ugly code but any future expansions are easy to deal with.  Read
> from userspace, get the first 32 bits, cast the read from userspace to
> the correct structure.  What would you suggest?

Not doing this in the kernel at all.

Seriously.

I mean it.

Oh, and after that, not using a binary interface, have we not learned
from the ioctl mess?  I sure thought we had...

> > And why not netlink/network socket?  Why a character device?  You are
> > already using securityfs, why not use a file node in there?
> 
> Opps, old description.  I do just use an inode in securityfs, not a misc
> character device.  I'm not clear what netlink would buy here.  I might
> be able to make my async close vetting code a little cleaner, but it
> would make other things more complex (like registration and actually
> having to track userspace clients)

Why would the kernel have to worry about that?

> > > 6. Direct access to file content
> > > --------------------------------
> > > When an userspace daemon receives a vetting request, it also receives a
> > > new RO file descriptor which provides direct access to the inode in
> > > question. This is to enable access to the file regardless of it
> > > accessibility from the scanner environment (consider process namespaces,
> > > chroot's, NFS).  The userspace client is responsible for closing this
> > > file when it is finished scanning.
> > 
> > Is this secondary file handle properly checked for the security issues
> > involved with such a thing?  What happens if the userspace client does
> > not close the file handle?
> 
> I'm not sure the security issues that you are refering too, do you mean
> do we make LSM checks and regular DAC checks for the userspace client on
> the file in question?  yes.

Yes, that is what I was referring to.

> > > +       uint32_t version;
> > > +       uint32_t type;
> > > +       int32_t fd;
> > > +       uint32_t operation;
> > > +       uint32_t flags;
> > > +       uint32_t mode;
> > > +       uint32_t uid;
> > > +       uint32_t gid;
> > > +       uint32_t tgid;
> > > +       uint32_t pid;
> > 
> > What happens when the world moves to 128bit or 64bit uids?  (yes, I've
> > seen proposals for such a thing...)
> 
> The same things that happens to every other subsystem that uses uint32_t
> to describe uid (like audit?)  It either gets truncated massive main
> ensues...

audit passed the value in a binary structure from the kernel to
userspace?  Really?  Ick.

> > Why would userspace care about these meta-file things, what does it want
> > with them?
> 
> Honstely?  I don't know.  Maybe someone with access to the black magic
> source code will stand up and say if most of this metadata is important
> and if so how.

Don't add things that are not needed, _everything_ must be justified.

> > > 8. Path name reporting
> > > ----------------------
> > > When a malicious content is detected in a file it is important to be
> > > able to report its location so the user or system administrator can take
> > > appropriate actions.
> > > 
> > > This is implemented in a amazingly simple way which will hopefully avoid
> > > the controversy of some other solutions. Path name is only needed for
> > > reporting purposes and it is obtained by reading the symlink of the
> > > given file descriptor in /proc.  Its as simple as userspace calling:
> > > 
> > > snprintf(link, sizeof(link), "/proc/self/fd/%d", details.fd);
> > > ret = readlink(link, buf, sizeof(buf)-1);
> > 
> > Cute hack.  What's to keep it from racing with the fd changing from the
> > original program?
> 
> Not sure what you mean here.  On sys_open the original program is
> blocking until the userspace client answers allow or deny.  Both the
> original program fd and the fd that magically appeared in the client
> point to the same dentry.  Names may move around but its going to be the
> same 'name' for both of them.  I don't see a race here....

Oh, forgot about the fact that the code blocks.  That's probably a race
in itself :)

> > Heh, so if you want to write a "virus" for Linux, just implement this
> > flag.  What's to keep a "rogue" program from telling the kernel that all
> > programs on the system are to be excluded?
> 
> Processes can only get this flag one of 2 ways.
> 
> 1) register as a client to make access decisions

How do you do that?

> 2) echo 1 into the magic file to enable the flag for themselves

Simple enough :)

> > > 10. Filesystem exclusions
> > > -------------------------
> > > One pretty important optimization is not to scan things like /proc, /sys
> > > or similar. Basically all filesystems where user can not store
> > > arbitrary, potentially malicious, content could and should be excluded
> > > from scanning.
> > 
> > Why, does scanning these files take extra time?  Just curious.
> 
> Perf win, why bothering looking for malware in /proc when it can't
> exist?  It doesn't take longer it just takes time having to do
> 
> userspace -> kernel -> userspace -> kernel -> userspace
> 
> just to cat /proc/mounts, all of this could probably be alliviated if we
> cached access on non block backed files but then we have to come up with
> a way to exclude only nfs/cifs.  I'd rather list the FSs that don't need
> scanning every time than those that do....

How long does this whole process take?  Seriously is it worth the added
kernel code for something that is not measurable?

> > > 11. Path exclusions
> > > -------------------
> > > The need for exclusions can be demonstrated with an example of a MySQL
> > > server. It's data files are frequently modified which means they would
> > > need to be constantly rescanned which is very bad for performance. Also,
> > > it is most often not even possible to reasonably scan them. Therefore
> > > the best solution is not to scan its database store which can simply be
> > > implemented by excluding the store subdirectory.
> > > 
> > > It is a relatively simple implementation which allows run-time
> > > configuration of a list of sub directories or files to exclude.
> > > Exclusion paths are relative to each process root. So for example if we
> > > want to exclude /var/lib/mysql/ and we have a mysql running in a chroot
> > > where from the outside that directory actually lives
> > > in /chroot/mysql/var/lib/mysql, /var/lib/mysql should actually be added
> > > to the exclusion list.
> > > 
> > > This is also not included in the initial patch set but will be coming
> > > shortly after.
> > 
> > Again, what's to keep all files to be marked as excluded?
> 
> You have to be root and I'll probably add an LSM hook?

Why an LSM hook?  You aren't an LSM.

> > > Closing remarks
> > > ---------------
> > > Although some may argue some of the filters are not necessary or may
> > > better be implemented in userspace, we think it is better to have them
> > > in kernel primarily for performance reasons.
> > 
> > Why?  What numbers do you have that say the kernel is faster in
> > implementing this?  This is the first mention of such a requirement, we
> > need to see real data to back it up please.
> 
> In kernel caching is clearly a huge perf win.

Why?  If the cache is also in userspace, it should be the same, right?

> I couldn't even measure a change in kernel build time when I didn't
> run a userspace client.

And when you did run a foolish userspace client?

If you did it all in userspace, if the userspace code isn't being
called, the kernel build time should be the same as well :)

> If anyone can explain a way to get race free in kernel caching and out
> of kernel redirection and scanning I'd love it   :)

Again, do it all in userspace (caching, and scanning).  I still really
don't see the need to do this in the kernel becides it being "the way
people have always done it."

thanks,

greg k-h
