Return-Path: <linux-kernel-owner+w=401wt.eu-S1761079AbZFJTmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761079AbZFJTmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZFJTmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:42:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3465 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbZFJTmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:42:23 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R1805Mzz1202hzzz32i6bh17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KL1G27-01-4MM-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Date: Wed, 10 Jun 2009 14:42:16 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730362099D@sausexmb4.amd.com>
In-Reply-To: <200906101552.17397.rusty@rustcorp.com.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Thread-Index: Acnpk9wVTq68BFsRSyCP96fRCMhVEQAbywfQ
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain> <200906101552.17397.rusty@rustcorp.com.au>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
CC: "Yinghai Lu" <yinghai@kernel.org>, "Avi Kivity" <avi@redhat.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>, <cpufreq@vger.kernel.org>
X-OriginalArrivalTime: 10 Jun 2009 19:42:17.0482 (UTC) FILETIME=[8FC7FEA0:01C9EA03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> powernow_k8_target is problematic: it grabs a mutex.  cpufreq 
> people, is this called often?
 
Yes.  It's the function that makes a frequency change
happen, so 5+ times per second per core isn't
unreasonable.

-Mark Langsdorf
Operating System Research Center
AMD


> Subject: cpumask: avoid playing with cpus_allowed in powernow-k8.c
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> It's generally a very bad idea to mug some process's cpumask: it could
> legitimately and reasonably be changed by root, which could break us
> (if done before our code) or them (if we restore the wrong value).
> 
> I use work_on_cpu, which is slightly less efficient than the old code,
> but the code is complex enough that using smp_call_function_single()
> is not trivial.


> -/* Driver entry point to switch to the target frequency */
> -static int powernowk8_target(struct cpufreq_policy *pol,
> -		unsigned targfreq, unsigned relation)
> +struct target_data {
> +	struct cpufreq_policy *pol;
> +	unsigned targfreq;
> +	unsigned relation;
> +};
> +
> +static long powernowk8_target_on_cpu(void *_tdata)
>  {
> -	cpumask_t oldmask;
> +	struct target_data *tdata = _tdata;
> +	struct cpufreq_policy *pol = tdata->pol;
>  	struct powernow_k8_data *data = per_cpu(powernow_data, 
> pol->cpu);
>  	u32 checkfid;
>  	u32 checkvid;
> @@ -1158,22 +1152,13 @@ static int powernowk8_target(struct cpuf
>  	checkfid = data->currfid;
>  	checkvid = data->currvid;
>  
> -	/* only run on specific CPU from here on */
> -	oldmask = current->cpus_allowed;
> -	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
> -
> -	if (smp_processor_id() != pol->cpu) {
> -		printk(KERN_ERR PFX "limiting to cpu %u 
> failed\n", pol->cpu);
> -		goto err_out;
> -	}
> -
>  	if (pending_bit_stuck()) {
>  		printk(KERN_ERR PFX "failing targ, change 
> pending bit set\n");
>  		goto err_out;
>  	}
>  
>  	dprintk("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
> -		pol->cpu, targfreq, pol->min, pol->max, relation);
> +		pol->cpu, tdata->targfreq, pol->min, pol->max, 
> tdata->relation);
>  
>  	if (query_current_values_with_pending_wait(data))
>  		goto err_out;
> @@ -1193,7 +1178,8 @@ static int powernowk8_target(struct cpuf
>  	}
>  
>  	if (cpufreq_frequency_table_target(pol, data->powernow_table,
> -				targfreq, relation, &newstate))
> +					   tdata->targfreq, 
> tdata->relation,
> +					   &newstate))
>  		goto err_out;
>  
>  	mutex_lock(&fidvid_mutex);
> @@ -1220,10 +1206,19 @@ static int powernowk8_target(struct cpuf
>  	ret = 0;
>  
>  err_out:
> -	set_cpus_allowed_ptr(current, &oldmask);
>  	return ret;
>  }
>  
> +/* Driver entry point to switch to the target frequency */
> +static int powernowk8_target(struct cpufreq_policy *pol,
> +			     unsigned targfreq, unsigned relation)
> +{
> +	struct target_data tdata = { .pol = pol,
> +				     .targfreq = targfreq,
> +				     .relation = relation };
> +	return work_on_cpu(pol->cpu, powernowk8_target_on_cpu, &tdata);
> +}
> +
>  /* Driver entry point to verify the policy and range of 
> frequencies */
>  static int powernowk8_verify(struct cpufreq_policy *pol)
>  {

