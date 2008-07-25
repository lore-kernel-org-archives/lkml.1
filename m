Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYGYBWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYGYBWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbYGYBW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:22:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:26119 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYGYBW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:22:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,249,1215414000"; 
   d="scan'208";a="364539649"
Subject: Re: +
	pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch added
	to -mm tree
From: Zhang Rui <rui.zhang@intel.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, harbour@sfinx.od.ua, pavel@ucw.cz,
       rjw@sisk.pl
In-Reply-To: <20080724124349.GA182@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org>
	 <20080712162149.GD603@tv-sign.ru> <20080722161900.GA17601@in.ibm.com>
	 <20080724124349.GA182@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 09:17:29 +0800
Message-Id: <1216948649.2669.21.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 20:43 +0800, Oleg Nesterov wrote:
> On 07/22, Gautham R Shenoy wrote:
> >
> > On Sat, Jul 12, 2008 at 08:21:49PM +0400, Oleg Nesterov wrote:
> > >
> > > So, this is used in
> http://bugzilla.kernel.org/attachment.cgi?id=16707
> > >
> > >     --- linux-2.6.orig/kernel/power/poweroff.c      2008-06-30
> 16:01:35.000000000 +0800
> > >     +++ linux-2.6/kernel/power/poweroff.c   2008-07-03
> 10:50:05.000000000 +0800
> > >     @@ -25,7 +25,8 @@
> > >     
> > >      static void handle_poweroff(int key, struct tty_struct *tty)
> > >      {
> > >     -       schedule_work(&poweroff_work);
> > >     +       /* run sysrq poweroff on boot cpu */
> > >     +       schedule_work_on(first_cpu(cpu_online_map),
> &poweroff_work);
> > >      }
> > >     
> > >      static struct sysrq_key_op     sysrq_poweroff_op = {
> > >
> > > A couple of silly questions, I don't understand the low-level
> details.
> > >
> > > This patch (and kernel_power_off() afaics) assumes that the boot
> cpu
> > > can't be cpu_down()'ed. Is it true in general? For example, grep
> shows
> > > that arch/s390/kernel/smp.c:topology_init()->smp_add_present_cpu()
> > > sets ->hotpluggable = 1 for all present CPUs?
> >
> > I tried this on a Power system sometime back and I was able to
> > offline CPU0.
> 
> This means that
> 
>         pm-schedule-sysrq-poweroff-on-boot-cpu.patch
> 
> is not 100% right. It is still possible to hang/deadlock if we race
> with cpu_down(first_cpu(cpu_online_map)).

Yes, you're right.
But then should we fix disable_nonboot_cpus as well?

int disable_nonboot_cpus(void)
{
        first_cpu = first_cpu(cpu_online_map);
	...
 
        for_each_online_cpu(cpu) {
                if (cpu == first_cpu)
                        continue;
                error = _cpu_down(cpu, 1);
		...
        }
	...
}

thanks,
rui

> The bug is mostly theoretical, but perhaps should be fixed anyway,
> handle_poweroff() can use kthread_run().
> 


