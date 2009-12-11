Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZLKLAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZLKLAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZLKLAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:00:14 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42880 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZLKLAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=VUACsevHhtPPOhmiPB7X0DLK6g7ySjnnvaM3WtmGJXKJu8C/IBXIUXwS+4SlCcaOve
         MkbwQZEbqbcEbhIoDKoWEXca3eMOgI9Z8eKtubKKX656tz0o5tIS6INlw/jqYPfVCgtg
         fEMYraxVPc+QVFOPwD80iw3s1meKjNNVPvW1g=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1258561957.3918.661.camel@laptop>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
Date: Fri, 11 Dec 2009 12:00:18 +0100
Message-ID: <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>,
       eranian@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 5:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> In general I'd very much like to see some of this generalized because I
> think Sparc64 has very similar 'simple' constraints, I'll have to defer
> to Paul on how much of this could possibly be re-used for powerpc.
>
Let's wait until we have all X86 constraint scheduling code. There is
way more needed. I have a first cut on the AMD64 constraints but
there is an issue in the generic/arch specific API that needs to be
flushed out first (see below).

> On Mon, 2009-10-19 at 17:03 +0200, Stephane Eranian wrote:
>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>> index 8d9f854..7c737af 100644
>> --- a/arch/x86/include/asm/perf_event.h
>> +++ b/arch/x86/include/asm/perf_event.h
>> @@ -26,7 +26,9 @@
>>  /*
>>   * Includes eventsel and unit mask as well:
>>   */
>> -#define ARCH_PERFMON_EVENT_MASK                                  0xffff
>> +#define ARCH_PERFMON_EVENTSEL_EVENT_MASK                 0x00ff
>> +#define ARCH_PERFMON_EVENTSEL_UNIT_MASK                          0xff00
>> +#define ARCH_PERFMON_EVENT_MASK                                  (ARCH_PERFMON_EVENTSEL_UNIT_MASK|ARCH_PERFMON_EVENTSEL_EVENT_MASK)
>
> There's various forms of the above throughout the code, it would be nice
> not to add more..
>
I will simplify this.
>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 2e20bca..0f96c51 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>
>> @@ -68,6 +69,15 @@ struct debug_store {
>>       u64     pebs_event_reset[MAX_PEBS_EVENTS];
>>  };
>>
>> +#define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
>
> Do we need this, is it realistic to expect X86_PMC_IDX_MAX to be
> anything else than 64?
>
The issue had to do with i386 mode where long are 32 bits  < 64. And in
particular with the initializer .idxmsk[0] = V. In the future we may exceed
32 registers. That means the initializer would have to change. But I guess
we have quite some ways before this case is reached. So I will revert all
of this to unsigned long.



>> -#define EVENT_CONSTRAINT(c, m) { .code = (c), .idxmsk[0] = (m) }
>> -#define EVENT_CONSTRAINT_END  { .code = 0, .idxmsk[0] = 0 }
>> +#define EVENT_CONSTRAINT(c, n, w, m) { \
>> +     .code = (c),    \
>> +     .mask = (m),    \
>> +     .weight = (w),  \
>> +     .idxmsk[0] = (n) }
>
> If not, we can do away with the weight argument here and use hweight64()
> which should reduce to a compile time constant.
>
I have dropped weight and I use bitmap_weight() to recompute, with all
the inlining
it should come out to be a simple popcnt instruction.


>> @@ -124,7 +137,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
>>         .enabled = 1,
>>  };
>>
>> -static const struct event_constraint *event_constraints;
>> +static struct event_constraint *event_constraints;
>
> I'm thinking this ought to live in x86_pmu, or possible, if we can
> generalize this enough, in pmu.

True.

> Inconsistent style with below:
>
>> +static struct event_constraint intel_nehalem_event_constraints[] = {
>> +     EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* INSTRUCTIONS_RETIRED */
>
> Would be nice to get rid of that EVENT_MASK part, maybe write
> EVENT_CONSTRAINT like:
>
>  .mask = ARCH_PERFMON_EVENTSEL_EVENT_MASK | ((n)>>32 ? ARCH_PERFMON_FIXED_MASK : 0),
>
> Which ought to work for Intel based things, AMD will need a different
> base event mask.
>
Will try to clean this up. AMD does not need a mask, it is a
completely different kind of constraints.

>> @@ -1120,9 +1136,15 @@ static void amd_pmu_disable_all(void)
>>
>>  void hw_perf_disable(void)
>>  {
>> +     struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>> +
>>       if (!x86_pmu_initialized())
>>               return;
>> -     return x86_pmu.disable_all();
>> +
>> +     if (cpuc->enabled)
>> +             cpuc->n_events = 0;
>> +
>> +     x86_pmu.disable_all();
>>  }
>
> Right, so I cannot directly see the above being correct. You fully erase
> the PMU state when we disable it, but things like single counter
> add/remove doesn't reprogram the full PMU afaict.
>
Here is the key point. There is no clear API that says 'this is the final stop
for this event group, i.e., next start will be with a different
group'. In other words,
there is no signal that the 'resource' can be freed. This is a
showstopper for the
AMD constraints. The generic code needs to signal that this is the
final stop for
the event group, so the machine specific layer can release the registers. The
hw_perf_disable() is used in many places and does not indicate the same thing
as what I just described.

>> +static int collect_events(struct cpu_hw_events *cpuhw, struct perf_event *leader)
>> +{
>> +     struct perf_event *event;
>> +     int n, max_count;
>> +
>> +     max_count = x86_pmu.num_events + x86_pmu.num_events_fixed;
>> +
>> +     /* current number of events already accepted */
>> +     n = cpuhw->n_events;
>> +
>> +     if (!is_software_event(leader)) {
>
> With things like the hw-breakpoint stuff also growing a pmu !
> is_software() isn't strong enough, something like:
>
> static inline int is_x86_event(struct perf_event *event)
> {
>        return event->pmu == &pmu;
> }
>
Agreed, I am using something like this now.

>> +int hw_perf_group_sched_in(struct perf_event *leader,
>> +            struct perf_cpu_context *cpuctx,
>> +            struct perf_event_context *ctx, int cpu)
>> +{
>> +     struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
>> +     int n, ret;
>> +
>> +     n = collect_events(cpuhw, leader);
>> +     if (n < 0)
>> +             return n;
>> +
>> +     ret = schedule_events(cpuhw, n, true);
>> +     if (ret)
>> +             return ret;
>> +
>> +     /* 0 means successful and enable each event in caller */
>> +     return 0;
>> +}
>
> This is where powerpc does n_added += n, and it delays the
> schedule_events() bit to hw_perf_enable() conditional on n_added > 0.
> When you remove events it simply keeps the current layout and disables
> the one.
>
Will look into this.

>> @@ -2123,8 +2245,8 @@ static int intel_pmu_init(void)
>>               memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
>>                      sizeof(hw_cache_event_ids));
>>
>> -             pr_cont("Core2 events, ");
>>               event_constraints = intel_core_event_constraints;
>> +             pr_cont("Core2 events, ");
>>               break;
>>       default:
>>       case 26:
>
> Not that I object to the above change, but it seems out of place in this
> patch.
>
Will remove that.
