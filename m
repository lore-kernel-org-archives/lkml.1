Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170Ab0AZTbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0AZTbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078Ab0AZTbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:31:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:60843 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0AZTbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:31:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,347,1262592000"; 
   d="scan'208";a="534757993"
Subject: Re: [PATCH v2 1/2] cpufreq: ondemand: Refactor frequency increase
 code
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Mike Chan <mike@android.com>
Cc: "tj@kernel.org" <tj@kernel.org>,
       "Miller@fmi.uni-stuttgart.de" <Miller@fmi.uni-stuttgart.de>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1264470435-14739-1-git-send-email-mike@android.com>
References: <1264470435-14739-1-git-send-email-mike@android.com>
Content-Type: text/plain
Date: Tue, 26 Jan 2010 11:31:34 -0800
Message-Id: <1264534294.16916.345.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 17:47 -0800, Mike Chan wrote:
> Make simpler to read and call.
> 
> Signed-off-by: Mike Chan <mike@android.com>

Nack.
This patch seem to be changing the logic in the code. Comment inlined
below.

> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 4b34ade..3dcf126 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -443,6 +443,17 @@ static struct attribute_group dbs_attr_group_old = {
>  
>  /************************** sysfs end ************************/
>  
> +static int dbs_freq_increase(struct cpufreq_policy *p, unsigned int target_freq)
> +{
> +	if (dbs_tuners_ins.powersave_bias)
> +		target_freq = powersave_bias_target(p, target_freq,
> +				CPUFREQ_RELATION_H);
> +
> +	__cpufreq_driver_target(p, target_freq,
> +			dbs_tuners_ins.powersave_bias ?
> +			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
> +}
> +
>  static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
>  {
>  	unsigned int max_load_freq;
> @@ -520,19 +531,8 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
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
> +		if (policy->cur != policy->max)
> +			dbs_freq_increase(policy, policy->max);


In case of powersave_bias, bias_target and driver_target was getting
called even for cur == max before. After this change, they wont be
getting called, which would be wrong.


Thanks,
Venki

