Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0CBKT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:19:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47369 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab0CBKT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:19:28 -0500
Date: Tue, 2 Mar 2010 10:36:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       KVM General <kvm@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ming.m.lin@intel.com
Subject: Re: KVM PMU virtualization
Message-ID: <20100302093629.GB8591@elte.hu>
References: <4B86917C.4070102@redhat.com>
 <20100225173423.GB4246@8bytes.org>
 <1267152917.1726.82.camel@localhost>
 <20100226085105.GC4246@8bytes.org>
 <20100226091732.GI15885@elte.hu>
 <1267513746.1726.104.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267513746.1726.104.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> On Fri, 2010-02-26 at 10:17 +0100, Ingo Molnar wrote:

> > My suggestion, as always, would be to start very simple and very minimal:
> > 
> > Enable 'perf kvm top' to show guest overhead. Use the exact same kernel 
> > image both as a host and as guest (for testing), to not have to deal with 
> > the symbol space transport problem initially. Enable 'perf kvm record' to 
> > only record guest events by default. Etc.
> > 
> > This alone will be a quite useful result already - and gives a basis for 
> > further work. No need to spend months to do the big grand design straight 
> > away, all of this can be done gradually and in the order of usefulness - 
> > and you'll always have something that actually works (and helps your other 
> > KVM projects) along the way.
>
> It took me for a couple of hours to read the emails on the topic. Based on 
> above idea, I worked out a prototype which is ugly, but does work with 
> top/record when both guest side and host side use the same kernel image, 
> while compiling most needed modules into kernel directly..
> 
> The commands are:
> perf kvm top
> perf kvm record
> perf kvm report
> 
> They just collect guest kernel hot functions.

Fantastic, and there's some really interesting KVM guest/host comparison 
profiles you've done with this prototype!

> With my patch, I collected dbench data on Nehalem machine (2*4*2 logical 
> cpu).
>
> 1) Vanilla host kernel (6G memory):
> ------------------------------------------------------------------------------------------------------------------------
>    PerfTop:   15491 irqs/sec  kernel:93.6% [1000Hz cycles],  (all, 16 CPUs)
> ------------------------------------------------------------------------------------------------------------------------
> 
>              samples  pcnt function                        DSO
>              _______ _____ _______________________________ ________________________________________
> 
>             99376.00 40.5% ext3_test_allocatable           /lib/modules/2.6.33-kvmymz/build/vmlinux
>             41239.00 16.8% bitmap_search_next_usable_block /lib/modules/2.6.33-kvmymz/build/vmlinux
>              7019.00  2.9% __ticket_spin_lock              /lib/modules/2.6.33-kvmymz/build/vmlinux
>              5350.00  2.2% copy_user_generic_string        /lib/modules/2.6.33-kvmymz/build/vmlinux
>              5208.00  2.1% do_get_write_access             /lib/modules/2.6.33-kvmymz/build/vmlinux
>              4484.00  1.8% journal_dirty_metadata          /lib/modules/2.6.33-kvmymz/build/vmlinux
>              4078.00  1.7% ext3_free_blocks_sb             /lib/modules/2.6.33-kvmymz/build/vmlinux
>              3856.00  1.6% ext3_new_blocks                 /lib/modules/2.6.33-kvmymz/build/vmlinux
>              3485.00  1.4% journal_get_undo_access         /lib/modules/2.6.33-kvmymz/build/vmlinux
>              2803.00  1.1% ext3_try_to_allocate            /lib/modules/2.6.33-kvmymz/build/vmlinux
>              2241.00  0.9% __find_get_block                /lib/modules/2.6.33-kvmymz/build/vmlinux
>              1957.00  0.8% find_revoke_record              /lib/modules/2.6.33-kvmymz/build/vmlinux
> 
> 2) guest os: start one guest os with 4GB memory.
> ------------------------------------------------------------------------------------------------------------------------
>    PerfTop:     827 irqs/sec  kernel: 0.0% [1000Hz cycles],  (all, 16 CPUs)
> ------------------------------------------------------------------------------------------------------------------------
> 
>              samples  pcnt function                        DSO
>              _______ _____ _______________________________ ________________________________________
> 
>             41701.00 28.1% __ticket_spin_lock              /lib/modules/2.6.33-kvmymz/build/vmlinux
>             33843.00 22.8% ext3_test_allocatable           /lib/modules/2.6.33-kvmymz/build/vmlinux
>             16862.00 11.4% bitmap_search_next_usable_block /lib/modules/2.6.33-kvmymz/build/vmlinux
>              3278.00  2.2% native_flush_tlb_others         /lib/modules/2.6.33-kvmymz/build/vmlinux
>              3200.00  2.2% copy_user_generic_string        /lib/modules/2.6.33-kvmymz/build/vmlinux
>              3009.00  2.0% do_get_write_access             /lib/modules/2.6.33-kvmymz/build/vmlinux
>              2834.00  1.9% journal_dirty_metadata          /lib/modules/2.6.33-kvmymz/build/vmlinux
>              1965.00  1.3% journal_get_undo_access         /lib/modules/2.6.33-kvmymz/build/vmlinux
>              1907.00  1.3% ext3_new_blocks                 /lib/modules/2.6.33-kvmymz/build/vmlinux
>              1790.00  1.2% ext3_free_blocks_sb             /lib/modules/2.6.33-kvmymz/build/vmlinux
>              1741.00  1.2% find_revoke_record              /lib/modules/2.6.33-kvmymz/build/vmlinux
> 
> 
> With vanilla host kernel, perf top data is stable and spinlock doesn't take 
> too much cpu time. With guest os, __ticket_spin_lock consumes 28% cpu time, 
> and sometimes it fluctuates between 9%~28%.

