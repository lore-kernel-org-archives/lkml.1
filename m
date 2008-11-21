Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYKUTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYKUTpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKUTpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:45:43 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63392 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYKUTpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:45:42 -0500
Date: Fri, 21 Nov 2008 19:45:55 +0000
From: David Collier-Brown <David.Collier-Brown@Sun.COM>
Subject: Re: [RFC PATCH v4 1/7] sched: Framework for
 sched_mc/smt_power_savings=N
In-reply-to: <20081121083052.27075.87221.stgit@drishya.in.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@Sun.COM>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Reply-to: David.Collier-Brown@Sun.COM
Message-id: <49270FF3.6080302@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Enigmail-Version: 0.95.1
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
 <20081121083052.27075.87221.stgit@drishya.in.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080119)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> ***  RFC patch of work in progress and not for inclusion. ***
> 
> Currently the sched_mc/smt_power_savings variable is a boolean, which either
> enables or disables topology based power savings. This extends the behaviour of
> the variable from boolean to multivalued, such that based on the value, we
> decide how aggressively do we want to perform topology based powersavings
> balance.
> 
> Variable levels of power saving tunable would benefit end user to match the
> required level of power savings vs performance trade off depending on the
> system configuration and workloads.
> 
> This initial version makes the sched_mc_power_savings global variable to take
> more values (0,1,2).

  Might I suggest a dimensioned number rather than a relative one?
One might say that 100 represents the full power of a system, meaning
that all chips/cores are running at full speed, whereas 50 means that
the power system would attempt to halve the resources available, and
would return a value that represents the value that the power system
believes it has achieved.  For example, if it could only reduce the
clock speed by 10%, on a old uniprocessor, it would return 90.

  An additional, second value it might return might be the power
reduction it believed it had achieved.

  These, by the way, are what my Tadpole GUI shows (;-)) so I'm just
following someone else's lead.

--dave


> 
> Later version is expected to add new member sd->powersavings_level at the multi
> core CPU level sched_domain. This make all sd->flags check for
> SD_POWERSAVINGS_BALANCE into a different macro that will check for
> powersavings_level.
> 
> The power savings level setting should be in one place either in the
> sched_mc_power_savings global variable or contained within the appropriate
> sched_domain structure.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  include/linux/sched.h |   11 +++++++++++
>  kernel/sched.c        |   16 +++++++++++++---
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 644ffbd..d862837 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -760,6 +760,17 @@ enum cpu_idle_type {
>  #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
>  #define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
>  
> +enum powersavings_balance_level {
> +	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
> +	POWERSAVINGS_BALANCE_BASIC,	/* Fill one thread/core/package
> +					 * first for long running threads
> +					 */
> +	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
> +					 * cpu package for power savings
> +					 */
> +	MAX_POWERSAVINGS_BALANCE_LEVELS
> +};
> +
>  #define BALANCE_FOR_MC_POWER	\
>  	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9b1e793..ea33446 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7876,14 +7876,24 @@ int arch_reinit_sched_domains(void)
>  static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
>  {
>  	int ret;
> +	unsigned int level = 0;
>  
> -	if (buf[0] != '0' && buf[0] != '1')
> +	sscanf(buf, "%u", &level);
> +
> +	/*
> +	 * level is always be positive so don't check for
> +	 * level < POWERSAVINGS_BALANCE_NONE which is 0
> +	 * What happens on 0 or 1 byte write,
> +	 * need to check for count as well?
> +	 */
> +
> +	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
>  		return -EINVAL;
>  
>  	if (smt)
> -		sched_smt_power_savings = (buf[0] == '1');
> +		sched_smt_power_savings = level;
>  	else
> -		sched_mc_power_savings = (buf[0] == '1');
> +		sched_mc_power_savings = level;
>  
>  	ret = arch_reinit_sched_domains();
>  
> 
> 

-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
