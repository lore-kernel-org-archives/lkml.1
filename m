Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbYBZCBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbYBZCBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbYBZCBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:01:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063AbYBZCBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:01:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200802251643.16631.phillips@phunq.net>
References: <200802251643.16631.phillips@phunq.net> <200802251401.16413.phillips@phunq.net> <17916.1203636833@redhat.com> <22888.1203981562@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 26 Feb 2008 02:00:50 +0000
Message-ID: <24873.1203991250@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> wrote:

> On Monday 25 February 2008 15:19, David Howells wrote:
> > So I guess there's a problem in cachefiles's efficiency - possibly due
> > to the fact that it tries to be fully asynchronous.
> 
> OK, not just my imagination, and it makes me feel better about the patch 
> set because efficiency bugs are fixable while fundamental limitations 
> are not.

One can hope:-)

> How much of a hurry are you in to merge this feature?  You have bits 
> like this:

I'd like to get it upstream sooner rather than later.  As it's not upstream,
but it's prerequisite patches touch a lot of code, I have to spend time
regularly making my patches work again.  Merge windows are completely not fun.

> "Add a function to install a monitor on the page lock waitqueue for a 
> particular page, thus allowing the page being unlocked to be detected.
> This is used by CacheFiles to detect read completion on a page in the 
> backing filesystem so that it can then copy the data to the waiting 
> netfs page."
> 
> We already have that hook, it is called bio_endio.

Except that isn't accessible.  CacheFiles currently has no access to the
notification from the blockdev to the backing fs, if indeed there is one.  All
we can do it trap the backing fs page becoming available.

> My strong intuition is that your whole mechanism should sit directly on the
> block device, no matter how attractive it seems to be able to piggyback on
> the namespace and layout management code of existing filesystems.

There's a place for both.

Consider a laptop with a small disk, possibly subdivided between Linux and
Windows.  Linux then subdivides its bit further to get a swap space.  What you
then propose is to break off yet another chunk to provide the cache.  You
can't then use this other chunk for anything else, even if it's, say, 1% used
by the cache.

The way CacheFiles works is that you tell it that it can use up to a certain
percentage of the otherwise free disk space on an otherwise existing
filesystem.  In the laptop case, you may just have a single big partition.  The
cache will fill up as much of it can, and as the other contents of the
partition consume space, the cache will be culled to make room.

On the other hand, a system like my desktop, where I can slap in extra disks
with mound of extra disk space, it might very well make sense to commit block
devices to caching, as this can be used to gain performance.

I have another cache backend (CacheFS) which takes the form of a filesystem,
thus allowing you to mount a blockdev as a cache.  It's much faster than Ext3
at storing and retrieving files... at first.  The problem is that I've mucked
up the free space retrieval such that performance degrades by 20x over time for
files of any size.

Basically any cache on a raw blockdev _is_ a filesystem, just one in which
you're randomly allowed to discard data to make life easier.

> I see your current effort as the moral equivalent of FUSE: you are able to
> demonstrate certain desirable behavioral properties, but you are unable to
> reach full theoretical efficiency because there are layers and layers of
> interface gunk interposed between the netfs user and the cache device.

The interface gunk is meant to be as thin as possible, but there are
constraints (see the documentation in the main FS-Cache patch for more
details):

 (1) It's a requirement that it only be tied to, say, AFS.  We might have
     several netfs's that want caching: AFS, CIFS, ISOFS (okay, that last isn't
     really a netfs, but it might still want caching).

 (2) I want to be able to change the backing cache.  Under some circumstances I
     might want to use an existing filesystem, under others I might want to
     commit a blockdev.  I've even been asked about using battery-backed RAM -
     which has different design constraints.

 (3) The constraint has been imposed by the NFS team that the cache be
     completely asynchronous.  I haven't quite met this: readpages() will wait
     until the cache knows whether or not the pages are available on the
     principle that read operations done through the cache can be considered
     synchronous.  This is an attempt to reduce the context switchage involved.

Unfortunately, the asynchronicity requirement has caused the middle layer to
bloat.  Fortunately, the backing cache needn't bloat as it can use the middle
layer's bloat.

> That said, I also see you have put a huge amount of work into this over 
> the years, it is nicely broken out, you are responsive and easy to work 
> with, all arguments for an early merge.  Against that, you invade core 
> kernel for reasons that are not necessarily justified:
>
>   * two new page flags

I need to keep track of two bits of per-cached-page information:

 (1) This page is known by the cache, and that the cache must be informed if
     the page is going to go away.

 (2) This page is being written to disk by the cache, and that it cannot be
     released until completion.  Ideally it shouldn't be changed until
     completion either so as to maintain the known state of the cache.

