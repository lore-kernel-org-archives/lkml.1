Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZA1VJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZA1VJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZA1VJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:09:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:36744 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZA1VJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tT7tNVNJJbvyhjyvnuO8qSXVtICgIzr3Je19EmOIVNmJm8mYpuMpuoCtMLcmyRqXq/
         KHq3vmY6d9h1qw7Dc9uX5hj0+1W1CLVJlw8Ghu9U7Sjmgn04UTEzr7p4RWdmFvGyxG41
         w5ARUOFjcb/Bvlh8R8UtcoH+Qt2TlNcyIYCU4=
MIME-Version: 1.0
Date: Wed, 28 Jan 2009 22:09:44 +0100
Message-ID: <c4e36d110901281309j62b51020h79910491f120d3f3@mail.gmail.com>
Subject: INFO: possible circular locking dependency detected - 
	i915_gem_execbuffer
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: eric@anholt.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've got this INFO trace while running  glxgears.


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc2 #24
-------------------------------------------------------
glxgears/4212 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffff802c7312>] might_fault+0x62/0xc0

but task is already holding lock:
 (&dev->struct_mutex){--..}, at: [<ffffffffa030062e>]
i915_gem_execbuffer+0xfe/0xde0 [i915]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&dev->struct_mutex){--..}:
       [<ffffffff802742f2>] __lock_acquire+0x1412/0x1dd0
       [<ffffffff80274d41>] lock_acquire+0x91/0xc0
       [<ffffffff805538bc>] mutex_lock_nested+0xec/0x360
       [<ffffffffa02d2810>] drm_vm_open+0x40/0x60 [drm]
       [<ffffffff80245161>] dup_mm+0x291/0x3b0
       [<ffffffff80246391>] copy_process+0x10c1/0x13f0
       [<ffffffff80246750>] do_fork+0x90/0x440
       [<ffffffff8020a7b8>] sys_clone+0x28/0x30
       [<ffffffff8020caf3>] stub_clone+0x13/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&mm->mmap_sem/1){--..}:
       [<ffffffff802742f2>] __lock_acquire+0x1412/0x1dd0
       [<ffffffff80274d41>] lock_acquire+0x91/0xc0
       [<ffffffff802641b7>] down_write_nested+0x57/0xa0
       [<ffffffff80244fb7>] dup_mm+0xe7/0x3b0
       [<ffffffff80246391>] copy_process+0x10c1/0x13f0
       [<ffffffff80246750>] do_fork+0x90/0x440
       [<ffffffff8020a7b8>] sys_clone+0x28/0x30
       [<ffffffff8020caf3>] stub_clone+0x13/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff802744ba>] __lock_acquire+0x15da/0x1dd0
       [<ffffffff80274d41>] lock_acquire+0x91/0xc0
       [<ffffffff802c733f>] might_fault+0x8f/0xc0
       [<ffffffffa02f9dbf>] i915_emit_box+0x3f/0x300 [i915]
       [<ffffffffa03010d3>] i915_gem_execbuffer+0xba3/0xde0 [i915]
       [<ffffffffa02cbc22>] drm_ioctl+0x122/0x350 [drm]
       [<ffffffff802f3355>] vfs_ioctl+0x85/0xb0
       [<ffffffff802f3412>] do_vfs_ioctl+0x92/0x5b0
       [<ffffffff802f39d1>] sys_ioctl+0xa1/0xb0
       [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by glxgears/4212:
 #0:  (&dev->struct_mutex){--..}, at: [<ffffffffa030062e>]
i915_gem_execbuffer+0xfe/0xde0 [i915]

stack backtrace:
Pid: 4212, comm: glxgears Not tainted 2.6.29-rc2 #24
Call Trace:
 [<ffffffff80272a50>] print_circular_bug_tail+0xe0/0xf0
 [<ffffffff802744ba>] __lock_acquire+0x15da/0x1dd0
 [<ffffffff802734cd>] ? __lock_acquire+0x5ed/0x1dd0
 [<ffffffff8043fac7>] ? agp_bind_memory+0xb7/0x100
 [<ffffffff80274d41>] lock_acquire+0x91/0xc0
 [<ffffffff802c7312>] ? might_fault+0x62/0xc0
 [<ffffffff802c733f>] might_fault+0x8f/0xc0
 [<ffffffff802c7312>] ? might_fault+0x62/0xc0
 [<ffffffff8025c5b1>] ? queue_delayed_work+0x21/0x40
 [<ffffffffa02f9dbf>] i915_emit_box+0x3f/0x300 [i915]
 [<ffffffffa03010d3>] i915_gem_execbuffer+0xba3/0xde0 [i915]
 [<ffffffff80553192>] ? __mutex_unlock_slowpath+0xf2/0x190
 [<ffffffffa02cbc22>] drm_ioctl+0x122/0x350 [drm]
 [<ffffffff80265fd0>] ? cpu_clock+0x50/0x60
 [<ffffffffa0300530>] ? i915_gem_execbuffer+0x0/0xde0 [i915]
 [<ffffffff802f3355>] vfs_ioctl+0x85/0xb0
 [<ffffffff802f3412>] do_vfs_ioctl+0x92/0x5b0
 [<ffffffff8020c73c>] ? sysret_check+0x27/0x62
 [<ffffffff8020c73c>] ? sysret_check+0x27/0x62
 [<ffffffff802f39d1>] sys_ioctl+0xa1/0xb0
 [<ffffffff802706bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b


BTW - now I'm getting finally again number I used to see 1.5 year ago
on the same hardware - which is 1100FPS - though I had to turn on
performance governor or change threshold for ondemand governor - I'm
not sure why the standard threshold doesn't handle this well (i.e. it
give only 700FPS)

Also it's interesting that lock_stat give this huge  contention entry
fro gem driver - maybe it could be handled better ?


lock_stat version 0.3
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions
  waittime-min   waittime-max waittime-total    acq-bounces
acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                      &dev->struct_mutex:           113        4256313
         27.38    24269683.29 13424452821900          30701
10006488           1.07       53443.29    48405221.21
                      ------------------
                      &dev->struct_mutex             78
[<ffffffffa02fe8cf>] i915_gem_retire_work_handler+0x3f/0x90 [i915]
                      &dev->struct_mutex             34
[<ffffffffa02ff9af>] i915_gem_set_domain_ioctl+0x9f/0x110 [i915]
                      &dev->struct_mutex             17
[<ffffffffa02ff697>] i915_gem_busy_ioctl+0x37/0xd0 [i915]
                      &dev->struct_mutex             19
[<ffffffffa02ff8a6>] i915_gem_sw_finish_ioctl+0x66/0xd0 [i915]
                      ------------------
                      &dev->struct_mutex             10
[<ffffffffa02ff697>] i915_gem_busy_ioctl+0x37/0xd0 [i915]
                      &dev->struct_mutex             63
[<ffffffffa02fe8cf>] i915_gem_retire_work_handler+0x3f/0x90 [i915]
                      &dev->struct_mutex             13
[<ffffffffa02fef71>] i915_gem_throttle_ioctl+0x31/0x70 [i915]
                      &dev->struct_mutex              5
[<ffffffffa02ff8a6>] i915_gem_sw_finish_ioctl+0x66/0xd0 [i915]


Zdenek
