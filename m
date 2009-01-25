Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZAYCj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZAYCj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 21:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZAYCjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 21:39:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbZAYCjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 21:39:19 -0500
Date: Sat, 24 Jan 2009 18:37:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-Id: <20090124183746.395f597b.akpm@linux-foundation.org>
In-Reply-To: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009 09:58:47 +0100 "Maciej Rutecki" <maciej.rutecki@gmail.com> wrote:

> During suspend to ram:
> [  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
> code: suspend_to_ram./2958
> [  131.287012] caller is retrigger_next_event+0x13/0xb0
> [  131.287012] Pid: 2958, comm: suspend_to_ram. Not tainted 2.6.29-rc2 #1
> [  131.287012] Call Trace:
> [  131.287012]  [<c025b41f>] debug_smp_processor_id+0xbf/0xd0
> [  131.287012]  [<c01473b3>] retrigger_next_event+0x13/0xb0
> [  131.287012]  [<c01489b7>] raw_notifier_call_chain+0x17/0x20
> [  131.287012]  [<c014b938>] timekeeping_resume+0xe8/0x110
> [  131.287012]  [<c02cc651>] __sysdev_resume+0x11/0x50
> [  131.287012]  [<c02cc6d7>] sysdev_resume+0x47/0x80
> [  131.287012]  [<c02d2478>] device_power_up+0x8/0x10
> [  131.287012]  [<c0159c7b>] suspend_devices_and_enter+0xeb/0x160
> [  131.287012]  [<c015a47f>] freeze_processes+0x4f/0xa0
> [  131.287012]  [<c0159e3d>] enter_state+0xfd/0x150
> [  131.287012]  [<c0159f1c>] state_store+0x8c/0xd0
> [  131.287012]  [<c0159e90>] state_store+0x0/0xd0
> [  131.287012]  [<c0250d54>] kobj_attr_store+0x24/0x30
> [  131.287012]  [<c01e25d1>] sysfs_write_file+0xa1/0x110
> [  131.287012]  [<c01e2530>] sysfs_write_file+0x0/0x110
> [  131.287012]  [<c019bf48>] vfs_write+0xa8/0x140
> [  131.287012]  [<c019c0b1>] sys_write+0x41/0x80
> [  131.287012]  [<c010348d>] sysenter_do_call+0x12/0x21
> [  131.287012]  [<c03b0000>] init_cyrix+0x72/0x444
> [  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
> code: suspend_to_ram./2958

Coming out of the hrtimer_hres_active() call, I assume.

Is this new behaviour, or were 2.6.28 and earlier doing it?

If it's new behaviour then I'm not sure why, but it triggers my Rusty
nerve.

afaict we should

a) remove the wrong "Called with interrupts disabled via
   on_each_cpu()" comment from retrigger_next_event(), and replace it
   with something useful and truthful.

b) change hres_timers_resume() to do local_irq_save/restore


Does this fix it?

--- a/kernel/hrtimer.c~a
+++ a/kernel/hrtimer.c
@@ -562,7 +562,7 @@ static int hrtimer_reprogram(struct hrti
 /*
  * Retrigger next event is called after clock was set
  *
- * Called with interrupts disabled via on_each_cpu()
+ * Called with interrupts disabled.
  */
 static void retrigger_next_event(void *arg)
 {
@@ -614,8 +614,12 @@ void clock_was_set(void)
  */
 void hres_timers_resume(void)
 {
+	unsigned long flags;
+
 	/* Retrigger the CPU local events: */
+	local_irq_save(flags);
 	retrigger_next_event(NULL);
+	local_irq_restore(flags);
 }
 
 /*
_

