Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbZGIBuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbZGIBuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZGIBtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:49:51 -0400
Received: from mga10.intel.com ([192.55.52.92]:1840 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754902AbZGIBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,371,1243839600"; 
   d="scan'208";a="706211846"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: [PATCH][KVM][retry 4] Add support for Pause Filtering to AMD SVM
Date: Thu, 9 Jul 2009 09:50:04 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; x86_64; ; )
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, peterz@infradead.org,
       "Ingo Molnar" <mingo@elte.hu>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Edwin Zhai <edwin.zhai@intel.com>
References: <200905050909.58583.mark.langsdorf@amd.com> <200907081319.57307.sheng@linux.intel.com> <6453C3CB8E2B3646B0D020C112613273036209F0@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273036209F0@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907090950.06204.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009 22:59:55 Langsdorf, Mark wrote:
> The last variant of the scheduler that I tried
> showed worse performance for both the baseline
> case (no pause filter enabled) and the test
> case (pause filter enabled) versus not changing
> the scheduler.
>
> Some other work came up and I haven't have a
> chance to experiment with this for a while.

Um, I am afraid we have the different result... With your scheduler patch, we 
got 1% more performance improvement in the quick test. Of course more tests 
are needed to find a better value of delay.

Do you have time to work on it recently? Maybe we can help to push the 
scheduler part. (oh, as you know, we need to push our PLE...)

-- 
regards
Yang, Sheng

