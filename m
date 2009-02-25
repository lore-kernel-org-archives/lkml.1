Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbZBYWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbZBYWyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbZBYWyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:54:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbZBYWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:54:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wang Chen <wangchen@cn.fujitsu.com>
Subject: Re: [Bug #12419] possible circular locking dependency on i915 dma
Date: Wed, 25 Feb 2009 23:54:07 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.CDG.IrzoJB@chimera> <49A353BD.40000@cn.fujitsu.com>
In-Reply-To: <49A353BD.40000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902252354.08034.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Wang Chen wrote:
> Rafael J. Wysocki said the following on 2009-2-24 5:48:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12419
> > Subject		: possible circular locking dependency on i915 dma
> > Submitter	: Wang Chen <wangchen@cn.fujitsu.com>
> > Date		: 2009-01-08 14:11 (47 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=546b0974c39657017407c86fe79811100b60700d
> > References	: http://marc.info/?l=linux-kernel&m=123142399720125&w=4
> > 
> 
> not changed.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-rc6-default #165
> -------------------------------------------------------
> X/3940 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<c0168e97>] might_fault+0x42/0x7e
> 
> but task is already holding lock:
>  (&dev->struct_mutex){--..}, at: [<eeb76fed>] i915_cmdbuffer+0xf4/0x411 [i915]
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&dev->struct_mutex){--..}:
>        [<c013791a>] validate_chain+0x8be/0xbb5
>        [<c0138280>] __lock_acquire+0x66f/0x6f9
>        [<c0138365>] lock_acquire+0x5b/0x77
>        [<c02e56fe>] mutex_lock_nested+0xdb/0x244
>        [<eeb5b03e>] drm_vm_open+0x25/0x37 [drm]
>        [<c011a8b3>] dup_mm+0x247/0x2f2
>        [<c011b312>] copy_process+0x98c/0xfeb
>        [<c011bac7>] do_fork+0x120/0x29c
>        [<c01016be>] sys_clone+0x25/0x2a
>        [<c0102cdd>] sysenter_do_call+0x12/0x31
>        [<ffffffff>] 0xffffffff
> 
> -> #1 (&mm->mmap_sem/1){--..}:
>        [<c013791a>] validate_chain+0x8be/0xbb5
>        [<c0138280>] __lock_acquire+0x66f/0x6f9
>        [<c0138365>] lock_acquire+0x5b/0x77
>        [<c012e6f6>] down_write_nested+0x32/0x4f
>        [<c011a711>] dup_mm+0xa5/0x2f2
>        [<c011b312>] copy_process+0x98c/0xfeb
>        [<c011bac7>] do_fork+0x120/0x29c
>        [<c01016be>] sys_clone+0x25/0x2a
>        [<c0102cdd>] sysenter_do_call+0x12/0x31
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&mm->mmap_sem){----}:
>        [<c0137625>] validate_chain+0x5c9/0xbb5
>        [<c0138280>] __lock_acquire+0x66f/0x6f9
>        [<c0138365>] lock_acquire+0x5b/0x77
>        [<c0168eb4>] might_fault+0x5f/0x7e
>        [<eeb76d0a>] i915_emit_box+0x1d/0x20c [i915]
>        [<eeb7705e>] i915_cmdbuffer+0x165/0x411 [i915]
>        [<eeb5685b>] drm_ioctl+0x1a6/0x21b [drm]
>        [<c0182b29>] vfs_ioctl+0x3d/0x50
>        [<c0183029>] do_vfs_ioctl+0x41b/0x483
>        [<c01830d1>] sys_ioctl+0x40/0x5a
>        [<c0102cdd>] sysenter_do_call+0x12/0x31
>        [<ffffffff>] 0xffffffff

Thanks for the update.

Rafael
