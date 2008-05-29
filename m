Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYE2Upv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYE2Upv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbYE2Upk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:45:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:9584 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYE2Upj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OPan/3J3UlOHkB5+ec1FZHcMh/g78rpO+AMQ3X+DrvafmwiOMjFxvlpa+iXvds0YDj7IqGR3yOAHsbafOP8AHyraMlqZijq9HZvmLnrtQqjabCSJnHkLzuutBEUDJ528KsysvntndgSTbSoFXf7mN4UwpQqCXr0IMr94+4hoaEI=
Message-ID: <12c511ca0805291345u4885bd1ycc83bbaa75acfc47@mail.gmail.com>
Date: Thu, 29 May 2008 13:45:37 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression caused by bf726e "semaphore: fix,")
Cc: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       corbet@lwn.net
In-Reply-To: <alpine.LFD.1.10.0805161812170.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080510121020.f33c83f7.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0805120723440.3188@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805121659470.3514@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0805121324410.3019@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805161025510.3255@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0805160906580.2941@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
	 <87abip7p4l.fsf@duaron.myhome.or.jp>
	 <alpine.LFD.1.10.0805161812170.3020@woody.linux-foundation.org>
X-Google-Sender-Auth: 56061c03200273f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a process hang running a kernel built from the linux-next tree
with tag next-20080529 The problem commit looks to be:
35e447fc2fa408df8af2c8735f83a90cafe651ff

"Replace BKL with superblock lock in fat/msdos/vfat"

This causes a lockup when overwriting an existing file
on a vfat filesystem.  E.g. for me (where there already
exists a vmlinux.gz file in the target directory):

# cp --force vmlinux.gz /boot/efi/efi/redhat/

Stack trace looks like this:
Call Trace:
 [<a000000100712550>] schedule+0x11f0/0x1380
                                sp=e0000001bd55fc30 bsp=e0000001bd5510b8
 [<a000000100714cb0>] __mutex_lock_slowpath+0x2d0/0x520
                                sp=e0000001bd55fc50 bsp=e0000001bd551060
 [<a000000100714f20>] mutex_lock+0x20/0x40
                                sp=e0000001bd55fc80 bsp=e0000001bd551040
 [<a0000001001367d0>] lock_super+0x30/0x60
                                sp=e0000001bd55fc80 bsp=e0000001bd551020
 [<a00000010028ca30>] fat_truncate+0xb0/0x640^M
                                sp=e0000001bd55fc80 bsp=e0000001bd550fa0
 [<a0000001000fd930>] vmtruncate+0x1f0/0x260
                                sp=e0000001bd55fce0 bsp=e0000001bd550f70
 [<a000000100164250>] inode_setattr+0x50/0x320
                                sp=e0000001bd55fcf0 bsp=e0000001bd550f38
 [<a00000010028d520>] fat_setattr+0x4c0/0x580
                                sp=e0000001bd55fcf0 bsp=e0000001bd550ed0
 [<a0000001001648e0>] notify_change+0x3c0/0x620
                                sp=e0000001bd55fd10 bsp=e0000001bd550e70
 [<a00000010012fe00>] do_truncate+0xc0/0x120
                                sp=e0000001bd55fd30 bsp=e0000001bd550e30
 [<a0000001001494c0>] may_open+0x340/0x3a0
                                sp=e0000001bd55fd80 bsp=e0000001bd550de0
 [<a000000100149c60>] do_filp_open+0x740/0x11c0
                                sp=e0000001bd55fd80 bsp=e0000001bd550d18
 [<a000000100132470>] do_sys_open+0x90/0x1c0
                                sp=e0000001bd55fe30 bsp=e0000001bd550cc8
 [<a0000001001325f0>] sys_open+0x50/0x80
                                sp=e0000001bd55fe30 bsp=e0000001bd550c70

Looking at fat_setattr() I see it calls lock_super() at the start and releases
it at the end.  In between is the call to inode_setattr() ... which calls
down through inode_setattr() and vmtruncate() to fat_truncate() ...
which calls lock_super() again. Deadlock.

-Tony
