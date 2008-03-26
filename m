Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYCZFET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYCZFET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 01:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYCZFEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 01:04:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:39211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYCZFEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 01:04:07 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: yi.y.yang@intel.com
Subject: Re: [PATCH 2.6.25-rc3] cpuidle: fix cpuidle time and usage overflow
Date: Wed, 26 Mar 2008 00:46:41 -0400
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, venkatesh.pallipadi@intel.com,
       cpufreq@lists.linux.org.uk, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <1203032921.3897.10.camel@yangyi-dev.bj.intel.com> <1203900372.4954.8.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1203900372.4954.8.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260046.41250.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
-len

On Sunday 24 February 2008, Yi Yang wrote:
> cpuidle C-state sysfs node time and usage are very easy to overflow because
> they are all of unsigned int type, time will overflow within about two hours,
> usage will take longer time to overflow, but they are increasing for ever.
> 
> This patch will convert them to unsigned long long.
> 
> 
> Signed-off-by: Yi Yang <yi.y.yang@intel.com>
> ---
>  drivers/cpuidle/cpuidle.c |    2 +-
>  drivers/cpuidle/sysfs.c   |   10 ++++++++--
>  include/linux/cpuidle.h   |    4 ++--
> 
> --- a/include/linux/cpuidle.h	2008-02-25 02:31:26.000000000 -0500
> +++ b/include/linux/cpuidle.h	2008-02-25 04:30:24.000000000 -0500
> @@ -38,8 +38,8 @@ struct cpuidle_state {
>  	unsigned int	power_usage; /* in mW */
>  	unsigned int	target_residency; /* in US */
>  
> -	unsigned int	usage;
> -	unsigned int	time; /* in US */
> +	unsigned long long	usage;
> +	unsigned long long	time; /* in US */
>  
>  	int (*enter)	(struct cpuidle_device *dev,
>  			 struct cpuidle_state *state);
> --- a/drivers/cpuidle/cpuidle.c	2008-02-25 02:37:14.000000000 -0500
> +++ b/drivers/cpuidle/cpuidle.c	2008-02-25 04:29:19.000000000 -0500
> @@ -67,7 +67,7 @@ static void cpuidle_idle_call(void)
>  	/* enter the state and update stats */
>  	dev->last_residency = target_state->enter(dev, target_state);
>  	dev->last_state = target_state;
> -	target_state->time += dev->last_residency;
> +	target_state->time += (unsigned long long)dev->last_residency;
>  	target_state->usage++;
>  
>  	/* give the governor an opportunity to reflect on the outcome */
> --- a/drivers/cpuidle/sysfs.c	2008-02-25 02:33:14.000000000 -0500
> +++ b/drivers/cpuidle/sysfs.c	2008-02-25 03:10:50.000000000 -0500
> @@ -218,6 +218,12 @@ static ssize_t show_state_##_name(struct
>  	return sprintf(buf, "%u\n", state->_name);\
>  }
>  
> +#define define_show_state_ull_function(_name) \
> +static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
> +{ \
> +	return sprintf(buf, "%llu\n", state->_name);\
> +}
> +
>  #define define_show_state_str_function(_name) \
>  static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
>  { \
> @@ -228,8 +234,8 @@ static ssize_t show_state_##_name(struct
>  
>  define_show_state_function(exit_latency)
>  define_show_state_function(power_usage)
> -define_show_state_function(usage)
> -define_show_state_function(time)
> +define_show_state_ull_function(usage)
> +define_show_state_ull_function(time)
>  define_show_state_str_function(name)
>  define_show_state_str_function(desc)
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


