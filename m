Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZIHSmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZIHSmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZIHSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZIHSmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:42:10 -0400
Date: Tue, 8 Sep 2009 15:41:59 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH v2 1/2] keep guest wallclock in sync with host clock
Message-ID: <20090908184159.GC19318@amt.cnet>
References: <1251902098-8660-1-git-send-email-glommer@redhat.com> <1251902098-8660-2-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251902098-8660-2-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 10:34:57AM -0400, Glauber Costa wrote:
> KVM clock is great to avoid drifting in guest VMs running ontop of kvm.
> However, the current mechanism will not propagate changes in wallclock value
> upwards. This effectively means that in a large pool of VMs that need accurate timing,
> all of them has to run NTP, instead of just the host doing it.
> 
> Since the host updates information in the shared memory area upon msr writes,
> this patch introduces a worker that writes to that msr, and calls do_settimeofday
> at fixed intervals, with second resolution. A interval of 0 determines that we
> are not interested in this behaviour. A later patch will make this optional at
> runtime
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>

As mentioned before, ntp already does this (and its not that heavy is
it?).

For example, if ntp running on the host, it avoids stepping the clock
backwards by slow adjustment, while the periodic frequency adjustment on
the guest bypasses that.

> ---
>  arch/x86/kernel/kvmclock.c |   70 ++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 61 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index e5efcdc..555aab0 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -27,6 +27,7 @@
>  #define KVM_SCALE 22
>  
>  static int kvmclock = 1;
> +static unsigned int kvm_wall_update_interval = 0;
>  
>  static int parse_no_kvmclock(char *arg)
>  {
> @@ -39,24 +40,75 @@ early_param("no-kvmclock", parse_no_kvmclock);
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct pvclock_vcpu_time_info, hv_clock);
>  static struct pvclock_wall_clock wall_clock;
>  
> -/*
> - * The wallclock is the time of day when we booted. Since then, some time may
> - * have elapsed since the hypervisor wrote the data. So we try to account for
> - * that with system time
> - */
> -static unsigned long kvm_get_wallclock(void)
> +static void kvm_get_wall_ts(struct timespec *ts)
>  {
> -	struct pvclock_vcpu_time_info *vcpu_time;
> -	struct timespec ts;
>  	int low, high;
> +	struct pvclock_vcpu_time_info *vcpu_time;
>  
>  	low = (int)__pa_symbol(&wall_clock);
>  	high = ((u64)__pa_symbol(&wall_clock) >> 32);
>  	native_write_msr(MSR_KVM_WALL_CLOCK, low, high);
>  
>  	vcpu_time = &get_cpu_var(hv_clock);
> -	pvclock_read_wallclock(&wall_clock, vcpu_time, &ts);
> +	pvclock_read_wallclock(&wall_clock, vcpu_time, ts);
>  	put_cpu_var(hv_clock);
> +}
> +
> +static void kvm_sync_wall_clock(struct work_struct *work);
> +static DECLARE_DELAYED_WORK(kvm_sync_wall_work, kvm_sync_wall_clock);
> +
> +static void schedule_next_update(void)
> +{
> +	struct timespec next;
> +
> +	if ((kvm_wall_update_interval == 0) ||
> +	   (!kvm_para_available()) ||
> +	   (!kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)))
> +		return;
> +
> +	next.tv_sec = kvm_wall_update_interval;
> +	next.tv_nsec = 0;
> +
> +	schedule_delayed_work(&kvm_sync_wall_work, timespec_to_jiffies(&next));
> +}
> +
> +static void kvm_sync_wall_clock(struct work_struct *work)
> +{
> +	struct timespec now, after;
> +	u64 nsec_delta;
> +
> +	do {
> +		kvm_get_wall_ts(&now);
> +		do_settimeofday(&now);
> +		kvm_get_wall_ts(&after);
> +		nsec_delta = (u64)after.tv_sec * NSEC_PER_SEC + after.tv_nsec;
> +		nsec_delta -= (u64)now.tv_sec * NSEC_PER_SEC + now.tv_nsec;
> +	} while (nsec_delta > NSEC_PER_SEC / 8);
> +
> +	schedule_next_update();
> +}
> +
> +static __init int init_updates(void)
> +{
> +	schedule_next_update();
> +	return 0;
> +}
> +/*
> + * It has to be run after workqueues are initialized, since we call
> + * schedule_delayed_work. Other than that, we have no specific requirements
> + */
> +late_initcall(init_updates);
> +
> +/*
> + * The wallclock is the time of day when we booted. Since then, some time may
> + * have elapsed since the hypervisor wrote the data. So we try to account for
> + * that with system time
> + */
> +static unsigned long kvm_get_wallclock(void)
> +{
> +	struct timespec ts;
> +
> +	kvm_get_wall_ts(&ts);
>  
>  	return ts.tv_sec;
>  }
> -- 
> 1.6.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
