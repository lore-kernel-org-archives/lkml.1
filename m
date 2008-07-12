Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYGLQSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYGLQSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGLQSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:18:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51979 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbYGLQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:18:35 -0400
Date: Sat, 12 Jul 2008 20:21:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rui.zhang@intel.com, harbour@sfinx.od.ua,
       pavel@ucw.cz, rjw@sisk.pl, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: + pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch added to -mm tree
Message-ID: <20080712162149.GD603@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Gautham cc'ed)

On 07/11, Andrew Morton wrote:
>
> Subject: pm: introduce new interfaces schedule_work_on() and queue_work_on()
> From: Zhang Rui <rui.zhang@intel.com>
>
> This interface allows adding a job on a specific cpu.
>
> Although a work struct on a cpu will be scheduled to other cpu if the cpu
> dies, there is a recursion if a work task tries to offline the cpu it's
> running on.  we need to schedule the task to a specific cpu in this case.
> http://bugzilla.kernel.org/show_bug.cgi?id=10897

So, this is used in http://bugzilla.kernel.org/attachment.cgi?id=16707

	--- linux-2.6.orig/kernel/power/poweroff.c	2008-06-30 16:01:35.000000000 +0800
	+++ linux-2.6/kernel/power/poweroff.c	2008-07-03 10:50:05.000000000 +0800
	@@ -25,7 +25,8 @@
	 
	 static void handle_poweroff(int key, struct tty_struct *tty)
	 {
	-	schedule_work(&poweroff_work);
	+	/* run sysrq poweroff on boot cpu */
	+	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
	 }
	 
	 static struct sysrq_key_op	sysrq_poweroff_op = {

A couple of silly questions, I don't understand the low-level details.

This patch (and kernel_power_off() afaics) assumes that the boot cpu
can't be cpu_down()'ed. Is it true in general? For example, grep shows
that arch/s390/kernel/smp.c:topology_init()->smp_add_present_cpu()
sets ->hotpluggable = 1 for all present CPUs?

Another question. I can't understand why first_cpu(cpu_online_map) is
always the boot CPU on every arch. IOW, shouldn't boot_cpu_init() set
some "boot_cpu = smp_processor_id()" which should be use instead of
first_cpu(cpu_online_map) ?

Thanks,

Oleg.

