Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZCXHVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZCXHVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZCXHVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:21:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:40355 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZCXHVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vF9Y9jsQc2HKE7nK6Hz1mJ5t3SkGmeDFbF8wG2ma/KPodqfKdqO/Xl1yVqnpr4r8ZI
         r/Z1eSsuSqiJXPBsD/WbLJgObPI+D/voxNe1F7xElcmxEtT6NQAqT3vUdHkT5ldWd+EH
         qoC/w5Wpe6POzccB+MKMKIfW3I+Rr2qKCmWzw=
MIME-Version: 1.0
In-Reply-To: <200903241619.03517.rusty@rustcorp.com.au>
References: <200903241619.03517.rusty@rustcorp.com.au>
Date: Tue, 24 Mar 2009 00:21:43 -0700
X-Google-Sender-Auth: cdecbab01a21edf9
Message-ID: <86802c440903240021y20abab87j3a780f8a17574716@mail.gmail.com>
Subject: Re: [RFC] Correct behaviour of irq affinity?
From: Yinghai Lu <yinghai@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 10:49 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> The effect of setting desc->affinity (ie. from userspace via sysfs) has varied
> over time.  In 2.6.27, the 32-bit code anded the value with cpu_online_map,
> and both 32 and 64-bit did that anding whenever a cpu was unplugged.
>
> 2.6.29 consolidated this into one routine (and fixed hotplug) but introduced
> another variation: anding the affinity with cfg->domain.  Is this right, or
> should we just set it to what the user said?  Or as now, indicate that we're
> restricting it.
>
> If we should change it, here's what the patch looks like against x86 tip
> (cpu_mask_to_apicid_and already takes cpu_online_mask into account):
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 86827d8..30906cd 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -592,10 +592,10 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
>        if (assign_irq_vector(irq, cfg, mask))
>                return BAD_APICID;
>
> -       cpumask_and(desc->affinity, cfg->domain, mask);
> +       cpumask_copy(desc->affinity, mask);
>        set_extra_move_desc(desc, mask);
>
> -       return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
> +       return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
>  }
>
>  static void
>
cfg->domain for logical flat: will be ALL_CPUS
for phys flat (aka bigsmp on 32bit) will be one cpu set mask.

so desc->affinity: for logical will be not changed, but
set_desc_affinity() return will be changed. ( not add with
cpu_online_mask anymore)
when mask is 0x0f
for phys flat, desc->affinity will be changed to 0x0f from
0x01/0x02/0x04/08, return set_desc_affinity is not changed.
so /proc/irq/xx/smp_affinity will be changed. and it does reflect that
actually affinity.

so this patch looks not right.

YH
