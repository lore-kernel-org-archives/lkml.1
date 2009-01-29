Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZA2KDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZA2KDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZA2KD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:03:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:64810 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZA2KD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tiow+ATBOqucdFS6AfO3ZNyDwlIISo6kCyGrGhMQVJ/B0V4TPm2sBbZ51U71nPDp8g
         5DIo9EZ8Gbp/zEWadEqCsLYojnEXd2IC4tjxtUkK7diaHFgCd/Y0FStqRR6B0pZ8xvxi
         yk5tVrk5W5sQUePEg0cS5T6PmyXqIC56hK7Xo=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901291009220.13600@anakin>
References: <200901272137.57757.arvidjaar@mail.ru>
	 <Pine.LNX.4.64.0901291009220.13600@anakin>
Date: Thu, 29 Jan 2009 11:03:24 +0100
Message-ID: <a2776ec50901290203k427868bq5d863ae82a98b4ca@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [2.6.29-rc2] fb_mmap: circular locking 
	dependency on hibernation
From: Andrea Righi <righi.andrea@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 10:10 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, 27 Jan 2009, Andrey Borzenkov wrote:
>> I do not know if this is new; I usually do not hibernate at all and was
>> testing another driver actually. I do not remember such issues in 2.6.28
>> though. Dmesg follows; config attached.
>
>> [11715.652498] =======================================================
>> [11715.652520] [ INFO: possible circular locking dependency detected ]
>> [11715.652534] 2.6.29-rc2-1avb #11
>> [11715.652541] -------------------------------------------------------
>> [11715.652550] s2disk/25519 is trying to acquire lock:
>> [11715.652562]  (&fb_info->lock){--..}, at: [<c0223017>] fb_mmap+0x97/0x170
>> [11715.652623]
>> [11715.652625] but task is already holding lock:
>> [11715.652632]  (&mm->mmap_sem){----}, at: [<c010639e>] sys_mmap2+0x8e/0xc0
>> [11715.652669]
>> [11715.652671] which lock already depends on the new lock.
>> [11715.652675]
>> [11715.652681]
>> [11715.652683] the existing dependency chain (in reverse order) is:
>> [11715.652691]
>> [11715.652693] -> #1 (&mm->mmap_sem){----}:
>> [11715.652707]        [<c0144ecf>] __lock_acquire+0x129f/0x1930
>> [11715.652730]        [<c01455bc>] lock_acquire+0x5c/0x80
>> [11715.652742]        [<c0181e57>] might_fault+0x77/0xa0
>> [11715.652764]        [<c0209325>] copy_from_user+0x35/0x130
>> [11715.652782]        [<c0223ef5>] fb_ioctl+0x1d5/0x3f0
>> [11715.652797]        [<c01a51d0>] vfs_ioctl+0x20/0x80
>> [11715.652832]        [<c01a53e2>] do_vfs_ioctl+0x72/0x570
>> [11715.652845]        [<c01a5919>] sys_ioctl+0x39/0x70
>> [11715.652857]        [<c0103371>] sysenter_do_call+0x12/0x31
>> [11715.652870]        [<ffffffff>] 0xffffffff
>> [11715.652973]
>> [11715.652975] -> #0 (&fb_info->lock){--..}:
>> [11715.652988]        [<c014503c>] __lock_acquire+0x140c/0x1930
>> [11715.653000]        [<c01455bc>] lock_acquire+0x5c/0x80
>> [11715.653011]        [<c030761a>] mutex_lock_nested+0xba/0x2f0
>> [11715.653032]        [<c0223017>] fb_mmap+0x97/0x170
>> [11715.653044]        [<c0188996>] mmap_region+0x1d6/0x530
>> [11715.653067]        [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
>> [11715.653079]        [<c01063bd>] sys_mmap2+0xad/0xc0
>> [11715.653091]        [<c0103371>] sysenter_do_call+0x12/0x31
>> [11715.653102]        [<ffffffff>] 0xffffffff
>> [11715.653116]
>> [11715.653119] other info that might help us debug this:
>> [11715.653122]
>> [11715.653130] 1 lock held by s2disk/25519:
>> [11715.653137]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]
>> sys_mmap2+0x8e/0xc0
>> [11715.653156]
>> [11715.653158] stack backtrace:
>> [11715.653170] Pid: 25519, comm: s2disk Not tainted 2.6.29-rc2-1avb #11
>> [11715.653179] Call Trace:
>> [11715.653190]  [<c0306248>] ? printk+0x18/0x20
>> [11715.653202]  [<c01437df>] print_circular_bug_tail+0xcf/0xe0
>> [11715.653213]  [<c014503c>] __lock_acquire+0x140c/0x1930
>> [11715.653224]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
>> [11715.653242]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
>> [11715.653254]  [<c0140dc5>] ? lock_release_holdtime+0x35/0x210
>> [11715.653265]  [<c01455bc>] lock_acquire+0x5c/0x80
>> [11715.653277]  [<c0223017>] ? fb_mmap+0x97/0x170
>> [11715.653287]  [<c030761a>] mutex_lock_nested+0xba/0x2f0
>> [11715.653298]  [<c0223017>] ? fb_mmap+0x97/0x170
>> [11715.653309]  [<c0223017>] ? fb_mmap+0x97/0x170
>> [11715.653335]  [<c019514d>] ? kmem_cache_alloc+0xad/0x100
>> [11715.653347]  [<c0223017>] fb_mmap+0x97/0x170
>> [11715.653358]  [<c0188996>] mmap_region+0x1d6/0x530
>> [11715.653371]  [<c0186a9d>] ? arch_get_unmapped_area_topdown+0x10d/0x170
>> [11715.653383]  [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
>> [11715.653395]  [<c01063bd>] sys_mmap2+0xad/0xc0
>> [11715.653406]  [<c0103371>] sysenter_do_call+0x12/0x31
>
> Is this fixed by http://patchwork.kernel.org/patch/3259/?

Correct.

As I said in the note there're still some potential deadlocks into
some driver's specific fb_ioctl(), but at least for the common
fb_ioctl() implementation, and for this problem in particular, the
patch avoids the circular locking.

-Andrea
