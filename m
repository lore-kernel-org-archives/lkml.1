Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZFCLzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZFCLzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZFCLza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:55:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54426 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZFCLz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:55:29 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining triggered "inactive" device IRQ interrruption
References: <20090602193202.GB7282@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 04:55:26 -0700
In-Reply-To: <20090602193202.GB7282@us.ibm.com> (Gary Hade's message of "Tue\, 2 Jun 2009 12\:32\:02 -0700")
Message-ID: <m1hbyxv8ep.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> Impact: Eliminates a race that can leave the system in an
>         unusable state
>
> During rapid offlining of multiple CPUs there is a chance
> that an IRQ affinity move destination CPU will be offlined
> before the IRQ affinity move initiated during the offlining
> of a previous CPU completes.  This can happen when the device
> is not very active and thus fails to generate the IRQ that is
> needed to complete the IRQ affinity move before the move
> destination CPU is offlined.  When this happens there is an
> -EBUSY return from __assign_irq_vector() during the offlining
> of the IRQ move destination CPU which prevents initiation of
> a new IRQ affinity move operation to an online CPU.  This
> leaves the IRQ affinity set to an offlined CPU.
>
> I have been able to reproduce the problem on some of our
> systems using the following script.  When the system is idle
> the problem often reproduces during the first CPU offlining
> sequence.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

fixup_irqs() is broken for allowing such a thing.

> #!/bin/sh
>
> SYS_CPU_DIR=/sys/devices/system/cpu
> VICTIM_IRQ=25
> IRQ_MASK=f0
>
> iteration=0
> while true; do
>   echo $iteration
>   echo $IRQ_MASK > /proc/irq/$VICTIM_IRQ/smp_affinity
>   for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
>     echo 0 > $cpudir/online
>   done
>   for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
>     echo 1 > $cpudir/online
>   done
>   iteration=`expr $iteration + 1`
> done
>
> The proposed fix takes advantage of the fact that when all
> CPUs in the old domain are offline there is nothing to be done
> by send_cleanup_vector() during the affinity move completion.
> So, we simply avoid setting cfg->move_in_progress preventing
> the above mentioned -EBUSY return from __assign_irq_vector().
> This allows initiation of a new IRQ affinity move to a CPU
> that is not going offline.
>
> Successfully tested with Ingo's linux-2.6-tip (32 and 64-bit
> builds) on the IBM x460, x3550 M2, x3850, and x3950 M2.
>
> v2: modified to integrate with Yinghai Lu's
>     "x86/irq: remove leftover code from NUMA_MIGRATE_IRQ_DESC"
>     patch which modified intersecting lines.  Only comment 
>     changes were affected.  The actual change to the code 
>     is the same.  
>
> Signed-off-by: Gary Hade <garyhade@us.ibm.com>
>
> ---
>  arch/x86/kernel/apic/io_apic.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c	2009-05-14 14:06:30.000000000 -0700
> +++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c	2009-05-14 14:09:42.000000000 -0700
> @@ -1218,8 +1218,11 @@ next:
>  		current_vector = vector;
>  		current_offset = offset;
>  		if (old_vector) {
> -			cfg->move_in_progress = 1;
>  			cpumask_copy(cfg->old_domain, cfg->domain);
> +			if (cpumask_intersects(cfg->old_domain,
> +					       cpu_online_mask)) {
> +				cfg->move_in_progress = 1;
> +			}
>  		}
>  		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
>  			per_cpu(vector_irq, new_cpu)[vector] = irq;
