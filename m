Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYGXMke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYGXMke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYGXMkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:40:19 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46136 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbYGXMkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:40:18 -0400
Date: Thu, 24 Jul 2008 16:43:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rui.zhang@intel.com, harbour@sfinx.od.ua, pavel@ucw.cz, rjw@sisk.pl
Subject: Re: + pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch added to -mm tree
Message-ID: <20080724124349.GA182@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712162149.GD603@tv-sign.ru> <20080722161900.GA17601@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722161900.GA17601@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Gautham R Shenoy wrote:
>
> On Sat, Jul 12, 2008 at 08:21:49PM +0400, Oleg Nesterov wrote:
> >
> > So, this is used in http://bugzilla.kernel.org/attachment.cgi?id=16707
> >
> > 	--- linux-2.6.orig/kernel/power/poweroff.c	2008-06-30 16:01:35.000000000 +0800
> > 	+++ linux-2.6/kernel/power/poweroff.c	2008-07-03 10:50:05.000000000 +0800
> > 	@@ -25,7 +25,8 @@
> > 	 
> > 	 static void handle_poweroff(int key, struct tty_struct *tty)
> > 	 {
> > 	-	schedule_work(&poweroff_work);
> > 	+	/* run sysrq poweroff on boot cpu */
> > 	+	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
> > 	 }
> > 	 
> > 	 static struct sysrq_key_op	sysrq_poweroff_op = {
> >
> > A couple of silly questions, I don't understand the low-level details.
> >
> > This patch (and kernel_power_off() afaics) assumes that the boot cpu
> > can't be cpu_down()'ed. Is it true in general? For example, grep shows
> > that arch/s390/kernel/smp.c:topology_init()->smp_add_present_cpu()
> > sets ->hotpluggable = 1 for all present CPUs?
>
> I tried this on a Power system sometime back and I was able to
> offline CPU0.

This means that

	pm-schedule-sysrq-poweroff-on-boot-cpu.patch

is not 100% right. It is still possible to hang/deadlock if we race
with cpu_down(first_cpu(cpu_online_map)).

The bug is mostly theoretical, but perhaps should be fixed anyway,
handle_poweroff() can use kthread_run().

Oleg.

