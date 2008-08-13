Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYHMS6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYHMS6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYHMS6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:58:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYHMS6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:58:08 -0400
Subject: Re: TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
In-Reply-To: <20080813103951.1e3e5827@infradead.org>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813103951.1e3e5827@infradead.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 14:57:44 -0400
Message-Id: <1218653864.3540.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 10:39 -0700, Arjan van de Ven wrote:
> On Wed, 13 Aug 2008 12:36:15 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> [finally good description snipped]
> 
> > 
> > 1) Kernel or userspace.
> 
> this is kind of the last question to ask, not the first ;)
> 
> > Not to mention there cannot be any checks for files
> > opened by suid apps in userspace.  
> 
> setuid apps do not use glibc? news to me.

I was thinking about LD_PRELOAD.  you're right for most things it could
be glibc.  I still have knfsd on my side though.

> > And while no specific claims are
> > being made about intentionally malicious code, putting this in kernel
> > makes programs which call syscalls directly much more difficult to be
> > used to circumvent the scanning.
> 
> [so lets ignore this one]

/me doesn't want to ignore things that help his argument, even if they
are weak.  :)


> > 2) I think the "best" time to do scanning is at read and write.  Any
> > disagreements there?
> 
> I agree about the "read" case.
> "write" is tricky... because there's many vectors to write, from
> write() system call to mmap() system call to truncate() system call.
> (yes you can write a stream of bytes that passes virus scan, and then
> truncate to be suddenly a live virus)
> 
> I would propose to use the word "dirty" instead, we all know what we
> mean by that (it's all of them) and doesn't tie our thinking to the
> write() system call.
> 
> I would like to introduce a concept in your discussion you did not
> mention yet in this email: the difference between synchronous scanning
> and asynchronous scanning.

I already have that concept!  my open time scanning is sync and can
return an EACCESS.  my close time scanning is async and only updates the
in inode clean/dirty mark.  It makes no access decisions.  That way on
the next open we are good to go!  And yes yes, mmap write after close
invalides the async clean mark.

> It's clear from the protection model that you described that on 'read'
> you want to wait until the scan is done before you give the data to the
> process asking for it... and that's totally reasonable: "Do not give
> out bad data" is a very clear line in terms of security.
> 
> for the "dirty" case it gets muddy. You clearly want to scan "some
> time" after the write, from the principle of getting rid of malware
> that's on the disk, but it's unclear if this HAS to be synchronous.
> (obviously, synchronous behavior hurts performance bigtime so lets do
> as little as we can of that without hurting the protection).
> One advantage of doing the dirty case async (and a little time delayed)
> is that repeated writes will get lumped up into one scan in practice,
> saving a ton of performance.
> (scan-on-close is just another way of implementing "delay the dirty
> scan").
> Based on Alans comments, to me this sounds like we should have an
> efficient mechanism to notify userspace of "dirty events"; this is not
> virus scan specific in any way or form. And this mechanism likely will
> need to allow multiple subscribers.

I'm certainly willing to go down the inotify'ish path for async
notification of 'dirty' inodes instead of implement my own async
mechanism if I can find a way to do it.

> for the open() case, I would argue that you don't need synchronous
> behavior as long as the read() case is synchronous. I can imagine that
> open() kicks off an async scan, and if it's done by the time the first
> read() happens, no blocking at all happens.

An interesting addition.  Trying to keep these queues of events gets
much more complex, but if people really think the open to read race is
that important I've always said it wasn't impossible to close.

> For efficiency the kernel ought to keep track of which files have been
> declared clean, and it needs to track of a 'generation' of the scan
> with which it has been found clean (so that if you update your virus
> definitions, you can invalidate all previous scanning just by bumping
> the 'generation' number in whatever format we use). 
> Clearly the kernel needs to wipe this clean generation number on any
> modification to the file (inode) of any kind. And clearly this needs to
> be done inside the kernel because tracking dirty operations in any
> other way is just insane.

I agree!  i_talpa_seq_no I added to struct inode is exactly that!

> Now this to me we have a few basic building blocks:
> 1) We need an efficient mechanism to notify userspace of files that get
> dirtied. Virus scanners will subscribe to this for the async dirty
> scanning; indexing agents also will subscribe to this.
> 2) We very likely should have a mechanism for a userspace app to
> request a scan on a file, both sync or async (O_SYNC flag?). This is
> useful regardless because it allows the source of many things to do the
> right thing.

This means what exactly?  Some new syscall?  You want some program to
say "notify userspace about this inode" and then every userspace thing
that wants the notification gets it?  Not sure how much brains I want to
build into generic userspace apps.  I certainly wouldn't want to make
any userspace app easily be able to avoid AV scanning even if I make no
promises about malicious apps.  Just because I don't make gurantees
doesn't mean I should make it easy.  Just because I can't be 100% that a
fence won't keep the kids from falling in the pool doesn't mean I
shouldn't build it.  Differentiating between don't AV scan and don't
index is going to be hard in a single interface, but not unsolvable.

> 3) we need a mechanism in the kernel to track "scanned with generation
> X of signatures" that invalidates on any dirty operation. The syscall
> from 2) will use this as a cache to be quick.

i_talpa_seq_no

> I think few people will disagree about this.
> 
> Open questions now are
> 4) do we have the kernel kick off an async scan in open() or do we have
> glibc do this
> 5) do we have the kernel do the sync scan on read/mmap/.. or do we have
> glibc do this

scan on mmap read?  How do I implement this?  Do we update atime on mmap
read?  can I do it there like I do for writes with mtime?

> I think this is where the whole debate is about now.
> 
> 
> And a few hard ones
> 6) how do we deal with multiple scanning agents in parallel

My first suggestion is we don't, and worry about it as soon as we have
the first parallel users.

> 7) how do we prevent malware from pretending to be a virus scanner

We don't.  Let the LSM do its job?

