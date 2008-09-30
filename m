Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYI3WvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYI3WvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYI3Wuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:50:52 -0400
Received: from ozlabs.org ([203.10.76.45]:39140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYI3Wuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:50:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 01/31] cpumask: Documentation
Date: Wed, 1 Oct 2008 08:49:46 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <20080929180250.287081000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080929180250.287081000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010849.46874.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008 04:02:51 Mike Travis wrote:
> +The Changes
> +
> +Provide new cpumask interface API.  The relevant change is basically
> +cpumask_t becomes an opaque object.  This should result in the minimum
> +amount of modifications while still allowing the inline cpumask functions,
> +and the ability to declare static cpumask objects.
> +
> +
> +    /* raw declaration */
> +    struct __cpumask_data_s { DECLARE_BITMAP(bits, NR_CPUS); };
> +
> +    /* cpumask_map_t used for declaring static cpumask maps */
> +    typedef struct __cpumask_data_s cpumask_map_t[1];
> +
> +    /* cpumask_t used for function args and return pointers */
> +    typedef struct __cpumask_data_s *cpumask_t;
> +    typedef const struct __cpumask_data_s *const_cpumask_t;
> +
> +    /* cpumask_var_t used for local variable, definition follows */
> +    typedef struct __cpumask_data_s	cpumask_var_t[1]; /* SMALL NR_CPUS */
> +    typedef struct __cpumask_data_s	*cpumask_var_t;	  /* LARGE NR_CPUS */
> +
> +    /* replaces cpumask_t dst = (cpumask_t)src */
> +    void cpus_copy(cpumask_t dst, const cpumask_t src);

Hi Mike,

    I have several problems with this patch series.  First, it's a flag day 
change, which means it isn't bisectable and can't go through linux-next.  
Secondly, we still can't hide the definition of the cpumask struct as long as 
they're passed as cpumask_t, so it's going to be hard to find assignments 
(illegal once we allocate nr_cpu_ids bits rather than NR_CPUS), and on-stack 
users.

    Finally, we end up with code which is slightly more opaque than the 
current code, with two new typedefs.  And that's an ongoing problem.

    I took a slightly divergent line with my patch series, and introduced a 
parallel cpumask system which always passes and returns masks by pointer:

	cpumask_t -> struct cpumask
	on-stack cpumask_t -> cpumask_var_t (same as your patch)
	cpus_and(dst, src1, src2) etc -> cpumask_and(&dst, &src1, &src2)
	cpumask_t cpumask_of_cpu(cpu) -> const struct cpumask *cpumask_of(cpu)
	cpumask_t cpu_online_map etc -> const struct cpumask *cpu_online_mask etc.

The old ops are expressed in terms of the new ops, and can be phased out over 
time.

In addition, I added some new twists:

	static cpumasks and cpumasks in structures
		-> DECLARE_BITMAP(foo, NR_CPUS) and to_cpumask()

This means we can eventually obscure the actual definition of struct cpumask, 
to catch abuse.

	cpus_and(tmp, mask, online_mask); for_each_cpu(i, tmp)
		-> for_each_cpu_both(i, mask, online_mask)

This helper saves numerous on-stack temporaries.

	NR_CPUS -> CONFIG_NR_CPUS

The config option is now valid for UP as well.  This cleanup allows us to 
audit users of NR_CPUS (which might be used incorrectly now cpumask_ 
iterators only go to nr_cpu_ids).

The patches are fairly uninteresting, but here is the summary:

x86: remove noop cpus_and() with CPU_MASK_ALL.
x86: clean up speedctep-centrino and reduce cpumask_t usage
cpumask: remove min from first_cpu/next_cpu
cpumask: introduce struct cpumask.
cpumask: change cpumask_scnprintf, cpumask_parse_user, cpulist_parse, and
	 cpulist_scnprintf to take pointers.
cpumask: add cpumask_copy()
cpumask: introduce cpumask_var_t for local cpumask vars
cpumask: make CONFIG_NR_CPUS always valid.
cpumask: use setup_nr_cpu_ids() instead of direct assignment.
cpumask: make nr_cpu_ids valid in all configurations.
cpumask: prepare for iterators to only go to nr_cpu_ids.
cpumask: make nr_cpu_ids the actual limit on bitmap size
cpumask: replace for_each_cpu_mask_nr with for_each_cpu_mask everywhere
cpumask: use cpumask_bits() everywhere.
cpumask: Use &cpu_mask_all instead of CPU_MASK_ALL_PTR.
cpumask: cpumask_of(): cpumask_of_cpu() which returns a pointer.
cpumask: for_each_cpu(): for_each_cpu_mask which takes a pointer
cpumask: cpumask_first/cpumask_next
cpumask: for_each_cpu_both() / cpumask_first_both() / cpumask_next_both()
cpumask: deprecate any_online_cpu() in favour of cpumask_any/cpumask_any_both
cpumask: Replace CPUMASK_ALLOC etc with cpumask_var_t.
cpumask: get rid of boutique sched.c allocations, use cpumask_var_t.
cpumask: reorder header to minimize separate #ifdefs
cpumask: accessors to manipulate possible/present/online/active maps
cpumask: Use accessors code.
cpumask: switch over to cpu_online/possible/active/present_mask
cpumask: to_cpumask()
cpumask: cpu_all_mask: pointer version of cpu_mask_all.
cpumask: remove any_online_cpu() users.
cpumask: smp_call_function_many()
cpumask: Use smp_call_function_many()
cpumask: make irq_set_affinity() take a const struct cpumask *
x86: make TARGET_CPUS/target_cpus take a const struct cpumask *

I'll commit these to my quilt series today.

Thanks,
Rusty.
