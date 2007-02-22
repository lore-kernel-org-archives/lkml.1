Return-Path: <linux-kernel-owner+w=401wt.eu-S1945946AbXBVIBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945946AbXBVIBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932847AbXBVIBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:01:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807AbXBVIBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:01:33 -0500
Date: Thu, 22 Feb 2007 08:56:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Speedup divides by cpu_power in scheduler
Message-ID: <20070222075623.GB9800@elte.hu>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org> <45DD46E5.4060804@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD46E5.4060804@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4995]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> I noticed expensive divides done in try_to_wakeup() and 
> find_busiest_group() on a bi dual core Opteron machine (total of 4 
> cores), moderatly loaded (15.000 context switch per second)
> 
> oprofile numbers :

nice patch! Ack for -mm testing:

Acked-by: Ingo Molnar <mingo@elte.hu>

one general suggestion: could you rename ->cpu_power to ->__cpu_power? 
That makes it perfectly clear that this field's semantics have changed 
and that it should never be manipulated directly without also changing 
->reciprocal_cpu_power, and will also flag any out of tree code 
trivially.

> + * Divide a load by a sched group cpu_power : (load / sg->cpu_power)
> + * Since cpu_power is a 'constant', we can use a reciprocal divide.
> + */
> +static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
> +{
> +	return reciprocal_divide(load, sg->reciprocal_cpu_power);
> +}
> +/*
> + * Each time a sched group cpu_power is changed,
> + * we must compute its reciprocal value
> + */
> +static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
> +{
> +	sg->cpu_power += val;
> +	BUG_ON(sg->cpu_power == 0);
> +	sg->reciprocal_cpu_power = reciprocal_value(sg->cpu_power);
> +}

Could you remove the BUG_ON() - it will most likely cause the 
non-inlining of these functions if CONFIG_CC_OPTIMIZE_FOR_SIZE=y and 
CONFIG_FORCED_INLINING is disabled (which is a popular combination in 
distro kernels, it reduces the kernel's size by over 30%). And it's not 
like we'll be able to overlook a divide by zero crash in 
reciprocal_value() anyway, if cpu_power were to be zero ;-)

	Ingo
