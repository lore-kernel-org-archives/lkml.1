Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563Ab0A0XiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0A0XiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547Ab0A0XiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:38:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:38362 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab0A0XiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:38:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,356,1262592000"; 
   d="scan'208";a="535206333"
Subject: Re: [PATCH v3 1/2] cpufreq: ondemand: Refactor frequency increase
 code
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mike Chan <mike@android.com>
Cc: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Tejun Heo <tj@kernel.org>,
       Alexander Miller <Miller@fmi.uni-stuttgart.de>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1264554408-20966-1-git-send-email-mike@android.com>
References: <1264554408-20966-1-git-send-email-mike@android.com>
Content-Type: text/plain
Date: Wed, 27 Jan 2010 15:37:01 -0800
Message-Id: <1264635421.16916.461.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

On Tue, 2010-01-26 at 17:06 -0800, Mike Chan wrote:
> Make simpler to read and call.
> 
> *** v3 - Always call when powersave_bias is enabled.
> 
> Signed-off-by: Mike Chan <mike@android.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   25 ++++++++++++-------------
>  1 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 4b34ade..516d0fe 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -443,6 +443,17 @@ static struct attribute_group dbs_attr_group_old = {
>  
>  /************************** sysfs end ************************/
>  
> +static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
> +{
> +	if (dbs_tuners_ins.powersave_bias)
> +		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
> +	else if (p->cur == p->max)
> +		return;
> +
> +	__cpufreq_driver_target(p, freq, dbs_tuners_ins.powersave_bias ?
> +			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
> +}
> +
>  static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>  {
>  	unsigned int max_load_freq;
> @@ -520,19 +531,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>  
>  	/* Check for frequency increase */
>  	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
> -		/* if we are already at full speed then break out early */
> -		if (!dbs_tuners_ins.powersave_bias) {
> -			if (policy->cur == policy->max)
> -				return;
> -
> -			__cpufreq_driver_target(policy, policy->max,
> -				CPUFREQ_RELATION_H);
> -		} else {
> -			int freq = powersave_bias_target(policy, policy->max,
> -					CPUFREQ_RELATION_H);
> -			__cpufreq_driver_target(policy, freq,
> -				CPUFREQ_RELATION_L);
> -		}
> +		dbs_freq_increase(policy, policy->max);
>  		return;
>  	}
>  


