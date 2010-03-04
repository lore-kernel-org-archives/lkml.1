Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0CDV1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:27:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab0CDV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:27:48 -0500
Date: Thu, 4 Mar 2010 13:27:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <bhavna.sarathy@amd.com>, <joachim.deguara@amd.com>,
       <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/3] cpufreq: add sysfs knob for toggling core
 performance boost
Message-Id: <20100304132743.e2b731da.akpm@linux-foundation.org>
In-Reply-To: <201003031459.27757.mark.langsdorf@amd.com>
References: <201003031459.27757.mark.langsdorf@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 14:59:27 -0600
Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> >From 1ba7af20a37b72a4375d3e3ddd33a033f204ee21 Mon Sep 17 00:00:00 2001
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> Date: Wed, 3 Mar 2010 14:34:47 -0600
> Subject: [PATCH 2/2] cpufreq: add sysfs knob for toggling core performance boost
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>

The lack of any changelog in a patch is usually a good sign that the
patch needs a changelog :(

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 67bc2ec..e0fe93f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -662,6 +662,30 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
>  	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
>  }
>  
> +static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
> +				 size_t count)
> +{
> +	int ret = -EINVAL;
> +	unsigned long val = 0;
> +
> +	ret = strict_strtoul(buf, 10, &val);
> +	if (!ret && (val == 0 || val == 1))
> +		policy->flags.cpb = val;
> +	else
> +		return -EINVAL;
> +
> +	ret = __cpufreq_driver_target(policy, policy->cur, CPUFREQ_RELATION_H);
> +	if (ret)
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
> +static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
> +{
> +	return sprintf(buf, "%u\n", policy->flags.cpb);
> +}
> +
>  #define define_one_ro(_name) \
>  static struct freq_attr _name = \
>  __ATTR(_name, 0444, show_##_name, NULL)
> @@ -688,6 +712,7 @@ define_one_rw(scaling_min_freq);
>  define_one_rw(scaling_max_freq);
>  define_one_rw(scaling_governor);
>  define_one_rw(scaling_setspeed);
> +define_one_rw(cpb);
>  
>  static struct attribute *default_attrs[] = {
>  	&cpuinfo_min_freq.attr,
> @@ -701,6 +726,7 @@ static struct attribute *default_attrs[] = {
>  	&scaling_driver.attr,
>  	&scaling_available_governors.attr,
>  	&scaling_setspeed.attr,
> +	&cpb.attr,
>  	NULL
>  };

Well I've read the code and I've read the code comments and I've read
the changelogs and I still have no clue what this thing does. 
Apparently it allows me to toggle something called "APERF/MPERF".  I
guess if I were patient enough, teh goog might tell me what that is,
and why I might want it.  But this is all terribly inefficient.

I think you'd find that your feature is more useful and will be used by
more people if you tell them (and us) what it does.

