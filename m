Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYF1Exp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYF1Exp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYF1Exf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:53:35 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:47991 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751716AbYF1Exe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:53:34 -0400
Date: Sat, 28 Jun 2008 13:50:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 25/60] microblaze_v4: process and init task function
Message-ID: <20080628045042.GF25492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, monstr@seznam.cz,
	linux-kernel@vger.kernel.org, arnd@arndb.de,
	linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
	John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
	will.newton@gmail.com, drepper@redhat.com,
	microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
	linuxppc-dev@ozlabs.org, vapier.adi@gmail.com,
	alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
	Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-17-git-send-email-monstr@seznam.cz> <1214483429-32360-18-git-send-email-monstr@seznam.cz> <1214483429-32360-19-git-send-email-monstr@seznam.cz> <1214483429-32360-20-git-send-email-monstr@seznam.cz> <1214483429-32360-21-git-send-email-monstr@seznam.cz> <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz> <1214483429-32360-26-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214483429-32360-26-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:54PM +0200, monstr@seznam.cz wrote:
> +void (*pm_power_off)(void) = NULL;
> +EXPORT_SYMBOL(pm_power_off);
> +
> +void cpu_idle(void)
> +{
> +	set_thread_flag(TIF_POLLING_NRFLAG);
> +
> +	while (1) {
> +		while (!need_resched())
> +			cpu_relax();
> +
> +		preempt_enable_no_resched();
> +		schedule();
> +		preempt_disable();
> +	}
> +}
> +
A couple things to note here. You have a pm_power_off, but no pm_idle.

You set TIF_POLLING_NRFLAG but don't have any explicit clearing and
resetting of it if the CPU is sleeping. In the cpu_relax() case this is
ok, but if you have a cpu_sleep() you will want to use in the SMP case,
you will need to handle it explicitly.

Beyond that, you may also want to stub in the
tick_nohz_stop_sched_tick()/tick_nohz_restart_sched_tick() calls, then
when you implement the generic clockevents you will already have the
tickless bits in place.

check_pgt_cache() is also helpful here for quicklist trimming, though you
may not care if you never plan to have an MMU.

You can look at arch/sh/kernel/process_32.c for examples.
