Return-Path: <linux-kernel-owner+w=401wt.eu-S1764520AbYHDWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764520AbYHDWf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYHDWfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:35:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763671AbYHDWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:35:03 -0400
Date: Mon, 4 Aug 2008 15:32:49 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080804223249.GA10517@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217883616.27684.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:
> Please contact me privately or (preferably the list) for questions,
> comments, discussions, flames, names, or anything.  I'll do complete
> rewrites of the patches if someone tells me how they don't meet their
> needs or how they can be done better.  I'm here to try to bridge the
> needs (and wants) of the anti-malware vendors with the technical
> realities of the kernel.  So everyone feel free to throw in your two
> cents and I'll try to reconcile it all.  These 5 patches are part 1.
> They give us a working able solution.
> 
> >From my point of view patches forthcoming and mentioned below should
> help with performance for those who actually have userspace scanners but
> also could presents be implemented using this framework.
> 
> 
> Background
> ++++++++++
> There is a consensus in the security industry that protecting against
> malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
> of so-called on-access scanning is usable and reasonable approach.
> Currently the Linux kernel does not offer a completely suitable
> interface to implement such security solutions.  Present solutions
> involve overwriting function pointers in the LSM, in filesystem
> operations, in the sycall table, and other fragile hacks.  The purpose
> of this project is to create a fast, clean interface for userspace
> programs to look for malware when files are accessed.  This malware may
> be ultimately intended for this or some other Linux machine or may be
> malware intended to attack a host running a different operating system
> and is merely in transit across the Linux server.  Since there are
> almost an infinite number of ways in which information can enter and
> exit a server it is not seen as reasonable to move these checks to all
> the applications at the boundary (MTA, NFS, CIFS, SSH, rsync, et al.) to
> look for such malware on at the border.
> 
> For this Linux kernel interface speed is of particular interest for
> those who have it compiled into the kernel but have no userspace client.
> There must be no measurable performance hit to just compiling this into
> the kernel.
> 
> Security vendors, Linux distributors and other interested parties have
> come together on the malware-list mailing list to discuss this problem
> and see if they can work together to propose a solution. During these
> talks couple of requirement sets were posted with the aim of fleshing
> out common needs as a prerequisite of creating an interface prototype.

These requirements were posted?  Where?  I don't recall seeing them.

> Collated requirements
> +++++++++++++++++++++
>   1. Intercept file opens (exec also) for vetting (block until
>   decision is made) and allow some userspace black magic to make
>   decisions.
>   2. Intercept file closes for scanning post access
>   3. Cache scan results so the same file is not scanned on each and every access
>   4. Ability to flush the cache and cause all files to be re-scanned when accessed
>   5. Define which filesystems are cacheable and which are not
>   6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.
>   7. Report other relevant file, process and user information associated with each interception
>   8. Report file pathnames to userspace (relative to process root, current working directory)
>   9. Mark a processes as exempt from on access scanning
>  10. Exclude sub-trees from scanning based on filesystem (exclude procfs, sysfs, devfs)
>  11. Exclude sub-trees from scanning based on filesystem path
>  12. Include only certain sub-trees from scanning based on filesystem path
>  13. Register more than one userspace client in which case behavior is restrictive

I don't see anything in the list above that make this a requirement that
the code to do this be placed within the kernel.

What is wrong with doing it in glibc or some other system-wide library
(LD_PRELOAD hooks, etc.)?

> 1., 2. Basic interception
> -------------------------
> Core requirement is to intercept access to files and prevent it if
> malicious content is detected.  This is done on open, not on read.  It
> may be possible to do read time checking with minimal performance impact
> although not currently implemented.  This means that the following race
> is possible
> 
>    Process1              Process2
>     - open file RD
>                           - open file WR
>                           - write virus data (1)
>     - read virus data

Wonderful, we are going to implement a solution that is known to not
work, with a trivial way around it?

Sorry, that's not going to fly.

> *note that any open after (1) will get properly vetted.  At this time
> the likely hood of this being a problem vs the performance impact of
> scanning on read and the increased complexity of the code means this is
> left out.  This should not be a problem for local executables as writes
> to files opened to be run typically return ETXTBSY.

Are you sure about this?

> One of the most important filters in the evaluation chain implements an
> interface through which an userspace process can register and receive
> vetting requests. Userspace process opens a misc character device to
> express its interest and then receives binary structures from that
> device describing basic interception information. After file contents
> have been scanned a vetting response is sent by writing a different
> binary structure back to the device and the intercepted process
> continues its execution.  These are not done over network sockets and no
> endian conversions are done.  The client and the kernel must have the
> same endian configuration.

