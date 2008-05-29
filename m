Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYE2Vhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYE2Vhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYE2Vhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:37:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998AbYE2Vhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:37:42 -0400
Date: Thu, 29 May 2008 14:37:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Luck <tony.luck@intel.com>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       corbet@lwn.net
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression
 caused by bf726e "semaphore: fix,")
In-Reply-To: <12c511ca0805291345u4885bd1ycc83bbaa75acfc47@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805291413490.3873@woody.linux-foundation.org>
References: <20080510121020.f33c83f7.akpm@linux-foundation.org>  <alpine.LFD.1.10.0805120723440.3188@woody.linux-foundation.org>  <alpine.LFD.1.10.0805121659470.3514@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0805121324410.3019@woody.linux-foundation.org>
  <alpine.LFD.1.10.0805161025510.3255@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0805160906580.2941@woody.linux-foundation.org>  <alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org>  <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
  <87abip7p4l.fsf@duaron.myhome.or.jp>  <alpine.LFD.1.10.0805161812170.3020@woody.linux-foundation.org> <12c511ca0805291345u4885bd1ycc83bbaa75acfc47@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Tony Luck wrote:
> 
> This causes a lockup when overwriting an existing file
> on a vfat filesystem.  E.g. for me (where there already
> exists a vmlinux.gz file in the target directory):

Thanks, that was something I didn't test. I just tested various simple 
file create/delete/read/write.

> Looking at fat_setattr() I see it calls lock_super() at the start and releases
> it at the end.  In between is the call to inode_setattr() ... which calls
> down through inode_setattr() and vmtruncate() to fat_truncate() ...
> which calls lock_super() again. Deadlock.

Yup.

And as far as I can tell there is absolutely nothing in fat_setattr() that 
we actually want to protect - it calls things like fat_cont_expand(), but 
that just calls down to the generic VFS layer that uses the pagecache 
functions, and those need to handle the locking correctly for other 
reasons (totally unrelated to setattr - they get called without locking 
for regular writes, after all).

So it looks like the correct fix is to just remove the lock_super() in 
fat_setattr() entirely (along with the "sb" variable that is then no 
longer used).

It *also* turns out that we should remove the lock_super() from 
fat_truncate: all the truncate paths already hold the inode mutex from the 
VFS layer, so the inode data structures themselves would be serialized for 
other reasons. And it only protects the call to "fat_free()", which in 
turn calls the FAT cluster routines ("fatent") that already are protected 
by the fatent spinlock.

More importantly, if it's a filesystem marked DIRSYNC, it will call 
"fat_sync_inode()", which takes the superblock lock (and needs it, because 
it's called frm the VFS layer too) and would deadlock there.

So the end result of that is all the "lock_kernel()" calls in 
fs/fat/file.c should actually just go away - not be replaced by 
lock_super() at alL!

Jonathan, do you want an updated replacement patch, or an incremental one, 
or will you just do that trivial fix yourself?

			Linus