I could set up a radix tree per data storage object to keep track of both these
points, however this would mean that the netfs would have to do a call,
spinlock, conditional jumps, etc to find out either state.

On the other hand, if we can spare two page flags, those are sufficient.

Note that the cache doesn't necessarily need to be able to find the netfs
pages, but may have to pin resources for backing them.

Further note that PG_private may not be used as I want to be able to use
caching with ISOFS eventually.

>   * a new fileops method

Do you mean a new address space ops method?  Yes.  I have to be able to write
from a kernel page without the use of a struct file.  The struct file isn't
actually necessary to do the write, and so is a waste of space.  What's worse
is that the struct file plays havoc with resource limits and ENFILE production.

Ideally I want a couple of hooks: one to do O_DIRECT writing to a file from
kernel pages, one to do O_DIRECT|O_NOHOLE reading from a file to kernel pages
(holes in cache files represent blocks not retrieved from the server, so I want
to see ENODATA not a block of zeros).

>   * many changes to LSM including new object class and new hooks
>   * separate fs*id from task struct

It has been required that I call vfs_mkdir() and suchlike rather than bypassing
security and calling inode ops directly.  Therefore the VFS and LSM get to deny
the caching kernel modules access to the cache data because under some
circumstances the caching code is running in the security context of whatever
process issued the original syscall on the netfs.

Furthermore, the security parameters with which a file is created (UID, GID,
security label) would be derived from that process that issued the system call,
thus potentially preventing other processes from accessing the cache, in
particular cachefilesd.

So, what is required is to temporarily override the security of the process
that issued the system call.  We can't, however, just do an in-place change of
the security data as that affects the process as an object, not just as a
subject.  This means it may lose signals or ptrace events for example, and
affect what the task looks like in /proc.

So what I've done is to make a logical slit in the security between the
objective security (task->sec) and the subjective security (task->act_as).  The
objective security holds the intrinsic security properties of a process and is
never overridden.  This is what appears in /proc, and is used when a process is
the target of an operation by some other process (SIGKILL for example).

The subjective security holds the active security properties of a process, and
may be overridden.  This is not seen externally, and is used whan a process
acts upon another object, for example SIGKILLing another process or opening a
file.

The new hooks allow SELinux (or Smack or whatever) to reject a request for a
kernel service (such as cachefiles) to run in a context of a specific security
label or to create files and directories with another security label.  These
hooks may also be useful for NFSd.

>   * new page-private destructor hook

The cache may attach state to pages before read_cache_pages() is called.
Therefore read_cache_pages() may need to arrange for it to be cleaned up.  The
only way it can know to do this is by examining the page flags.  PG_private may
not be overloaded because it is owned by fs/buffer.c and friends on things like
ISOFS.

>   * probably other bits I missed

Note that most of these things have been muchly argued over already.

> Would it be correct to say that some of these changes are to support 
> disconnected operation?

No.

> You have some short snappers that look generally useful:
> 
>   * add_wait_queue_tail (cool)

Which you complained about above.

>   * write to a file without a struct file (includes ->mapping cleanup,
>     probably good)

Ditto.

>   * export fsync_super

> Why not hunt around for existing in-kernel users that would benefit so 
> these can be submitted as standalone patches, shortening the remaining 
> patch set and partially overcoming objections due to core kernel 
> changes?

The only ones that really fall into that category are the security patches,
which admittedly affect a lot of places.  That might be acceptable, and the
thought has occurred to me, because of NFSd.

> One thing I don't see is users coming on to lkml and saying "please 
> merge this, it works great for me".  Since you probably have such 
> users, why not give them a poke? 

The problem is that I'm stuck on waiting for the NFS guys to okay the NFS
patches.

> Your cachefilesd is going to need anti-deadlock medicine like ddsnap 
> has.

You mean the userspace daemon?  Why should it deadlock?

> Since you don't seem at all worried about that right now, I suspect you have
> not hammered this code really heavily, correct?

I had run iozone on cached NFS prior to asynchronising it.  However, I've found
a bug in my thread pool code that I'm currently chasing, so I need to do more
parallelisation testing

> Without preventative measures, any memory-using daemon sitting in the block
> IO path will deadlock if you hit it hard enough.

cachefilesd doesn't actually seem to consume that much memory, and it's
unlikely to deadlock as it only does one thing at once and has no locking.

There is a potential race though between cachefilesd's cull scanner and someone
scanning through all the files that are cached in the same order over and over
again.  The problem is that we cannot keep the view of old stuff in the cache
up to date, no matter how hard we try.  I haven't thought of a good way around
that.

> A couple of years ago you explained the purpose of the new page flags to 
> me and there is no way I can find that email again.  Could you explain 
> it again please?  Meanwhile I am doing my duty and reading your OLS 
> slides etc.

See above.

David
