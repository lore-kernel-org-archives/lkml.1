Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbXIFU5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbXIFU5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXIFU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:57:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38066 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbXIFU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:57:34 -0400
Date: Thu, 6 Sep 2007 13:55:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Scheduler Profiling - Use Immediate Values
Message-Id: <20070906135552.e26da051.randy.dunlap@oracle.com>
In-Reply-To: <20070906200537.GA5999@Krystal>
References: <20070906200537.GA5999@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2007 16:05:37 -0400 Mathieu Desnoyers wrote:

> Scheduler Profiling - Use Immediate Values
> 
> Use immediate values with lower d-cache hit in optimized version as a
> condition for scheduler profiling call.
> 
> Depends on the Immediate values patches, applies to 2.6.23-rc4-mm1.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  drivers/kvm/svm.c       |    2 +-
>  drivers/kvm/vmx.c       |    2 +-
>  include/linux/profile.h |   10 ++++------
>  kernel/profile.c        |   38 ++++++++++++++++++++++++++------------
>  kernel/sched.c          |    3 ++-
>  5 files changed, 34 insertions(+), 21 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/profile.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/profile.c	2007-09-04 11:53:23.000000000 -0400
> +++ linux-2.6-lttng/kernel/profile.c	2007-09-04 12:12:16.000000000 -0400
> @@ -42,9 +42,6 @@ static int (*timer_hook)(struct pt_regs 
>  static atomic_t *prof_buffer;
>  static unsigned long prof_len, prof_shift;
>  
> -int prof_on __read_mostly;
> -EXPORT_SYMBOL_GPL(prof_on);
> -
>  static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
>  #ifdef CONFIG_SMP
>  static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
> @@ -52,6 +49,14 @@ static DEFINE_PER_CPU(int, cpu_profile_f
>  static DEFINE_MUTEX(profile_flip_mutex);
>  #endif /* CONFIG_SMP */
>  
> +/* Immediate values */
> +immediate_char_t sleep_profiling __read_mostly,
> +			sched_profiling __read_mostly,
> +			kvm_profiling __read_mostly,
> +			cpu_profiling __read_mostly;
> +EXPORT_SYMBOL_GPL(kvm_profiling);
> +EXPORT_SYMBOL_GPL(cpu_profiling);
> +
>  static int __init profile_setup(char * str)
>  {
>  	static char __initdata schedstr[] = "schedule";
> @@ -60,7 +65,7 @@ static int __init profile_setup(char * s
>  	int par;
>  
>  	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
> -		prof_on = SLEEP_PROFILING;
> +		immediate_set_early(&sleep_profiling, 1);

These are booleans, eh?  so one could use            , true);

etc.

>  		if (str[strlen(sleepstr)] == ',')
>  			str += strlen(sleepstr) + 1;
>  		if (get_option(&str, &par))
> @@ -99,7 +104,10 @@ __setup("profile=", profile_setup);
>  
>  void __init profile_init(void)
>  {
> -	if (!prof_on) 
> +	if (!_immediate_read(&sleep_profiling) &&
> +		!_immediate_read(&sched_profiling) &&
> +		!_immediate_read(&kvm_profiling) &&
> +		!_immediate_read(&cpu_profiling))

Looks like this (in multiple places) needs to use prof_on, where
prof_on is set earlier as the logical 'or' of all (4 now, could be more)
profiling flags.
Or below, sometimes you just check prof_buffer.  Is that sufficient
here also?

>  		return;
>   
>  	/* only text is profiled */
> @@ -288,7 +296,7 @@ void profile_hits(int type, void *__pc, 
>  	int i, j, cpu;
>  	struct profile_hit *hits;
>  
> -	if (prof_on != type || !prof_buffer)
> +	if (!prof_buffer)
>  		return;
>  	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
>  	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
> @@ -398,7 +406,7 @@ void profile_hits(int type, void *__pc, 
>  {
>  	unsigned long pc;
>  
> -	if (prof_on != type || !prof_buffer)
> +	if (!prof_buffer)
>  		return;
>  	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
>  	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
> @@ -555,7 +563,10 @@ static int __init create_hash_tables(voi
>  	}
>  	return 0;
>  out_cleanup:
> -	prof_on = 0;
> +	immediate_set_early(&sleep_profiling, 0);
> +	immediate_set_early(&sched_profiling, 0);
> +	immediate_set_early(&kvm_profiling, 0);
> +	immediate_set_early(&cpu_profiling, 0);
>  	smp_mb();
>  	on_each_cpu(profile_nop, NULL, 0, 1);
>  	for_each_online_cpu(cpu) {
> @@ -582,7 +593,10 @@ static int __init create_proc_profile(vo
>  {
>  	struct proc_dir_entry *entry;
>  
> -	if (!prof_on)
> +	if (!_immediate_read(&sleep_profiling) &&
> +		!_immediate_read(&sched_profiling) &&
> +		!_immediate_read(&kvm_profiling) &&
> +		!_immediate_read(&cpu_profiling))
>  		return 0;
>  	if (create_hash_tables())
>  		return -1;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
