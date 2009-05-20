Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZETFTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZETFTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZETFTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:19:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56198 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZETFTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:19:23 -0400
Message-ID: <4A1392A9.9010609@zytor.com>
Date: Tue, 19 May 2009 22:18:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on	several
 CPUs
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab>
In-Reply-To: <20090519172449.GB18874@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> +
> +/* rdmsr on a bunch of CPUs
> + *
> + * @mask:	which CPUs
> + * @msr_no:	which MSR
> + * @msrs:	array of MSR values
> + *
> + * Returns:
> + * 0 - success
> + * <0 - read failed on at least one CPU (latter in the mask)
> + */
> +int rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
> +{
> +	struct msr *reg;
> +	int cpu, tmp, err = 0;
> +	int off = cpumask_first(mask);
> +
> +	for_each_cpu(cpu, mask) {
> +		reg = &msrs[cpu - off];
> +
> +		tmp = rdmsr_on_cpu(cpu, msr_no, &reg->l, &reg->h);
> +		if (tmp)
> +			err = tmp;
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL(rdmsr_on_cpus);
> +
> +/*
> + * wrmsr of a bunch of CPUs
> + *
> + * @mask:	which CPUs
> + * @msr_no:	which MSR
> + * @msrs:	array of MSR values
> +  *
> + * Returns:
> + * 0 - success
> + * <0 - write failed on at least one CPU (latter in the mask)
> + */
> +int wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
> +{
> +	struct msr reg;
> +	int cpu, tmp, err = 0;
> +	int off = cpumask_first(mask);
> +
> +	for_each_cpu(cpu, mask) {
> +		reg = msrs[cpu - off];
> +
> +		tmp = wrmsr_on_cpu(cpu, msr_no, reg.l, reg.h);
> +		if (tmp)
> +			err = tmp;
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL(wrmsr_on_cpus);
> +

Okay, now I'm *really* confused.

I thought the whole point of these functions was to allow these MSR
references to take place in parallel, as opposed to doing outcalls to
each CPU in order... but that's exactly what these functions do.

So what was the point of them again?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