Looks quite convenient to be able to profile guest and host from the same 
space, right?

Btw, another, convenient way to compare profiles is 'perf diff':

$ perf diff

# Baseline  Delta          Shared Object  Symbol
# ........ ..........  .................  ......
#
     5.45%     +4.31%  [kernel.kallsyms]  [k] _raw_spin_lock
     3.52%     +3.74%  [kernel.kallsyms]  [k] copy_user_generic_string
     3.11%     +4.08%  [kernel.kallsyms]  [k] sock_alloc_send_pskb
     4.32%     +2.62%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     3.34%     +2.31%  [kernel.kallsyms]  [k] __cache_free
     1.49%     +3.49%  [kernel.kallsyms]  [k] _raw_read_lock
     7.44%     -3.06%  [kernel.kallsyms]  [k] avc_has_perm_noaudit
     0.14%     +2.49%  [kernel.kallsyms]  [k] skb_release_head_state
     0.22%     +2.29%  [kernel.kallsyms]  [k] vfs_read
     1.67%     +0.75%  [kernel.kallsyms]  [k] file_has_perm
     0.09%     +2.31%  [kernel.kallsyms]  [k] rw_verify_area

By default it compares the last two profiles done in the current directory, if 
you have two separate data files, say perf.data.host and perf.data.guest, you 
can do:

  perf diff perf.data.host perf.data.guest

To get a host -> guest slowdown comparison.

Another suggestion: you could add --guest / --host convenience flag to 'perf 
kvm', to allow for an easy host/guest comparison workflow:

  perf kvm record --guest     # creates perf.data.guest
  perf kvm record --host      # creates perf.data.host
  perf kvm diff               # shortcut for: 'perf diff perf.data.host perf.data.guest'

> Another interesting finding is aim7. If I start aim7 on tmpfs testing in 
> guest os with 1GB memory, the login hangs and cpu is busy. With the new 
> patch, I could check what happens in guest os, where spinlock is busy and 
> kernel is shrinking memory mostly from slab.

This is exactly the kind of usage proper perf events integration would allow! 
Your 'perf kvm' looks very powerful, even in its early prototype.

Now, regarding the technical details of your patch:

> +++ linux-2.6.33_perfkvm/arch/x86/kvm/vmx.c	2010-03-02 10:21:57.588586179 +0800

> @@ -3553,8 +3554,19 @@ static void vmx_complete_interrupts(stru
>  
>  	/* We need to handle NMIs before interrupts are enabled */
>  	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
> -	    (exit_intr_info & INTR_INFO_VALID_MASK))
> +	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
> +		u64 rip = vmcs_readl(GUEST_RIP);
> +		int user_mode = vmcs_read16(GUEST_CS_SELECTOR);
> +
> +#ifdef CONFIG_X86_32
> +		user_mode = (user_mode & SEGMENT_RPL_MASK) == USER_RPL;
> +#else
> +		user_mode = !!(user_mode & 3);
> +#endif

This test could use a helper i guess, to remove the #ifdef?

> +		perf_save_virt_ip(user_mode, rip);
>  		asm("int $2");
> +		perf_reset_virt_ip();
> +	}

> --- linux-2.6.33/include/linux/perf_event.h	2010-02-25 02:52:17.000000000 +0800
> +++ linux-2.6.33_perfkvm/include/linux/perf_event.h	2010-03-02 12:26:15.050947780 +0800
> @@ -125,8 +125,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_PERIOD			= 1U << 8,
>  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
>  	PERF_SAMPLE_RAW				= 1U << 10,
> +        PERF_SAMPLE_KVM                         = 1U << 11,

