Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYF1FGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYF1FGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYF1FGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:06:33 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:49053 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750806AbYF1FGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:06:32 -0400
Date: Sat, 28 Jun 2008 14:03:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 29/60] microblaze_v4: traps support
Message-ID: <20080628050345.GH25492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, monstr@seznam.cz,
	linux-kernel@vger.kernel.org, arnd@arndb.de,
	linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
	John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
	will.newton@gmail.com, drepper@redhat.com,
	microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
	linuxppc-dev@ozlabs.org, vapier.adi@gmail.com,
	alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
	Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-21-git-send-email-monstr@seznam.cz> <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz> <1214483429-32360-26-git-send-email-monstr@seznam.cz> <1214483429-32360-27-git-send-email-monstr@seznam.cz> <1214483429-32360-28-git-send-email-monstr@seznam.cz> <1214483429-32360-29-git-send-email-monstr@seznam.cz> <1214483429-32360-30-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214483429-32360-30-git-send-email-monstr@seznam.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:29:58PM +0200, monstr@seznam.cz wrote:
> +static int kstack_depth_to_print = 24;
> +
x86 has a sysctl for this. It may be worth making this non-static and
generalizing the ifdef case. Plenty of other architectures could benefit
from this also.

> +void show_trace(struct task_struct *task, unsigned long *stack)
> +{
> +	unsigned long addr;
> +
> +	if (!stack)
> +		stack = (unsigned long *)&stack;
> +
> +	printk(KERN_INFO "Call Trace: ");
> +#ifdef CONFIG_KALLSYMS
> +	printk(KERN_INFO "\n");
> +#endif
> +	while (!kstack_end(stack)) {
> +		addr = *stack++;
> +		if (__kernel_text_address(addr)) {
> +			printk(KERN_INFO "[<%08lx>] ", addr);
> +			print_symbol("%s\n", addr);

Use print_ip_sym() here for future-proofing.

> +		}
> +	}
> +	printk(KERN_INFO "\n");

And here you can:

	if (!tsk)
		tsk = current;
	
	debug_show_held_locks(tsk);
> +}
> +

for when you get around to implementing lockdep.
