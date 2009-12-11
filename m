Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZLKXMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZLKXMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbZLKXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:12:30 -0500
Received: from isilmar.linta.de ([213.133.102.198]:42269 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761495AbZLKXM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:12:29 -0500
Date: Sat, 12 Dec 2009 00:12:34 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org, mjg@redhat.com, trenn@suse.de,
       lenb@kernel.org
Subject: Re: [PATCH] cpufreq: Processor Clocking Control interface driver
Message-ID: <20091211231233.GA4291@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Naga Chumbalkar <nagananda.chumbalkar@hp.com>, davej@redhat.com,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	linux-acpi@vger.kernel.org, mjg@redhat.com, trenn@suse.de,
	lenb@kernel.org
References: <20091128034424.6796.75673.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091128034424.6796.75673.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Dec 11, 2009 at 10:55:40PM +0000, Naga Chumbalkar wrote:
> +The VERSION number for the driver will be of the format v.xy.ab.
> +eg: 1.00.02
> +   ----- --
> +    |    |
> +    |    -- this will increase with bug fixes/enhancements to the driver
> +    |-- this is the version of the PCC specification the driver adheres to

If this is _really_ necessary... Doesn't the driver version relate to some
Linux kernel version anyway?

> +2.1 scaling_available_frequencies:
> +----------------------------------
> +scaling_available_frequencies indicates the minimum and maximum speed
> +the CPU can take as advertised by the BIOS. No intermediate frequencies are
> +listed because the BIOS will try to achieve any intermediate frequency
> +requested by the governor. An intermediate frequency does not have to be
> +strictly associated with a P-state.

Why do you export scaling_available_frequencies anyway? It's made available
by the _optional_ freq-table helper module, which is wrong to use in this
case anyway.

> +2.2 cpuinfo_transition_latency:
> +-------------------------------
> +The cpuinfo_transition_latency field is 0. The PCC specification does
> +not include a field to expose this value currently.

Uh, bad specification... So does it work properly with ondemand and/or
conservative (which read out this field, and if latency=0 use a minimum
value)?

> +config X86_PCC_CPUFREQ
> +	tristate "Processor Clocking Control interface driver"
> +	select CPU_FREQ_TABLE
Uh, see above.

> +static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
> +{
> +	return cpufreq_frequency_table_verify(policy, pcc_freq_table);
> +}

Well, AFAICS, this limits the whole interface to two values: min or max. So
let's allow for any intermediate value:

static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
{
	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq, policy->cpuinfo.max_freq);
}

but well... later on, you check this:

> +	if (target_freq <= (ioread32(&pcch_hdr->minimum_frequency) * 1000)) {
> +		target_freq = ioread32(&pcch_hdr->minimum_frequency) * 1000;
> +		dprintk("target: target_freq for cpu %d was below limit, "
> +			"converted it to %d\n", cpu, target_freq);
> +	}

why not do this in the _verify() step? Does pcch_hdr->minimum_frequency
even change "on the fly"?

So, I'd propose to NACK this patch at the moment.

Best,
	Dominik
