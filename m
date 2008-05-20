Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbYETOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbYETOz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765148AbYETOzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:55:09 -0400
Received: from gw.goop.org ([64.81.55.164]:33391 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbYETOzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:55:07 -0400
Message-ID: <4832E62F.9030901@goop.org>
Date: Tue, 20 May 2008 15:54:39 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Getting WARN_ON in hres_timers_resume after Xen resume
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm implementing suspend/resume for Xen at the moment.  It's all going 
well, but I'm getting this WARN_ON:

------------[ cut here ]------------
WARNING: at /home/jeremy/hg/xen/paravirt/linux/kernel/hrtimer.c:635 hres_timers_resume+0x33/0x56()
Modules linked in:
Pid: 1397, comm: kstopmachine Tainted: G        W 2.6.26-rc2-sched-devel.git #94
 [<c102e87d>] warn_on_slowpath+0x41/0x5d
 [<c10477a1>] ? clockevents_program_event+0x105/0x10d
 [<c1047dd3>] ? tick_resume+0x5c/0x61
 [<c100145d>] ? xen_restore_fl+0x2e/0x52
 [<c100145d>] ? xen_restore_fl+0x2e/0x52
 [<c104b8da>] ? trace_hardirqs_off+0xb/0xd
 [<c139b67e>] ? _spin_unlock_irqrestore+0x56/0x6c
 [<c1047dd3>] ? tick_resume+0x5c/0x61
 [<c1047e2d>] ? tick_notify+0x55/0x60
 [<c139db0a>] ? notifier_call_chain+0x32/0x64
 [<c1047960>] ? clockevents_notify+0x42/0x46
 [<c100145d>] ? xen_restore_fl+0x2e/0x52
 [<c104cc50>] ? lock_release+0x71/0x77
 [<c1047960>] ? clockevents_notify+0x42/0x46
 [<c1042192>] hres_timers_resume+0x33/0x56
 [<c1045255>] timekeeping_resume+0x14e/0x157
 [<c11b6ecc>] __sysdev_resume+0x14/0x38
 [<c11b7091>] sysdev_resume+0x36/0x69
 [<c11ba59e>] device_power_up+0x8/0xf
 [<c1183476>] xen_suspend+0x9a/0xb2
 [<c105fd3d>] do_stop+0x17/0x61
 [<c105fd26>] ? do_stop+0x0/0x61
 [<c103f806>] kthread+0x37/0x59
 [<c103f7cf>] ? kthread+0x0/0x59
 [<c100782b>] kernel_thread_helper+0x7/0x10

The WARN_ON is correct, because I do have other CPUs online.  However, 
I'm in the middle of stop_machine, so they're effectively off-line as 
far as the rest of the system is concerned. (Xen suspend doesn't require 
all the CPUs to be offlined, and not doing so makes things a fair bit 
faster and cleaner.)

It seems to me that either:

   1. stop_machine is enough like offlining that we can remove stopped
      cpus from the online map, or
   2. the check in hres_timers_resume is too strong, and can be either
      weakened or removed, or
   3. hres_timers_resume needn't be called here at all, or
   4. I'm missing something, and I'm introducing a bug

BTW, once everything is out of stop_machine, I call clock_was_set() to 
make sure that timers are retriggered on all CPUs.

Thoughts?

Thanks,
    J
