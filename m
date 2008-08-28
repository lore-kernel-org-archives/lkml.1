Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYH1M0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYH1M0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYH1M0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:26:06 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39600 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYH1M0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:26:04 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC 3/3] x86: use mwait for trigger API
Date: Thu, 28 Aug 2008 14:25:57 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>
References: <48A70192.7020002@goop.org>
In-Reply-To: <48A70192.7020002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281425.57336.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 16. August 2008 schrieb Jeremy Fitzhardinge:

Seems that this cant work. We never reset the t->cpus bits. That means we 
never mwait after a kick.

See:

> +void mwait_trigger_reset(trigger_t *t)
> +{
> +	unsigned long flags;
> +
> +	t->trigger = 0;
> +
> +	local_save_flags(flags);
> +	__get_cpu_var(mwait_saved_flags) = flags;
> +
> +	__monitor(&t->trigger, 0, 0);
> +}
> +
> +void mwait_trigger_wait(trigger_t *t)
> +{
> +	unsigned long flags = __get_cpu_var(mwait_saved_flags);
> +	int cpu = smp_processor_id();
> +
> +	if (irqs_disabled_flags(flags)) {
> +		while(!cpu_isset(cpu, t->cpus)) {

We check the bits here

> +			__mwait(0, 0);
> +			barrier();
> +			__monitor(&t->trigger, 0, 0);
> +		}
> +	} else {
> +		while(!cpu_isset(cpu, t->cpus)) {

and here

> +			__sti_mwait(0, 0);
> +			barrier();
> +			local_irq_disable();
> +			__monitor(&t->trigger, 0, 0);
> +		}
> +	}
> +}
> +
> +void mwait_trigger_finish(trigger_t *t)
> +{
> +	local_irq_restore(__get_cpu_var(mwait_saved_flags));
> +}
> +
> +void mwait_trigger_kick(trigger_t *t)
> +{
> +	cpus_setall(t->cpus);

We set the bits here.

> +	smp_wmb();
> +	t->trigger = 1;
> +	smp_wmb();
> +}

Nothing else.
