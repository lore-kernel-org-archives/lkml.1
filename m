Return-Path: <linux-kernel-owner+w=401wt.eu-S1765868AbXLNVQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765868AbXLNVQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXLNVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:16:37 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:52896 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXLNVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:16:36 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [UNIONFS] 00/42 Unionfs and related patches review 
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <200712131529.lBDFT5Ch025553@agora.fsl.cs.sunysb.edu>
References: Your message of "Mon, 10 Dec 2007 12:20:20 +0900." <E1J1ZBs-0006M0-VL@jroun> <200712131529.lBDFT5Ch025553@agora.fsl.cs.sunysb.edu>
Date: Sat, 15 Dec 2007 06:15:59 +0900
Message-Id: <E1J3Ht2-0000mH-0V@jroun>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Professor Zadok,

Erez Zadok:
> I believe that small VFS changes to help stackable file systems are
> perfectly reasonable, and a good thing; and I'm working on such patches.
> Conversely, I am very mindful of the VFS's complexity, so I also believe
> that massive VFS changes are a bad thing; I want to avoid bloating the VFS
> or de-stabilizing it just for the sake of stacking or any single stackable
> f/s.  I am also concerned about not changing existing "lower" file systems
> whatsoever, because they are well tested and stable.

I have no objection against your opinion about massive VFS changes or
existing "lower" filesystems.


> from).  So in my opinion, the chances are very slim that a large amount of
> data changes will happen on a lower inode all within one second and not be
> detected by our mtime/cite cache-coherency algorithms.

I agree that time-based checking is available in many cases.
But there will exist some opeartions which are done in one
second, and it may not be available when a user changes the clock/time
of his system.


> Also, time-based cache coherency is a [sic] time-honored technique in NFS.
> Users have gotten used to the fact that if they change something on the
> server (i.e., the "layer" below the client), that those changes many not be
> immediately visible on the client (esp. with heavy caching on the client).
> So if it's been good enough for NFS for over two decades, I don't see a
> compelling reason to complicate unionfs for a slim chance of detecting
> changes that occur within one second.

Since NFS is a remote filesystem, I don't think it is a good idea to
compare the behaviour of if and a stackable filesystem, since all
lower(branch) filesystems are able to be local filesystems.


> Right now my code to detect when a lower object has changed is very simple
> and short: just one "if" statement to compare the corresponding inode
> mtimes.  I'd like to keep things simple if at all possible.  Fundamentally,
> all I need is ONE simple bit of information that will tell me that the upper
> and lower inodes are no longer in sync.  Just one bit, not a whole complex
> data structure with callbacks and bit-maps and such.

Agreed, so the inotify handler should set a flag or atomic_inc/dec
the internal generation, or enqueue such job and handle it
later (shortly). Of course, when the dentry/inode of the stackable
filesystem corresspoding to the modfied file are not cached, the handler
has nothing to do.
Additionally, it is only directories to be set inotify for monitoring,
instead of all files. The inotify handler for a directory receives all
necessary (for a stackable fs) events for its children.
(but there are a few limitations or exceptions)


> What you propose violates the clean layer separation in a way that I'm not
> too comfortable with (even if it works for you :-) I believe stackable file
	:::
> system, each struct file/dentry/inode has a corresponding lower object.  Our
> FiST templates for Linux include an extra mode---called "fist lite"---which
> saves on inodes and pages by having BOTH the upper and lower dentry point to
> the lower inode.  This saves memory (shared pages) and reduces layering
> overhead (but you can't intercept mmap ops, which some stackable f/s like to
> do).  The cost of such trick is violating the clean layering separation: a
> dentry of the upper file system now points to an inode (via dentry->d_inode)
> of the lower file system!  To me, this is dangerous in the long run because
> objects from one layer can be "leaked" to another layer, with potentially
> disastrous results.

Currently, I don't think sharing page is any kind of
violation. Additionally the dentry of the upper file system does NOT
point to the inode of the lower file system. Of course it can implement
->mmap operation.


> What you propose above with vm_operations requires a sequence of operations
> in the vm->fault operation which looks like:
> 
> 	saved_file = vma->vm_file;
> 	vma->vm_file = hidden_file;
> 	call the lower ->fault op passing it the modified vma
> 	vma->vm_file = saved_file;

Basically, yes.
But there are several things to do such as locking.


> Even if both of these techniques work (and they do, at least in limited
> testing I've done), there is something very unpleasant about having to
> temporarily override a field's value, then fix it again, after coming back
> from calling the lower op.  Aside from the uncleanliness of this kind of
> technique, it can seriously lead to races and other data corruptions when/if
> the temporarily-fixed fields "leak" outside the current code.  (I have a
> strong feeling that several kernel developers might vomit in disgust if I
> dared to submit such hacky patches to unionfs... :-)

I guess probably you forgot some locking.


> To me, any time such a hack has to be employed, it tells me that there's
> something wrong with the API in question.  And so I'd much rather see the
> API fixed The Right Way[tm], than promote such potentially unsafe practices.

If you changed some important members of internal structures without
locking, it would be unsafe and violate something.

Finally I think the approach of sharing pages, you may call it
zero-copy conversely your approach, is safe. At least, this approach is
working over a year while several people are using it.
Of course, I never say it is bug-free. There may exist a problem which
simply I don't know yet.


Sincerely,
Junjiro Okajima