yep, we can extend it like this, but maybe there's another method:

> +//#if defined(CONFIG_PERF_EVENTS && CONFIG_PERF_HAS_VIRT_IP)
> +#if defined(CONFIG_PERF_EVENTS)
> +struct virt_ip_info {
> +	int	user_mode;
> +	u64	ip;
> +};

basically what we want is a 'this is guest user mode' differentiator in the 
call frame stream data, right?

We already have such separators (it's just not used very much):

enum perf_callchain_context {
        PERF_CONTEXT_HV                 = (__u64)-32,
        PERF_CONTEXT_KERNEL             = (__u64)-128,
        PERF_CONTEXT_USER               = (__u64)-512,

        PERF_CONTEXT_GUEST              = (__u64)-2048,
        PERF_CONTEXT_GUEST_KERNEL       = (__u64)-2176,
        PERF_CONTEXT_GUEST_USER         = (__u64)-2560,

        PERF_CONTEXT_MAX                = (__u64)-4095,
};

Basically KVM's guest context could be expressed as a PERF_CONTEXT_GUEST 
separator pushed into the stream (and then recognized by 'perf kvm' - and 
generally by 'perf report' et al), followed by the virtual RIP as a regular 
IP.

That way we dont need PERF_SAMPLE_KVM. Note that the tooling doesnt know about 
such separators very well yet, so there might be some gotchas along the way. 
Please let us know if you run into any problems here.

Peter, what's your preference for this KVM profiling ABI detail?

> +DECLARE_PER_CPU(struct virt_ip_info, perf_virt_ip);
> +extern void perf_save_virt_ip(int user_mode, u64 ip);
> +extern void perf_reset_virt_ip(void);
> +extern int perf_get_virt_user_mode(void);
> +static inline u64 perf_instruction_pointer(struct perf_event *event, struct pt_regs *regs)
> +{
> +	u64 ip;
> +	if (event->attr.sample_type & PERF_SAMPLE_KVM)
> +		ip = percpu_read(perf_virt_ip.ip);
> +	else
> +		ip = instruction_pointer(regs);
> +	return ip;

And this complication we can perhaps avoid by extending the stack-trace engine 
(arch/x86/kernel/stacktrace.c) to 'know' about virtual guest RIPs 
automatically?

( Note that this would be a bit of an advantage for regular oops printing as 
  well: if a KVM thread crashes or generates a stack-dump it could 
  automatically print the guest virtual RIP as well. )

Walking into the guest context is more complex, but not impossible either - 
and that bit definitely has to be done not in an NMI context but in the KVM 
thread context.

So maybe we should not extend dump_stack_trace() after all (it cannot really 
work from NMI or from oops context), but add the KVM variant and let it 
directly inject into the perf data stream? (like your patch does it pretty 
much)

> +++ linux-2.6.33_perfkvm/tools/perf/perf.c	2010-03-02 09:57:03.164001069 +0800

> +	if (argc > 1 && !strcmp(argv[0], "kvm")) {
> +		sample_kvm = 1;
> +		argv++;
> +		argc--;
> +		cmd = argv[0];
> +	}

this is fine as a quick hack. For the real thing i suspect we want to add 
'perf kvm' as a real builtin-kvm.c command - see builtin-sched.c and 
builtin-lock.c about how to create such 'subsystem commands'. builtin-record.c 
can be extended with various host/guest recording detail switches (off by 
default), and builtin-kvm.c can use those. For example builtin-sched.c 
implements 'perf sched record' the following way:

static const char *record_args[] = {
        "record",
        "-a",
        "-R",
        "-M",
        "-f",
        "-m", "1024",
        "-c", "1",
        "-e", "sched:sched_switch:r",
        "-e", "sched:sched_stat_wait:r",
        "-e", "sched:sched_stat_sleep:r",
        "-e", "sched:sched_stat_iowait:r",
        "-e", "sched:sched_stat_runtime:r",
        "-e", "sched:sched_process_exit:r",
        "-e", "sched:sched_process_fork:r",
        "-e", "sched:sched_wakeup:r",
        "-e", "sched:sched_migrate_task:r",
};

So it simply passes these arguments to perf record. 'perf kvm record' could do 
something similar.

Anyway, your patch already shows great progress and it's the kind of direction 
for enhanced performance analysis of KVM that i think would be very fruitful 
to KVM developers to pursue.

Thanks,

	Ingo
