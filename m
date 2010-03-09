Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0CIMGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:06:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:37277 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0CIMGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:06:04 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: Suse Linux
To: minyard@acm.org, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] IPMI: Add parameter to limit CPU usage in kipmid
Date: Tue, 9 Mar 2010 13:05:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32.8-0.3-pae; KDE/4.3.5; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Gary Smith <gasmith@redhat.com>
References: <20100303161438.GA17623@minyard.local>
In-Reply-To: <20100303161438.GA17623@minyard.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003091305.58136.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey, Linus,

On Wednesday 03 March 2010 05:14:38 pm Corey Minyard wrote:
> From: Martin Wilck <martin.wilck@ts.fujitsu.com>
> 
> In some cases kipmid can use a lot of CPU.  This adds a way to tune
> the CPU used by kipmid to help in those cases.  By setting
> kipmid_max_busy_us to a value between 100 and 500, it is possible to
> bring down kipmid CPU load to practically 0 without loosing too much
> ipmi throughput performance.  Not setting the value, or setting the
> value to zero, operation is unaffected.
> 
> Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
> Cc: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
> This patch has been discussed quite a bit, and I believe all issues with it
> have been resolved.  It's not great, but nobody has a better way to handle
> the problem.

I still can't see this patch in Linus' tree as of 2.6.34-rc1. It has been 
waiting for sooo long already, can we finally get it in? Linus, will you apply 
it? Or should it go through Andrew?

Thanks.

> Index: linux-2.6.32/drivers/char/ipmi/ipmi_si_intf.c
> ===================================================================
> --- linux-2.6.32.orig/drivers/char/ipmi/ipmi_si_intf.c
> +++ linux-2.6.32/drivers/char/ipmi/ipmi_si_intf.c
> @@ -294,6 +294,9 @@ struct smi_info {
>  static int force_kipmid[SI_MAX_PARMS];
>  static int num_force_kipmid;
> 
> +static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
> +static int num_max_busy_us;
> +
>  static int unload_when_empty = 1;
> 
>  static int try_smi_init(struct smi_info *smi);
> @@ -924,23 +927,77 @@ static void set_run_to_completion(void *
>  	}
>  }
> 
> +/*
> + * Use -1 in the nsec value of the busy waiting timespec to tell that
> + * we are spinning in kipmid looking for something and not delaying
> + * between checks
> + */
> +static inline void ipmi_si_set_not_busy(struct timespec *ts)
> +{
> +	ts->tv_nsec = -1;
> +}
> +static inline int ipmi_si_is_busy(struct timespec *ts)
> +{
> +	return ts->tv_nsec != -1;
> +}
> +
> +static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
> +				 const struct smi_info *smi_info,
> +				 struct timespec *busy_until)
> +{
> +	unsigned int max_busy_us = 0;
> +
> +	if (smi_info->intf_num < num_max_busy_us)
> +		max_busy_us = kipmid_max_busy_us[smi_info->intf_num];
> +	if (max_busy_us == 0 || smi_result != SI_SM_CALL_WITH_DELAY)
> +		ipmi_si_set_not_busy(busy_until);
> +	else if (!ipmi_si_is_busy(busy_until)) {
> +		getnstimeofday(busy_until);
> +		timespec_add_ns(busy_until, max_busy_us*NSEC_PER_USEC);
> +	} else {
> +		struct timespec now;
> +		getnstimeofday(&now);
> +		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
> +			ipmi_si_set_not_busy(busy_until);
> +			return 0;
> +		}
> +	}
> +	return 1;
> +}
> +
> +
> +/*
> + * A busy-waiting loop for speeding up IPMI operation.
> + *
> + * Lousy hardware makes this hard.  This is only enabled for systems
> + * that are not BT and do not have interrupts.  It starts spinning
> + * when an operation is complete or until max_busy tells it to stop
> + * (if that is enabled).  See the paragraph on kimid_max_busy_us in
> + * Documentation/IPMI.txt for details.
> + */
>  static int ipmi_thread(void *data)
>  {
>  	struct smi_info *smi_info = data;
>  	unsigned long flags;
>  	enum si_sm_result smi_result;
> +	struct timespec busy_until;
> 
> +	ipmi_si_set_not_busy(&busy_until);
>  	set_user_nice(current, 19);
>  	while (!kthread_should_stop()) {
> +		int busy_wait;
> +
>  		spin_lock_irqsave(&(smi_info->si_lock), flags);
>  		smi_result = smi_event_handler(smi_info, 0);
>  		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
> +		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
> +						  &busy_until);
>  		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
>  			; /* do nothing */
> -		else if (smi_result == SI_SM_CALL_WITH_DELAY)
> +		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
>  			schedule();
>  		else
> -			schedule_timeout_interruptible(1);
> +			schedule_timeout_interruptible(0);
>  	}
>  	return 0;
>  }
> @@ -1211,6 +1268,11 @@ module_param(unload_when_empty, int, 0);
>  MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces
>  are" " specified or found, default is 1.  Setting to 0"
>  		 " is useful for hot add of devices using hotmod.");
> +module_param_array(kipmid_max_busy_us, uint, &num_max_busy_us, 0644);
> +MODULE_PARM_DESC(kipmid_max_busy_us,
> +		 "Max time (in microseconds) to busy-wait for IPMI data before"
> +		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
> +		 " if kipmid is using up a lot of CPU time.");
> 
> 
>  static void std_irq_cleanup(struct smi_info *info)
> Index: linux-2.6.32/Documentation/IPMI.txt
> ===================================================================
> --- linux-2.6.32.orig/Documentation/IPMI.txt
> +++ linux-2.6.32/Documentation/IPMI.txt
> @@ -365,6 +365,7 @@ You can change this at module load time
>         regshifts=<shift1>,<shift2>,...
>         slave_addrs=<addr1>,<addr2>,...
>         force_kipmid=<enable1>,<enable2>,...
> +       kipmid_max_busy_us=<ustime1>,<ustime2>,...
>         unload_when_empty=[0|1]
> 
>  Each of these except si_trydefaults is a list, the first item for the
> @@ -433,6 +434,7 @@ kernel command line as:
>         ipmi_si.regshifts=<shift1>,<shift2>,...
>         ipmi_si.slave_addrs=<addr1>,<addr2>,...
>         ipmi_si.force_kipmid=<enable1>,<enable2>,...
> +       ipmi_si.kipmid_max_busy_us=<ustime1>,<ustime2>,...
> 
>  It works the same as the module parameters of the same names.
> 
> @@ -450,6 +452,16 @@ force this thread on or off.  If you for
>  interrupts, the driver will run VERY slowly.  Don't blame me,
>  these interfaces suck.
> 
> +Unfortunately, this thread can use a lot of CPU depending on the
> +interface's performance.  This can waste a lot of CPU and cause
> +various issues with detecting idle CPU and using extra power.  To
> +avoid this, the kipmid_max_busy_us sets the maximum amount of time, in
> +microseconds, that kipmid will spin before sleeping for a tick.  This
> +value sets a balance between performance and CPU waste and needs to be
> +tuned to your needs.  Maybe, someday, auto-tuning will be added, but
> +that's not a simple thing and even the auto-tuning would need to be
> +tuned to the user's desired performance.
> +
>  The driver supports a hot add and remove of interfaces.  This way,
>  interfaces can be added or removed after the kernel is up and running.
>  This is done using /sys/modules/ipmi_si/parameters/hotmod, which is a

-- 
Jean Delvare
Suse L3
