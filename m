Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZKRQcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZKRQcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbZKRQcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:32:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbZKRQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:32:50 -0500
Subject: Re: [PATCH]  perf_events: improve Intel event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1255964630-5878-1-git-send-email-eranian@gmail.com>
References: <>  <1255964630-5878-1-git-send-email-eranian@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:32:37 +0100
Message-ID: <1258561957.3918.661.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry on the delay.

In general I'd very much like to see some of this generalized because I
think Sparc64 has very similar 'simple' constraints, I'll have to defer
to Paul on how much of this could possibly be re-used for powerpc.

On Mon, 2009-10-19 at 17:03 +0200, Stephane Eranian wrote:
>  arch/x86/include/asm/perf_event.h |    6 +-
>  arch/x86/kernel/cpu/perf_event.c  |  497 +++++++++++++++++++++++--------------
>  2 files changed, 318 insertions(+), 185 deletions(-)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8d9f854..7c737af 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -26,7 +26,9 @@
>  /*
>   * Includes eventsel and unit mask as well:
>   */
> -#define ARCH_PERFMON_EVENT_MASK				    0xffff
> +#define ARCH_PERFMON_EVENTSEL_EVENT_MASK		    0x00ff
> +#define ARCH_PERFMON_EVENTSEL_UNIT_MASK			    0xff00
> +#define ARCH_PERFMON_EVENT_MASK				    (ARCH_PERFMON_EVENTSEL_UNIT_MASK|ARCH_PERFMON_EVENTSEL_EVENT_MASK)

There's various forms of the above throughout the code, it would be nice
not to add more..

And in general this patch has way too many >80 lines and other style
nits, but those can be fixed up easily enough I guess.

> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 2e20bca..0f96c51 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c

> @@ -68,6 +69,15 @@ struct debug_store {
>  	u64	pebs_event_reset[MAX_PEBS_EVENTS];
>  };
>  
> +#define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))

Do we need this, is it realistic to expect X86_PMC_IDX_MAX to be
anything else than 64?

> -#define EVENT_CONSTRAINT(c, m) { .code = (c), .idxmsk[0] = (m) }
> -#define EVENT_CONSTRAINT_END  { .code = 0, .idxmsk[0] = 0 }
> +#define EVENT_CONSTRAINT(c, n, w, m) { \
> +	.code = (c),	\
> +	.mask = (m), 	\
> +	.weight = (w),	\
> +	.idxmsk[0] = (n) }

If not, we can do away with the weight argument here and use hweight64()
which should reduce to a compile time constant.

> @@ -124,7 +137,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
>         .enabled = 1,
>  };
>  
> -static const struct event_constraint *event_constraints;
> +static struct event_constraint *event_constraints;

I'm thinking this ought to live in x86_pmu, or possible, if we can
generalize this enough, in pmu.

