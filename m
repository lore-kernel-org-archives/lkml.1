Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZFDXNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZFDXNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFDXNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:13:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35052 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZFDXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:13:23 -0400
To: suresh.b.siddha@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, andi@linux.intel.com, travis@sgi.com,
       steiner@sgi.com, Gary Hade <garyhade@us.ibm.com>
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
References: <1244141989.27006.10369.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 04 Jun 2009 16:13:16 -0700
In-Reply-To: <1244141989.27006.10369.camel@localhost.localdomain> (Suresh Siddha's message of "Thu\, 04 Jun 2009 11\:59\:49 -0700")
Message-ID: <m1iqjbd243.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: suresh.b.siddha@intel.com, garyhade@us.ibm.com, steiner@sgi.com, travis@sgi.com, andi@linux.intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
>
> In the presence of interrupt-remapping, irqs will be migrated in the
> process context and we don't do (and there is no need to) irq_chip mask/unmask
> while migrating the interrupt.
>
> Similarly fix the fixup_irqs() that get called during cpu offline and avoid
> calling irq_chip mask/unmask for irqs that are ok to be migrated in the
> process context.
>
> While we didn't observe any race condition with the existing code,
> this change takes complete advantage of interrupt-remapping in
> the newer generation platforms and avoids any potential HW lockup's
> (that often worry Eric :)

You now apparently fail to migrate the irq threads in tandem with
the rest of the irqs.

Eric

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>
> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
> index 977d8b4..82265a5 100644
> --- a/arch/x86/kernel/irq_64.c
> +++ b/arch/x86/kernel/irq_64.c
> @@ -95,7 +95,7 @@ void fixup_irqs(void)
>  			affinity = cpu_all_mask;
>  		}
>  
> -		if (desc->chip->mask)
> +		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
>  			desc->chip->mask(irq);
>  
>  		if (desc->chip->set_affinity)
> @@ -103,7 +103,7 @@ void fixup_irqs(void)
>  		else if (!(warned++))
>  			set_affinity = 0;
>  
> -		if (desc->chip->unmask)
> +		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
>  			desc->chip->unmask(irq);
>  
>  		spin_unlock(&desc->lock);
