Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZCXMkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZCXMkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbZCXMjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:39:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36406 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbZCXMju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:39:50 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200903241619.03517.rusty@rustcorp.com.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Mar 2009 05:39:37 -0700
In-Reply-To: <200903241619.03517.rusty@rustcorp.com.au> (Rusty Russell's message of "Tue\, 24 Mar 2009 16\:19\:03 +1030")
Message-ID: <m1k56frt6e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: rusty@rustcorp.com.au, mingo@elte.hu, yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rusty Russell <rusty@rustcorp.com.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  1.0 XMSolicitRefs_1 XMSolicitRefs_1
Subject: Re: [RFC] Correct behaviour of irq affinity?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> The effect of setting desc->affinity (ie. from userspace via sysfs) has varied
> over time.  In 2.6.27, the 32-bit code anded the value with cpu_online_map,
> and both 32 and 64-bit did that anding whenever a cpu was unplugged.
>
> 2.6.29 consolidated this into one routine (and fixed hotplug) but introduced
> another variation: anding the affinity with cfg->domain.  Is this right, or
> should we just set it to what the user said?  Or as now, indicate that we're
> restricting it.
>
> If we should change it, here's what the patch looks like against x86 tip
> (cpu_mask_to_apicid_and already takes cpu_online_mask into account):

desc->affinity should be what the user requested, if it is at all
possible to honor the user space request.  YH the fact that we do not
currently exercise the full freedom that user space gives us is
irrelevant.

Further setting desc->affinity to the user space request is what
x86_64 did before the grand merger. 

Likewise desc->affinity & cfg->domain & cpu_online_map going into the
selection of apic id, is what the code did before the grand merger,
and what the code is currently doing.  So logically that looks good.

YH has a point that several of the implementations of
cpu_mask_to_apic_id do not take cpu_online_map into account and should
probably be fixed.  flat_cpu_mask_to_apicid was the one I could find.

Also now that I look at it there is one other bug in this routine
that you have missed.  set_extra_move_desc should be called before
we set desc->affinity, as it compares that with the new value to
see if we are going to be running on a new cpu, and if so we may
need to reallocate irq_desc onto a new numa node.  set_extra_move_desc
looks a little fishy but it doesn't stand a chance if it is called
with the wrong data.

Overall I like it.

Do you think you could fix those two issues and regenerate the patch?

> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 86827d8..30906cd 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -592,10 +592,10 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
>  	if (assign_irq_vector(irq, cfg, mask))
>  		return BAD_APICID;
>  
> -	cpumask_and(desc->affinity, cfg->domain, mask);
> +	cpumask_copy(desc->affinity, mask);
>  	set_extra_move_desc(desc, mask);
>  
> -	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
> +	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
>  }
>  
>  static void

Eric