> -Mark Langsdorf
> Operating System Research Center
> AMD
>
> > -----Original Message-----
> > From: Sheng Yang [mailto:sheng@linux.intel.com]
> > Sent: Wednesday, July 08, 2009 12:20 AM
> > To: Langsdorf, Mark
> > Cc: Roedel, Joerg; peterz@infradead.org; Ingo Molnar;
> > avi@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH][KVM][retry 4] Add support for Pause
> > Filtering to AMD SVM
> >
> > On Thursday 21 May 2009 06:25:17 Mark Langsdorf wrote:
> > > This feature creates a new field in the VMCB called Pause
> > > Filter Count.  If Pause Filter Count is greater than 0 and
> > > intercepting PAUSEs is enabled, the processor will increment
> > > an internal counter when a PAUSE instruction occurs instead
> > > of intercepting.  When the internal counter reaches the
> > > Pause Filter Count value, a PAUSE intercept will occur.
> >
> > (dig it from archives...)
> >
> > Any update for the patch(I mean the scheduler part)? I think
> > people agreed on
> > the approach?
> >
> > --
> > regards
> > Yang, Sheng
> >
> > > This feature can be used to detect contended spinlocks,
> > > especially when the lock holding VCPU is not scheduled.
> > > Rescheduling another VCPU prevents the VCPU seeking the
> > > lock from wasting its quantum by spinning idly.  Perform
> > > the reschedule by increasing the the credited time on
> > > the VCPU.
> > >
> > > Experimental results show that most spinlocks are held
> > > for less than 1000 PAUSE cycles or more than a few
> > > thousand.  Default the Pause Filter Counter to 3000 to
> > > detect the contended spinlocks.
> > >
> > > Processor support for this feature is indicated by a CPUID
> > > bit.
> > >
> > > On a 24 core system running 4 guests each with 16 VCPUs,
> > > this patch improved overall performance of each guest's
> > > 32 job kernbench by approximately 1%.  Further performance
> > > improvement may be possible with a more sophisticated
> > > yield algorithm.
> > >
> > > -Mark Langsdorf
> > > Operating System Research Center
> > > AMD
> > >
> > > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > > ---
> > >  arch/x86/include/asm/svm.h |    3 ++-
> > >  arch/x86/kvm/svm.c         |   13 +++++++++++++
> > >  include/linux/sched.h      |    7 +++++++
> > >  kernel/sched.c             |   18 ++++++++++++++++++
> > >  4 files changed, 40 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > index 85574b7..1fecb7e 100644
> > > --- a/arch/x86/include/asm/svm.h
> > > +++ b/arch/x86/include/asm/svm.h
> > > @@ -57,7 +57,8 @@ struct __attribute__ ((__packed__))
> >
> > vmcb_control_area {
> >
> > >  	u16 intercept_dr_write;
> > >  	u32 intercept_exceptions;
> > >  	u64 intercept;
> > > -	u8 reserved_1[44];
> > > +	u8 reserved_1[42];
> > > +	u16 pause_filter_count;
> > >  	u64 iopm_base_pa;
> > >  	u64 msrpm_base_pa;
> > >  	u64 tsc_offset;
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index ef43a18..dad6c4b 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -45,6 +45,7 @@ MODULE_LICENSE("GPL");
> > >  #define SVM_FEATURE_NPT  (1 << 0)
> > >  #define SVM_FEATURE_LBRV (1 << 1)
> > >  #define SVM_FEATURE_SVML (1 << 2)
> > > +#define SVM_FEATURE_PAUSE_FILTER (1 << 10)
> > >
> > >  #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
> > >
> > > @@ -575,6 +576,11 @@ static void init_vmcb(struct vcpu_svm *svm)
> > >
> > >  	svm->nested_vmcb = 0;
> > >  	svm->vcpu.arch.hflags = HF_GIF_MASK;
> > > +
> > > +	if (svm_has(SVM_FEATURE_PAUSE_FILTER)) {
> > > +		control->pause_filter_count = 3000;
> > > +		control->intercept |= (1ULL << INTERCEPT_PAUSE);
> > > +	}
> > >  }
> > >
> > >  static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
> > > @@ -2087,6 +2093,12 @@ static int
> >
> > interrupt_window_interception(struct
> >
> > > vcpu_svm *svm, return 1;
> > >  }
> > >
> > > +static int pause_interception(struct vcpu_svm *svm, struct kvm_run
> > > *kvm_run) +{
> > > +	sched_delay_yield(1000000);
> > > +	return 1;
> > > +}
> > > +
> > >  static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
> > >  				      struct kvm_run *kvm_run) = {
> > >  	[SVM_EXIT_READ_CR0]           		=
> >
> > emulate_on_interception,
> >
> > > @@ -2123,6 +2135,7 @@ static int
> >
> > (*svm_exit_handlers[])(struct vcpu_svm
> >
> > > *svm, [SVM_EXIT_CPUID]			= cpuid_interception,
> > >  	[SVM_EXIT_IRET]                         = iret_interception,
> > >  	[SVM_EXIT_INVD]                         =
> >
> > emulate_on_interception,
> >
> > > +	[SVM_EXIT_PAUSE]			= pause_interception,
> > >  	[SVM_EXIT_HLT]				= halt_interception,
> > >  	[SVM_EXIT_INVLPG]			= invlpg_interception,
> > >  	[SVM_EXIT_INVLPGA]			=
> >
> > invalid_op_interception,
> >
> > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > index b4c38bc..9cde585 100644
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -2283,6 +2283,9 @@ static inline unsigned int
> >
> > task_cpu(const struct
> >
> > > task_struct *p) return task_thread_info(p)->cpu;
> > >  }
> > >
> > > +extern void sched_delay_yield(unsigned long ns);
> > > +
> > > +
> > >  extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
> > >
> > >  #else
> > > @@ -2292,6 +2295,10 @@ static inline unsigned int
> >
> > task_cpu(const struct
> >
> > > task_struct *p) return 0;
> > >  }
> > >
> > > +void sched_delay_yield(struct task_struct *p, unsigned int delay)
> > > +{
> > > +}
> > > +
> > >  static inline void set_task_cpu(struct task_struct *p,
> >
> > unsigned int cpu)
> >
> > >  {
> > >  }
> > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > index b902e58..3aed2f6 100644
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -1947,6 +1947,24 @@ task_hot(struct task_struct *p, u64
> >
> > now, struct
> >
> > > sched_domain *sd) return delta < (s64)sysctl_sched_migration_cost;
> > >  }
> > >
> > > +/*
> > > + * Interface for yielding a thread by delaying it for a known
> > > + * interval.  Use at your own risk and not with real-time.
> > > + *
> > > + * Like yield, except for SCHED_OTHER/BATCH, where it will
> > > + * give us @ns time for the 'good' cause.
> > > + */
> > > +void sched_delay_yield(unsigned long ns)
> > > +{
> > > +	struct task_struct *curr = current;
> > > +	if (curr->sched_class == &fair_sched_class) {
> > > +		struct sched_entity *se = &curr->se;
> > > +		__update_curr(cfs_rq_of(se), se, ns);
> > > +		schedule();
> > > +	} else
> > > +		yield();
> > > +}
> > > +EXPORT_SYMBOL_GPL(sched_delay_yield);
> > >
> > >  void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
> > >  {


