Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZA3Tm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZA3Tm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZA3TmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:42:19 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:54466 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZA3TmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:42:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OoY1VktXgEFHxgc7WWX7FXkSeoWtmXNLYjLsvA1lyrg6UoR92FYkHgHkSq5d3QVW/5
         pg4ifOCzjpNSTmYW9uMjKstB+nSqaLg2FltWQTNCYgtdApP+Vtp50we2WKNNu1Fkk++6
         3o96b4N59ffvdVwCAKDbJT+hrGncdhvE0ssI0=
MIME-Version: 1.0
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A19D36AEF@orsmsx507.amr.corp.intel.com>
References: <F169D4F5E1F1974DBFAFABF47F60C10A19D36AEF@orsmsx507.amr.corp.intel.com>
Date: Fri, 30 Jan 2009 14:42:16 -0500
X-Google-Sender-Auth: 61552e68a737e9d4
Message-ID: <b6c5339f0901301142x663cf336oeb623e73c185c71c@mail.gmail.com>
Subject: Re: 2.6.29-rc1: i915 lockdep warning
From: Bob Copeland <me@bobcopeland.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "keithp@keithp.com" <keithp@keithp.com>, Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 6:17 PM, Brandeburg, Jesse
<jesse.brandeburg@intel.com> wrote:
> [drm] Initialized i915 1.6.0 20080730 on minor 0
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-rc1 #1
> -------------------------------------------------------

Same here, this happens every time I start X, still in -rc3.  I can test
any patches.  This is Fedora 10.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc3 #45
-------------------------------------------------------
Xorg/3108 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<c016a148>] might_fault+0x48/0x84

but task is already holding lock:
 (&dev->struct_mutex){--..}, at: [<f82ded8c>]
i915_gem_execbuffer+0x124/0xa48 [i915]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&dev->struct_mutex){--..}:
       [<c0140197>] __lock_acquire+0xfb9/0x12d3
       [<f82bdd47>] drm_vm_open+0x22/0x32 [drm]
       [<f82bdd47>] drm_vm_open+0x22/0x32 [drm]
       [<c01404fa>] lock_acquire+0x49/0x61
       [<f82bdd47>] drm_vm_open+0x22/0x32 [drm]
       [<c031300b>] mutex_lock_nested+0xe6/0x27d
       [<f82bdd47>] drm_vm_open+0x22/0x32 [drm]
       [<f82bdd47>] drm_vm_open+0x22/0x32 [drm]
       [<f82bdd47>] drm_vm_open+0x22/0x32 [drm]
       [<c012117c>] dup_mm+0x26d/0x31c
       [<c0121bd1>] copy_process+0x983/0xfaf
       [<c012b314>] do_sigaction+0x6a/0x13d
       [<c0122315>] do_fork+0x118/0x2a6
       [<c012b489>] sys_rt_sigaction+0x66/0x79
       [<c0102e77>] sysenter_exit+0xf/0x18
       [<c010165a>] sys_clone+0x22/0x26
       [<c0102e45>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

-> #1 (&mm->mmap_sem/1){--..}:
       [<c0140197>] __lock_acquire+0xfb9/0x12d3
       [<c0120fba>] dup_mm+0xab/0x31c
       [<c0120fba>] dup_mm+0xab/0x31c
       [<c01404fa>] lock_acquire+0x49/0x61
       [<c0120fba>] dup_mm+0xab/0x31c
       [<c0135605>] down_write_nested+0x2b/0x45
       [<c0120fba>] dup_mm+0xab/0x31c
       [<c0120fba>] dup_mm+0xab/0x31c
       [<c0121b2c>] copy_process+0x8de/0xfaf
       [<c0121bd1>] copy_process+0x983/0xfaf
       [<c0122315>] do_fork+0x118/0x2a6
       [<c01f4eaf>] copy_to_user+0x29/0xf8
       [<c0102e77>] sysenter_exit+0xf/0x18
       [<c010165a>] sys_clone+0x22/0x26
       [<c0102e45>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c013fec7>] __lock_acquire+0xce9/0x12d3
       [<c0314559>] _spin_unlock+0x25/0x3a
       [<c01404fa>] lock_acquire+0x49/0x61
       [<c016a148>] might_fault+0x48/0x84
       [<c016a165>] might_fault+0x65/0x84
       [<c016a148>] might_fault+0x48/0x84
       [<c01f4eaf>] copy_to_user+0x29/0xf8
       [<f82df5ec>] i915_gem_execbuffer+0x984/0xa48 [i915]
       [<c016a148>] might_fault+0x48/0x84
       [<f82b951a>] drm_ioctl+0x1a9/0x221 [drm]
       [<f82dec68>] i915_gem_execbuffer+0x0/0xa48 [i915]
       [<c0186102>] vfs_ioctl+0x49/0x5f
       [<c0186656>] do_vfs_ioctl+0x46c/0x4a7
       [<c03144c8>] _spin_unlock_irq+0x2b/0x40
       [<c0125cd9>] do_setitimer+0x15d/0x2af
       [<c0125e70>] sys_setitimer+0x45/0x6f
       [<c01866bd>] sys_ioctl+0x2c/0x42
       [<c0102e45>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by Xorg/3108:
 #0:  (&dev->struct_mutex){--..}, at: [<f82ded8c>]
i915_gem_execbuffer+0x124/0xa48 [i915]

stack backtrace:
Pid: 3108, comm: Xorg Not tainted 2.6.29-rc3 #45
Call Trace:
 [<c013eeb5>] print_circular_bug_tail+0xa4/0xae
 [<c013fec7>] __lock_acquire+0xce9/0x12d3
 [<c0314559>] _spin_unlock+0x25/0x3a
 [<c01404fa>] lock_acquire+0x49/0x61
 [<c016a148>] might_fault+0x48/0x84
 [<c016a165>] might_fault+0x65/0x84
 [<c016a148>] might_fault+0x48/0x84
 [<c01f4eaf>] copy_to_user+0x29/0xf8
 [<f82df5ec>] i915_gem_execbuffer+0x984/0xa48 [i915]
 [<c016a148>] might_fault+0x48/0x84
 [<f82b951a>] drm_ioctl+0x1a9/0x221 [drm]
 [<f82dec68>] i915_gem_execbuffer+0x0/0xa48 [i915]
 [<c0186102>] vfs_ioctl+0x49/0x5f
 [<c0186656>] do_vfs_ioctl+0x46c/0x4a7
 [<c03144c8>] _spin_unlock_irq+0x2b/0x40
 [<c0125cd9>] do_setitimer+0x15d/0x2af
 [<c0125e70>] sys_setitimer+0x45/0x6f
 [<c01866bd>] sys_ioctl+0x2c/0x42
 [<c0102e45>] sysenter_do_call+0x12/0x35

-- 
Bob Copeland %% www.bobcopeland.com
