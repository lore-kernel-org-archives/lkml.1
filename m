Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbYEQBcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbYEQBcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYEQBcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:32:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbYEQBcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:32:06 -0400
Date: Fri, 16 May 2008 18:31:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression
 caused by bf726e "semaphore: fix,")
In-Reply-To: <87abip7p4l.fsf@duaron.myhome.or.jp>
Message-ID: <alpine.LFD.1.10.0805161812170.3020@woody.linux-foundation.org>
References: <20080510121020.f33c83f7.akpm@linux-foundation.org> <Pine.LNX.4.64.0805111150250.32758@titan.stealer.net> <20080511125731.GA28174@elte.hu> <alpine.LFD.1.10.0805110941540.3330@woody.linux-foundation.org> <20080511111210.77858eb4.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0805111221070.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805111243250.3188@woody.linux-foundation.org> <20080511235112.GA16101@elte.hu> <alpine.LFD.1.10.0805120155490.3514@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805120723440.3188@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805121659470.3514@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805121324410.3019@woody.linux-foundation.org> <alpine.LFD.1.10.0805161025510.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805160906580.2941@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org> <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org> <87abip7p4l.fsf@duaron.myhome.or.jp>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, OGAWA Hirofumi wrote:
> >  static struct inode *fat_alloc_inode(struct super_block *sb)
> >  {
> >  	struct msdos_inode_info *ei;
> > -	ei = kmem_cache_alloc(fat_inode_cachep, GFP_KERNEL);
> > +	ei = kmem_cache_alloc(fat_inode_cachep, GFP_NOFS);
> >  	if (!ei)
> >  		return NULL;
> >  	return &ei->vfs_inode;
> 
> Um... do we need this? I think this path is not called from memory
> allocation path...

The issue isn't that *this* is called by memory allocation paths, but 
whether this can hold the lock and then some memory allocation path calls 
back to the filesystem two write something out - and deadlock.

In other words, the chain is something like this:

	msdos_lookup
	  lock_super()			****
	  fat_build_inode ->
	    new_inode() ->
	      s->s_ops->alloc_inode = fat_alloc_inode ->
	        kmem_cache_alloc() ->
	          .. pageout ..
	            sync_inodes ->
	            (or any other writeout)
	              lock_super()	****

and now it deadlocks.

In other words, the kmem_cache_alloc() must _not_ be allowed to actually 
cause a filesystem writeout, and that's what GFP_NOFS is all about.

That said, just removing the lock-kernel entirely obviously would not have 
that problem either, but I feel safer at least keeping the same locking it 
had, rather than removing locking entirely.

		Linus