> +static struct event_constraint intel_core_event_constraints[] =
> +{

Inconsistent style with below:

> +static struct event_constraint intel_nehalem_event_constraints[] = {
> +	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* INSTRUCTIONS_RETIRED */
> +	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* UNHALTED_CORE_CYCLES */
> +	EVENT_CONSTRAINT(0x40, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_LD */
> +	EVENT_CONSTRAINT(0x41, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_ST */
> +	EVENT_CONSTRAINT(0x42, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_LOCK */
> +	EVENT_CONSTRAINT(0x43, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_ALL_REF */
> +	EVENT_CONSTRAINT(0x4e, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_PREFETCH */
> +	EVENT_CONSTRAINT(0x4c, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* LOAD_HIT_PRE */
> +	EVENT_CONSTRAINT(0x51, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D */
> +	EVENT_CONSTRAINT(0x52, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
> +	EVENT_CONSTRAINT(0x53, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_LOCK_FB_HIT */
> +	EVENT_CONSTRAINT(0xc5, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* CACHE_LOCK_CYCLES */
>  	EVENT_CONSTRAINT_END
>  };

Would be nice to get rid of that EVENT_MASK part, maybe write
EVENT_CONSTRAINT like:

  .mask = ARCH_PERFMON_EVENTSEL_EVENT_MASK | ((n)>>32 ? ARCH_PERFMON_FIXED_MASK : 0),

Which ought to work for Intel based things, AMD will need a different
base event mask.
 
> @@ -1120,9 +1136,15 @@ static void amd_pmu_disable_all(void)
>  
>  void hw_perf_disable(void)
>  {
> +	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +
>  	if (!x86_pmu_initialized())
>  		return;
> -	return x86_pmu.disable_all();
> +
> +	if (cpuc->enabled)
> +		cpuc->n_events = 0;
> +
> +	x86_pmu.disable_all();
>  }

Right, so I cannot directly see the above being correct. You fully erase
the PMU state when we disable it, but things like single counter
add/remove doesn't reprogram the full PMU afaict.

The powerpc code has n_added, which indicates a delta algorithm is used
there.

> +static struct event_constraint *intel_get_event_constraints(struct perf_event *event)
> +{
> +	struct event_constraint *c;
> +
> +	c = intel_special_constraints(event);
> +	if (c)
> +		return c;
> +
> +	if (event_constraints)
> +		for_each_event_constraint(c, event_constraints) {
> +			if ((event->hw.config & c->mask) == c->code)
> +				return c;
> +		}

This wants extra { }, since its a multi-line stmt.

> +	return NULL;
> +}
> +
> +static struct event_constraint *amd_get_event_constraints(struct perf_event *event)
> +{
> +	return NULL;
> +}

I guess we'll need to fill that out a bit more, but that can be another
patch.

> +static int schedule_events(struct cpu_hw_events *cpuhw, int n, bool assign)
> +{
> +	int i, j , w, num, lim;
> +	int weight, wmax;
> +	struct event_constraint *c;
> +	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +	int assignments[X86_PMC_IDX_MAX];
> +	struct hw_perf_event *hwc;
> +
> +	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
> +
> +	/*
> +	 * weight = number of possible counters
> +	 *
> +	 * 1    = most constrained, only works on one counter
> +	 * wmax = least constrained, works on 1 fixed counter
> +	 *        or any generic counter
> +	 *
> +	 * assign events to counters starting with most
> +	 * constrained events.
> +	 */
> +	wmax = 1 + x86_pmu.num_events;
> +	num = n;
> +	for(w=1; num && w <= wmax; w++) {
> +
> +		/* for each event */
> +		for(i=0; i < n; i++) {
> +			c = cpuhw->constraints[i];
> +			hwc = &cpuhw->event_list[i]->hw;
> +
> +			weight = c ? c->weight : x86_pmu.num_events;
> +			if (weight != w)
> +				continue;
> +
> +			/*
> +			 * try to reuse previous assignment
> +			 *
> +			 * This is possible despite the fact that
> +			 * events or events order may have changed.
> +			 *
> +			 * What matters is the level of constraints
> +			 * of an event and this is constant for now.
> +			 *
> +			 * This is possible also because we always
> +			 * scan from most to least constrained. Thus,
> +			 * if a counter can be reused, it means no,
> +			 * more constrained events, needed it. And
> +			 * next events will either compete for it
> +			 * (which cannot be solved anyway) or they
> +			 * have fewer constraints, and they can use
> +			 * another counter.
> +			 */
> +			j = hwc->idx;
> +			if (j != -1 && !test_bit(j, used_mask))
> +				goto skip;
> +
> +			if (c) {
> +				lim = X86_PMC_IDX_MAX;
> +				for_each_bit(j, (unsigned long *)c->idxmsk, lim)
> +					if (!test_bit(j, used_mask))
> +						break;
> +
> +			} else  {
> +				lim = x86_pmu.num_events;
> +				/*
> +				 * fixed counter events have necessarily a
> +				 * constraint thus we come here only for
> +				 * generic counters and thus we limit the
> +				 * scan to those
> +				 */
> +				j = find_first_zero_bit(used_mask, lim);
> +			}
> +			if (j == lim)
> +				return -EAGAIN;
> +skip:
> +			set_bit(j, used_mask);
> +			assignments[i] = j;
> +			num--;
> +		}
> +	}
> +	if (num)
> +		return -ENOSPC;
> +
> +	/* just simulate scheduling */
> +	if (!assign)
> +		return 0;
> +
> +	/*
> +	 * commit assignments
> +	 */
> +	for(i=0; i < n; i++) {
> +		hwc = &cpuhw->event_list[i]->hw;
> +
> +		hwc->idx = assignments[i];
> +
> +		set_bit(hwc->idx, cpuhw->used_mask);
> +
> +		if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
> +			hwc->config_base = 0;
> +			hwc->event_base	= 0;
> +		} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
> +			hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
> +			/*
> +			 * We set it so that event_base + idx in wrmsr/rdmsr maps to
> +			 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
> +			 */
> +			hwc->event_base =
> +				MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
> +		} else {
> +			hwc->config_base = x86_pmu.eventsel;
> +			hwc->event_base  = x86_pmu.perfctr;
> +		}
> +	}
> +	cpuhw->n_events = n;
> +	return 0;
> +}

Straight forward O(n^2) algorithm looking for the best match, seems good
from a single read -- will go over it again on another day to find more
details.

> +static int collect_events(struct cpu_hw_events *cpuhw, struct perf_event *leader)
> +{
> +	struct perf_event *event;
> +	int n, max_count;
> +
> +	max_count = x86_pmu.num_events + x86_pmu.num_events_fixed;
> +
> +	/* current number of events already accepted */
> +	n = cpuhw->n_events;
> +
> +	if (!is_software_event(leader)) {

With things like the hw-breakpoint stuff also growing a pmu !
is_software() isn't strong enough, something like:

static inline int is_x86_event(struct perf_event *event)
{
	return event->pmu == &pmu;
}

Should work though.

> +		if (n >= max_count)
> +			return -ENOSPC;
> +		cpuhw->constraints[n] = x86_pmu.get_event_constraints(leader);
> +		cpuhw->event_list[n] = leader;
> +		n++;
> +	}
> +
> +	list_for_each_entry(event, &leader->sibling_list, group_entry) {
> +		if (is_software_event(event) ||
> +		    event->state == PERF_EVENT_STATE_OFF)
> +			continue;
> +
> +		if (n >= max_count)
> +			return -ENOSPC;
> +
> +		cpuhw->constraints[n] = x86_pmu.get_event_constraints(event);
> +		cpuhw->event_list[n] = event;
> +		n++;
> +	}
> +	return n;
> +}
> +
> +/*
> + * Called to enable a whole group of events.
> + * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
> + * Assumes the caller has disabled interrupts and has
> + * frozen the PMU with hw_perf_save_disable.
> + */
> +int hw_perf_group_sched_in(struct perf_event *leader,
> +	       struct perf_cpu_context *cpuctx,
> +	       struct perf_event_context *ctx, int cpu)
> +{
> +	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
> +	int n, ret;
> +
> +	n = collect_events(cpuhw, leader);
> +	if (n < 0)
> +		return n;
> +
> +	ret = schedule_events(cpuhw, n, true);
> +	if (ret)
> +		return ret;
> +
> +	/* 0 means successful and enable each event in caller */
> +	return 0;
> +}

This is where powerpc does n_added += n, and it delays the
schedule_events() bit to hw_perf_enable() conditional on n_added > 0.
When you remove events it simply keeps the current layout and disables
the one.

> @@ -2123,8 +2245,8 @@ static int intel_pmu_init(void)
>  		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
>  		       sizeof(hw_cache_event_ids));
>  
> -		pr_cont("Core2 events, ");
>  		event_constraints = intel_core_event_constraints;
> +		pr_cont("Core2 events, ");
>  		break;
>  	default:
>  	case 26:

Not that I object to the above change, but it seems out of place in this
patch.

> +/*
> + * validate a single event group
> + *
> + * validation include:
> + * 	- check events are compatible which each other
> + * 	- events do not compete for the same counter
> + * 	- number of events <= number of counters
> + *
> + * validation ensures the group can be loaded onto the
> + * PMU if it were the only group available.
> + */
>  static int validate_group(struct perf_event *event)
>  {
> -	struct perf_event *sibling, *leader = event->group_leader;
> +	struct perf_event *leader = event->group_leader;
>  	struct cpu_hw_events fake_pmu;
> +	int n, ret;
>  
>  	memset(&fake_pmu, 0, sizeof(fake_pmu));
>  
> -	if (!validate_event(&fake_pmu, leader))
> +	/*
> +	 * the event is not yet connected with its
> +	 * siblings thererfore we must first collect
> +	 * existing siblings, then add the new event
> +	 * before we can simulate the scheduling
> +	 */
> +	n = collect_events(&fake_pmu, leader);
> +	if (n < 0)
>  		return -ENOSPC;
>  
> -	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
> -		if (!validate_event(&fake_pmu, sibling))
> -			return -ENOSPC;
> -	}
> +	fake_pmu.n_events = n;
>  
> -	if (!validate_event(&fake_pmu, event))
> +	n = collect_events(&fake_pmu, event);
> +	if (n < 0)
>  		return -ENOSPC;
>  
> -	return 0;
> +	ret = schedule_events(&fake_pmu, n, false);
> +	return ret ? -ENOSPC : 0;
>  }

This seems good.