How about the same 64/32bit requirement?  Your implementation is
incorrect otherwise.

(hint, your current patch is also wrong in this area, you should fix
that up...)

And a binary structure?  Ick, are you trying to make it hard for future
expansions and such?

And why not netlink/network socket?  Why a character device?  You are
already using securityfs, why not use a file node in there?

> 6. Direct access to file content
> --------------------------------
> When an userspace daemon receives a vetting request, it also receives a
> new RO file descriptor which provides direct access to the inode in
> question. This is to enable access to the file regardless of it
> accessibility from the scanner environment (consider process namespaces,
> chroot's, NFS).  The userspace client is responsible for closing this
> file when it is finished scanning.

Is this secondary file handle properly checked for the security issues
involved with such a thing?  What happens if the userspace client does
not close the file handle?

> 7. Other reporting
> ------------------
> Along with the fd being installed in the scanning process the process
> gets a binary structure of data including: 

What's with the love of binary structures? :)

> +       uint32_t version;
> +       uint32_t type;
> +       int32_t fd;
> +       uint32_t operation;
> +       uint32_t flags;
> +       uint32_t mode;
> +       uint32_t uid;
> +       uint32_t gid;
> +       uint32_t tgid;
> +       uint32_t pid;

What happens when the world moves to 128bit or 64bit uids?  (yes, I've
seen proposals for such a thing...)

Why would userspace care about these meta-file things, what does it want
with them?

> 8. Path name reporting
> ----------------------
> When a malicious content is detected in a file it is important to be
> able to report its location so the user or system administrator can take
> appropriate actions.
> 
> This is implemented in a amazingly simple way which will hopefully avoid
> the controversy of some other solutions. Path name is only needed for
> reporting purposes and it is obtained by reading the symlink of the
> given file descriptor in /proc.  Its as simple as userspace calling:
> 
> snprintf(link, sizeof(link), "/proc/self/fd/%d", details.fd);
> ret = readlink(link, buf, sizeof(buf)-1);

Cute hack.  What's to keep it from racing with the fd changing from the
original program?

> 9. Process exclusion
> --------------------
> Sometimes it is necessary to exclude certain processes from being
> intercepted. For example it might be a userspace root kit scanner which
> would not be able to find root kits if access to them was blocked by the
> on-access scanner.
> 
> To facilitate that we have created a special file a process can open and
> register itself as excluded. A flag is then put into its kernel
> structure (task_struct) which makes it excluded from scanning.
> 
> This implementation is very simple and provides greatest performance. In
> the proposed implementation access to the exclusion device is controlled
> though permissions on the device node which are not sufficient.  An LSM
> call will need to be made for this type or access in a later patch.

Heh, so if you want to write a "virus" for Linux, just implement this
flag.  What's to keep a "rogue" program from telling the kernel that all
programs on the system are to be excluded?

> 10. Filesystem exclusions
> -------------------------
> One pretty important optimization is not to scan things like /proc, /sys
> or similar. Basically all filesystems where user can not store
> arbitrary, potentially malicious, content could and should be excluded
> from scanning.

Why, does scanning these files take extra time?  Just curious.

> 11. Path exclusions
> -------------------
> The need for exclusions can be demonstrated with an example of a MySQL
> server. It's data files are frequently modified which means they would
> need to be constantly rescanned which is very bad for performance. Also,
> it is most often not even possible to reasonably scan them. Therefore
> the best solution is not to scan its database store which can simply be
> implemented by excluding the store subdirectory.
> 
> It is a relatively simple implementation which allows run-time
> configuration of a list of sub directories or files to exclude.
> Exclusion paths are relative to each process root. So for example if we
> want to exclude /var/lib/mysql/ and we have a mysql running in a chroot
> where from the outside that directory actually lives
> in /chroot/mysql/var/lib/mysql, /var/lib/mysql should actually be added
> to the exclusion list.
> 
> This is also not included in the initial patch set but will be coming
> shortly after.

Again, what's to keep all files to be marked as excluded?

> Closing remarks
> ---------------
> Although some may argue some of the filters are not necessary or may
> better be implemented in userspace, we think it is better to have them
> in kernel primarily for performance reasons.

Why?  What numbers do you have that say the kernel is faster in
implementing this?  This is the first mention of such a requirement, we
need to see real data to back it up please.

> Secondly, it is all simple code not introducing much baggage or risk
> into the kernel itself.

I disagree, see above.

thanks,

greg k-h
