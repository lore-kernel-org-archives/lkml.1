Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYGYJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYGYJjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYGYJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:39:12 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35211 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbYGYJjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:39:12 -0400
Date: Fri, 25 Jul 2008 13:42:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, harbour@sfinx.od.ua, pavel@ucw.cz,
       rjw@sisk.pl
Subject: Re: + pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch added to -mm tree
Message-ID: <20080725094246.GA110@tv-sign.ru>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712162149.GD603@tv-sign.ru> <20080722161900.GA17601@in.ibm.com> <20080724124349.GA182@tv-sign.ru> <1216948649.2669.21.camel@rzhang-dt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216948649.2669.21.camel@rzhang-dt>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Zhang Rui wrote:
>
> On Thu, 2008-07-24 at 20:43 +0800, Oleg Nesterov wrote:
> >
> > This means that
> >
> >         pm-schedule-sysrq-poweroff-on-boot-cpu.patch
> >
> > is not 100% right. It is still possible to hang/deadlock if we race
> > with cpu_down(first_cpu(cpu_online_map)).
>
> Yes, you're right.
> But then should we fix disable_nonboot_cpus as well?
>
> int disable_nonboot_cpus(void)
> {
>         first_cpu = first_cpu(cpu_online_map);
> 	...
>
>         for_each_online_cpu(cpu) {
>                 if (cpu == first_cpu)
>                         continue;
>                 error = _cpu_down(cpu, 1);
> 		...
>         }
> 	...
> }

Note that disable_nonboot_cpus() does first_cpu = first_cpu() under
cpu_maps_update_begin(), so we can't race with cpu-hotplug.

However, this afaics means that its name is wrong, and
printk("Disabling non-boot CPUs ...\n") is not right too.
What it does is disable_all_but_one_cpus().

And, it is not clear why disable_nonboot_cpus() assumes that
all but first_cpu(cpu_online_map) must have .hotpluggable == 1.

And, if one of the callers really need to preserve the boot CPU,
I don't understand how it is guaranteed it must be first_cpu().

Oleg.

