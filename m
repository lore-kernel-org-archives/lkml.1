Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZKZJbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZKZJbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZKZJbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:31:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54194 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZKZJbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:31:24 -0500
Date: Thu, 26 Nov 2009 10:31:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH - 2/2] tip, x86-microcode: refactor microcode output
 messages
Message-ID: <20091126093123.GA32275@elte.hu>
References: <1259189772.7940.48.camel@dimm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259189772.7940.48.camel@dimm>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* dimm <dmitry.adamushko@gmail.com> wrote:

> +static int summarize_cpu_range(struct cpumask *range, struct cpu_signature *csig)
> +{
> +	char *cpu_str, *ver_str;
> +	int ret = -1;
> +
> +	cpu_str = kmalloc(128, GFP_KERNEL);
> +	ver_str = kmalloc(128, GFP_KERNEL);
> +	if (!cpu_str || !ver_str)
> +		goto out;
> +
> +	cpulist_scnprintf(cpu_str, 128, range);
> +	microcode_ops->version_snprintf(ver_str, 128, csig);
> +
> +        printk(KERN_INFO "microcode: CPU%s: %s\n", cpu_str, ver_str);
> +	ret = 0;
> +out:
> +	if (cpu_str)
> +		kfree(cpu_str);
> +	if (ver_str)
> +		kfree(ver_str);
> +
> +	return ret;
> +}
> +
> +static void summarize_cpu_info(void)
> +{
> +	struct cpu_info_array_ctx *ctx_array;
> +	cpumask_var_t cpulist;
> +	int base, cpu, ret;
> +
> +	if (!zalloc_cpumask_var(&cpulist, GFP_KERNEL))
> +		return;
> +
> +	ctx_array = kmalloc(nr_cpu_ids * sizeof(*ctx_array), GFP_KERNEL);
> +	if (!ctx_array)
> +		goto out;
> +
> +	ret = on_each_cpu(collect_cpu_info_array, ctx_array, 1);
> +	if (ret)
> +		goto out;
> +
> +	base = cpumask_first(cpu_online_mask);
> +	cpu  = base;
> +	cpumask_set_cpu(cpu, cpulist);
> +
> +	while ((cpu = cpumask_next(cpu, cpu_online_mask)) < nr_cpu_ids) {
> +		if (memcmp(&ctx_array[base].cpu_sig, &ctx_array[cpu].cpu_sig,
> +				sizeof(ctx_array[base].cpu_sig)) != 0) {
> +			summarize_cpu_range(cpulist, &ctx_array[base].cpu_sig);
> +			cpumask_clear(cpulist);
> +			base = cpu;
> +		}
> +		cpumask_set_cpu(cpu, cpulist);
> +	}
> +	summarize_cpu_range(cpulist, &ctx_array[base].cpu_sig);
> +out:
> +	free_cpumask_var(cpulist);
> +	if (ctx_array)
> +		kfree(ctx_array);
> +}

Could we please leave out this summarizing logic (it's bloaty and 
unnecessary), and just print a single line message when applying the 
microcode?

Thanks,

	Ingo
