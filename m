Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYGVQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYGVQTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYGVQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:19:43 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:58330 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752022AbYGVQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:19:42 -0400
Date: Tue, 22 Jul 2008 12:19:00 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rui.zhang@intel.com, harbour@sfinx.od.ua, pavel@ucw.cz, rjw@sisk.pl
Subject: Re: +
	pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
	added to -mm tree
Message-ID: <20080722161900.GA17601@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712162149.GD603@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712162149.GD603@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 08:21:49PM +0400, Oleg Nesterov wrote:
> (Gautham cc'ed)
> 

Sorry for the delay... I'm a bit tied down to other things until aug
20th :(

> On 07/11, Andrew Morton wrote:
> >
> > Subject: pm: introduce new interfaces schedule_work_on() and queue_work_on()
> > From: Zhang Rui <rui.zhang@intel.com>
> >
> > This interface allows adding a job on a specific cpu.
> >
> > Although a work struct on a cpu will be scheduled to other cpu if the cpu
> > dies, there is a recursion if a work task tries to offline the cpu it's
> > running on.  we need to schedule the task to a specific cpu in this case.
> > http://bugzilla.kernel.org/show_bug.cgi?id=10897
> 
> So, this is used in http://bugzilla.kernel.org/attachment.cgi?id=16707
> 
> 	--- linux-2.6.orig/kernel/power/poweroff.c	2008-06-30 16:01:35.000000000 +0800
> 	+++ linux-2.6/kernel/power/poweroff.c	2008-07-03 10:50:05.000000000 +0800
> 	@@ -25,7 +25,8 @@
> 	 
> 	 static void handle_poweroff(int key, struct tty_struct *tty)
> 	 {
> 	-	schedule_work(&poweroff_work);
> 	+	/* run sysrq poweroff on boot cpu */
> 	+	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
> 	 }
> 	 
> 	 static struct sysrq_key_op	sysrq_poweroff_op = {
> 
> A couple of silly questions, I don't understand the low-level details.
> 
> This patch (and kernel_power_off() afaics) assumes that the boot cpu
> can't be cpu_down()'ed. Is it true in general? For example, grep shows
> that arch/s390/kernel/smp.c:topology_init()->smp_add_present_cpu()
> sets ->hotpluggable = 1 for all present CPUs?

I tried this on a Power system sometime back and I was able to
offline CPU0. What I am not sure however, is
if that was the boot-cpu.

On x86, I do remember reading somewhere why we cannot offline
CPU0.

/me searches.

Yes, in arch/x86/kernel/topology.c

int __ref arch_register_cpu(int num)
{
	/*
	 * CPU0 cannot be offlined due to several
	 * restrictions and assumptions in kernel. This basically
	 * doesnt add a control file, one cannot attempt to offline
	 * BSP.
	 *
	 * Also certain PCI quirks require not to enable hotplug control
	 * for all CPU's.
	 */
	if (num)
		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
}

> 
> Another question. I can't understand why first_cpu(cpu_online_map) is
> always the boot CPU on every arch. IOW, shouldn't boot_cpu_init() set
> some "boot_cpu = smp_processor_id()" which should be use instead of
> first_cpu(cpu_online_map) ?
>

Not very sure about this one.
> Thanks,
> 
> Oleg.
> 

-- 
Thanks and Regards
gautham
