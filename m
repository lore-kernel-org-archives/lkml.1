Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYKYP6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYKYP6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYKYP6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:58:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYKYP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:58:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [Patch 3/3] OProfile SPU event profiling support for IBM Cell processor
Date: Tue, 25 Nov 2008 16:58:31 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org
References: <1227569215.6509.216.camel@carll-linux-desktop>
In-Reply-To: <1227569215.6509.216.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251658.32327.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19prC6D6GiJs7/UWEWncsZvY8PeYs24RV8uBbx
 /+OVrjPla17S2GMW+6Ca8NWBzjqMbvpxVkmoDMz8OpsQQTWtfz
 sxwQEDftDvjakp2AmLwEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008, Carl Love wrote:
> 
> This is the second of the two kernel  patches for adding SPU profiling 
> for the IBM Cell processor.  This patch contains the spu event profiling
> setup, start and stop routines.
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>

Maybe a little more detailed description would be good. Explain
what this patch adds that isn't already there and why people would
want to have that in the kernel.
 
>  
>  static void cell_global_stop_spu_cycles(void);
> +static void cell_global_stop_spu_events(void);

Can you reorder the functions so that you don't need any forward
declarations? In general, it gets easier to understand if the
definition order matches the call graph.

>  static unsigned int spu_cycle_reset;
>  static unsigned int profiling_mode;
> -
> +static int spu_evnt_phys_spu_indx;
>  
>  struct pmc_cntrl_data {
>  	unsigned long vcntr;
> @@ -111,6 +126,8 @@ struct pm_cntrl {
>  	u16 trace_mode;
>  	u16 freeze;
>  	u16 count_mode;
> +	u16 spu_addr_trace;
> +	u8  trace_buf_ovflw;
>  };
>  
>  static struct {
> @@ -128,7 +145,7 @@ static struct {
>  #define GET_INPUT_CONTROL(x) ((x & 0x00000004) >> 2)
>  
>  static DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
> -
> +static unsigned long spu_pm_cnt[MAX_NUMNODES * NUM_SPUS_PER_NODE];
>  static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];

Can't you add this data to an existing data structure, e.g. struct spu,
rather than adding a new global?
  
>  static u32 reset_value[NR_PHYS_CTRS];
>  static int num_counters;
>  static int oprofile_running;
> -static DEFINE_SPINLOCK(virt_cntr_lock);
> +static DEFINE_SPINLOCK(cntr_lock);
>  
>  static u32 ctr_enabled;
>  
> @@ -242,7 +260,6 @@ static int pm_rtas_activate_signals(u32 
>  	i = 0;
>  	for (j = 0; j < count; j++) {
>  		if (pm_signal[j].signal_group != PPU_CYCLES_GRP_NUM) {
> -
>  			/* fw expects physical cpu # */
>  			pm_signal_local[i].cpu = node;
>  			pm_signal_local[i].signal_group
> @@ -265,7 +282,6 @@ static int pm_rtas_activate_signals(u32 
>  			return -EIO;
>  		}
>  	}
> -
>  	return 0;
>  }
>  

These look like a cleanups that should go into the first patch, right?

> +static void spu_evnt_swap(unsigned long data)

This function could use a comment about why we need to swap and what
the overall effect of swapping is.

>  int spu_prof_running;
>  static unsigned int profiling_interval;
> +DEFINE_SPINLOCK(oprof_spu_smpl_arry_lck);
> +unsigned long oprof_spu_smpl_arry_lck_flags;
>  
>  #define NUM_SPU_BITS_TRBUF 16
>  #define SPUS_PER_TB_ENTRY   4
> +#define SPUS_PER_NODE       8
>  
>  #define SPU_PC_MASK	     0xFFFF
>  
> -static DEFINE_SPINLOCK(sample_array_lock);
> -unsigned long sample_array_lock_flags;
> -

This also looks like a rename that should go into the first patch.

> +/*
> + * Entry point for SPU event profiling.
> + * NOTE:  SPU profiling is done system-wide, not per-CPU.
> + *
> + * cycles_reset is the count value specified by the user when
> + * setting up OProfile to count SPU_CYCLES.
> + */
> +void start_spu_profiling_events(void)
> +{
> +	spu_prof_running = 1;
> +	schedule_delayed_work(&spu_work, DEFAULT_TIMER_EXPIRE);
> +
> +	return;
> +}
> +
> +void stop_spu_profiling_cycles(void)
>  {
>  	spu_prof_running = 0;
>  	hrtimer_cancel(&timer);
>  	kfree(samples);
> -	pr_debug("SPU_PROF: stop_spu_profiling issued\n");
> +	pr_debug("SPU_PROF: stop_spu_profiling_cycles issued\n");
> +}
> +
> +void stop_spu_profiling_events(void)
> +{
> +	spu_prof_running = 0;
>  }

Is this atomic? What if two CPUs access the spu_prof_running variable at
the same time?

	Arnd <><
