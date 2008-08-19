Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYHSWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYHSWTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYHSWTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:19:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbYHSWTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:19:01 -0400
Date: Tue, 19 Aug 2008 15:17:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Trojanowski <bart@jukie.net>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
In-Reply-To: <20080819220311.GA28029@jukie.net>
Message-ID: <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org>
References: <20080819220311.GA28029@jukie.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Bart Trojanowski wrote:
> 
> I was able to bisect it to the commit 8f5934278d1d86590244c2791b28f77d67466007
> which claims to "Replace BKL with superblock lock in fat/msdos/vfat".
> 
> When I run with lock debugging I get...
> 
>   =============================================
>   [ INFO: possible recursive locking detected ]
>   2.6.27-rc3-bisect-00448-ga7f5aaf #16
>   ---------------------------------------------
>   mv/4020 is trying to acquire lock:
>    (&type->s_lock_key#9){--..}, at: [<c01a90fe>] lock_super+0x1e/0x20
>   
>   but task is already holding lock:
>    (&type->s_lock_key#9){--..}, at: [<c01a90fe>] lock_super+0x1e/0x20

Thanks for the excellent debug.

> It looks like the call trace is:
> 
>  - do_unlinkat
>    - vfs_unlink
>      - vfat_unlink
>        * lock_super
>        - fat_remove_entries
>          - fat_sync_inode
>            - fat_write_inode
>              * lock_super

Very much so.

And I think you hit this issue because you probably mounted the USB stick 
as a "sync" (or dirsync) mount - which is what some distros do by default, 
even if it is known to cause problems for some flash cards that don't do a 
good job at wear levelling.

But it's good that you did that, because all _my_ testing (which was 
admittedly very deficient) had been done with a default mount without that 
thing.

> So this code really really liked BKL because it was recursive.

Yeah, we had some other cases like that. It's the main source of BKL 
problems by far (if it wasn't for the recursion, BKL removal would 
generally be trivial).

The other example of this was 9c20616c385ebeaa30257ef5d35e8f346db4ee32, 
where fat_setattr->fat_truncate caused a deadlock.

> I am testing a naive patch to address this problem and will follow up on 
> it in a bit.

Thanks.

Btw, quite often, the right solution may be to remove one of the locks 
entirely. FAT should actually have been largely BKL free, and my 
conversion of BKL to super-lock was "overly eager" exactly because it's 
easier to find deadlocks (and debug things carefully and handle them as 
they pop up) than it is to find races (which are almost impossible to 
debug and pinpoint).

In particular, I think fat_write_inode() really is safe. It already uses 

	spin_lock(&sbi->inode_hash_lock);
	..
	spin_unlock(&sbi->inode_hash_lock);

to protect its internal data structures, and all that [un]lock_super() 
protects is really just local variables and code that is already SMP-safe 
(ie "sb_bread()" certainly doesn't need locking.

So I'm pretty sure the right fix is to just remove [un]lock_super() 
entirely from fat_write_inode(). 

		Linus
