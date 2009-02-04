Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZBDKIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZBDKIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZBDKHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:07:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:48119 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZBDKHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:07:51 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/7] CPUFREQ: ondemand/conservative: sanitize sampling_rate restrictions
Date: Wed, 4 Feb 2009 11:07:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: davej@codemonkey.org.uk, mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
References: <1233679606-1971-1-git-send-email-trenn@suse.de> <1233679606-1971-4-git-send-email-trenn@suse.de> <20090203210725.bed8a1dd.akpm@linux-foundation.org>
In-Reply-To: <20090203210725.bed8a1dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041107.48417.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 06:07:25 Andrew Morton wrote:
> On Tue,  3 Feb 2009 17:46:42 +0100 Thomas Renninger <trenn@suse.de> wrote:
> > Limit sampling rate to transition_latency * 100 or kernel limits.
> > If sampling_rate is tried to be set too low, set the lowest allowed
> > value.
> >
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > ---
> >  Documentation/cpu-freq/governors.txt   |   14 +++++++++++++-
> >  drivers/cpufreq/cpufreq_conservative.c |   19 ++++++++++++++++---
> >  drivers/cpufreq/cpufreq_ondemand.c     |   19 +++++++++++++++----
> >  3 files changed, 44 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/cpu-freq/governors.txt
> > b/Documentation/cpu-freq/governors.txt index 9b18512..ce73f3e 100644
> > --- a/Documentation/cpu-freq/governors.txt
> > +++ b/Documentation/cpu-freq/governors.txt
> > @@ -117,7 +117,19 @@ accessible parameters:
> >  sampling_rate: measured in uS (10^-6 seconds), this is how often you
> >  want the kernel to look at the CPU usage and to make decisions on
> >  what to do about the frequency.  Typically this is set to values of
> > -around '10000' or more.
> > +around '10000' or more. It's default value is (cmp. with
> > users-guide.txt): +transition_latency * 1000
> > +The lowest value you can set is:
> > +transition_latency * 100 or it may get restricted to a value where it
> > +makes not sense for the kernel anymore to poll that often which depends
> > +on your HZ config variable (HZ=1000: max=20000us, HZ=250: max=5000).
> > +Be aware that transition latency is in ns and sampling_rate is in us, so
> > you +get the same sysfs value by default.
> > +Sampling rate should always get adjusted considering the transition
> > latency +To set the sampling rate 750 times as high as the transition
> > latency +in the bash (as said, 1000 is default), do:
> > +echo `$(($(cat cpuinfo_transition_latency) * 750 / 1000)) \
> > +    >ondemand/sampling_rate
> >
> >  show_sampling_rate_(min|max): THIS INTERFACE IS DEPRECATED, DON'T USE
> > IT. You can use wider ranges now and the general
> > diff --git a/drivers/cpufreq/cpufreq_conservative.c
> > b/drivers/cpufreq/cpufreq_conservative.c index 5ba0a3f..b8bbd4a 100644
> > --- a/drivers/cpufreq/cpufreq_conservative.c
> > +++ b/drivers/cpufreq/cpufreq_conservative.c
> > @@ -54,7 +54,18 @@ static unsigned int def_sampling_rate;
> >  			(MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(10))
> >  #define MIN_SAMPLING_RATE			\
> >  			(def_sampling_rate / MIN_SAMPLING_RATE_RATIO)
This one will vanish after the deprecation time expired.

> > +/* Above MIN_SAMPLING_RATE will vanish with its sysfs file soon
> > + * Define the minimal settable sampling rate to the greater of:
> > + *   - "HW transition latency" * 100 (same as default sampling / 10)
> > + *   - MIN_STAT_SAMPLING_RATE
> > + * To avoid that userspace shoots itself.
> > +*/
> > +#define MINIMUM_SAMPLING_RATE			\
> > +			((def_sampling_rate / 10) < MIN_STAT_SAMPLING_RATE \
> > +			 ? MIN_STAT_SAMPLING_RATE : (def_sampling_rate / 10))
>
> Use
> 	max(def_sampling_rate / 10, MIN_STAT_SAMPLING_RATE)
> ?
Ok.

> But really, this should be a plain old C function.  Hiding a bunch of C
> code inside a macro which purports to be a compile-time constant is rude.
>
> > +/* This will also vanish soon with removing sampling_rate_max */
> >  #define MAX_SAMPLING_RATE			(500 * def_sampling_rate)
>
> Ditto, really.
This one will also be removed after the deprecation time expired.
Therefore I'd prefer to not touch it now and leave it as it is,
but I will remove these with finally removing sampling_rate_{min,max}.

I will also use max(..) where suggested and repost the three, modified
patches.
Thanks for your detailed, review. It's appreciated!

     Thomas

> > +
> >  #define DEF_SAMPLING_RATE_LATENCY_MULTIPLIER	(1000)
> >  #define DEF_SAMPLING_DOWN_FACTOR		(1)
> >  #define MAX_SAMPLING_DOWN_FACTOR		(10)
> > @@ -197,12 +208,14 @@ static ssize_t store_sampling_rate(struct
> > cpufreq_policy *unused, ret = sscanf (buf, "%u", &input);
> >
> >  	mutex_lock(&dbs_mutex);
> > -	if (ret != 1 || input > MAX_SAMPLING_RATE || input < MIN_SAMPLING_RATE)
> > { +	if (ret != 1) {
> >  		mutex_unlock(&dbs_mutex);
> >  		return -EINVAL;
> >  	}
> > -
> > -	dbs_tuners_ins.sampling_rate = input;
> > +	if  (input < MINIMUM_SAMPLING_RATE)
> > +		dbs_tuners_ins.sampling_rate = MINIMUM_SAMPLING_RATE;
> > +	else
> > +		dbs_tuners_ins.sampling_rate = input;
>
> 	dbs_tuners_ins.sampling_rate = max(MINIMUM_SAMPLING_RATE, input);
>
> >  	mutex_unlock(&dbs_mutex);
> >
> >  	return count;
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c
> > b/drivers/cpufreq/cpufreq_ondemand.c index 4b42e36..70e0841 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -52,6 +52,16 @@ static unsigned int def_sampling_rate;
> >  			(MIN_SAMPLING_RATE_RATIO * jiffies_to_usecs(10))
> >  #define MIN_SAMPLING_RATE			\
> >  			(def_sampling_rate / MIN_SAMPLING_RATE_RATIO)
> > +/* Above MIN_SAMPLING_RATE will vanish with its sysfs file soon
> > + * Define the minimal settable sampling rate to the greater of:
> > + *   - "HW transition latency" * 100 (same as default sampling / 10)
> > + *   - MIN_STAT_SAMPLING_RATE
> > + * To avoid that userspace shoots itself.
> > +*/
> > +#define MINIMUM_SAMPLING_RATE			\
> > +			((def_sampling_rate / 10) < MIN_STAT_SAMPLING_RATE \
> > +			 ? MIN_STAT_SAMPLING_RATE : (def_sampling_rate / 10))
> > +/* This will also vanish soon with removing sampling_rate_max */
> >  #define MAX_SAMPLING_RATE			(500 * def_sampling_rate)
> >  #define DEF_SAMPLING_RATE_LATENCY_MULTIPLIER	(1000)
> >  #define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
> > @@ -243,13 +253,14 @@ static ssize_t store_sampling_rate(struct
> > cpufreq_policy *unused, ret = sscanf(buf, "%u", &input);
> >
> >  	mutex_lock(&dbs_mutex);
> > -	if (ret != 1 || input > MAX_SAMPLING_RATE
> > -		     || input < MIN_SAMPLING_RATE) {
> > +	if (ret != 1) {
> >  		mutex_unlock(&dbs_mutex);
> >  		return -EINVAL;
> >  	}
> > -
> > -	dbs_tuners_ins.sampling_rate = input;
> > +	if  (input < MINIMUM_SAMPLING_RATE)
> > +		dbs_tuners_ins.sampling_rate = MINIMUM_SAMPLING_RATE;
> > +	else
> > +		dbs_tuners_ins.sampling_rate = input;
> >  	mutex_unlock(&dbs_mutex);
>
> etceterata.
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

