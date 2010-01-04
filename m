Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608Ab0ADQTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0ADQTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576Ab0ADQTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:19:01 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60630 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0ADQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:18:58 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>
	<4B398ECD.1080506@kernel.org>
	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>
	<4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 Jan 2010 08:18:45 -0800
In-Reply-To: <4B419113.1090204@kernel.org> (Yinghai Lu's message of "Sun\, 03 Jan 2010 22\:56\:19 -0800")
Message-ID: <m1aawtlu6y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

This patch is wrong.

> between FIRST_EXTERNAL_VECTOR (0x20) and FIRST_DEVICE_VECTOR (0x41)
>
> for 0x20 and 0x2f, we are safe be used_vectors will prevent it to use used one.

We can not use any of 0x20 - 0x2f for ioapic irqs.  We need the entire
priority level to ensure that the irq move cleanup ipi is of a lower
priority.

> also try to reuse 0x30 to 0x3f after smp_affinity for irq[0,15] is changed to other cpu.

There may be a point with 0x30 to 0x3f as I recall when those irqs come through a legacy
pic we need to reserve those vectors on all cpus.


Eric


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>


> ---
>  arch/x86/kernel/apic/io_apic.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -1162,7 +1162,8 @@ __assign_irq_vector(int irq, struct irq_
>  	 * Also, we've got to be careful not to trash gate
>  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
>  	 */
> -	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
> +	static int current_vector = FIRST_EXTERNAL_VECTOR + 1;
> +	static int current_offset = 0;
>  	unsigned int old_vector;
>  	int cpu, err;
>  	cpumask_var_t tmp_mask;
> @@ -1198,7 +1199,7 @@ next:
>  		if (vector >= first_system_vector) {
>  			/* If out of vectors on large boxen, must share them. */
>  			offset = (offset + 1) % 8;
> -			vector = FIRST_DEVICE_VECTOR + offset;
> +			vector = FIRST_EXTERNAL_VECTOR + 1 + offset;
>  		}
>  		if (unlikely(current_vector == vector))
>  			continue;
