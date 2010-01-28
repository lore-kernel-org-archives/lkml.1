Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089Ab0A1RdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0A1RdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650Ab0A1RdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:33:12 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64116 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab0A1RdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e41nGCgYCbDLkGpYfYGwWG2ngjzejwC8UsuTxdc5FRxENmo91pwtt24qYJ1w1LWjN/
         1ASELJGCEnmEO4Dr5frZKbtXtrtkeswjArss4ujmxDqnB9UA5lK5/Skea3CsuzUBJK/q
         98Iewaguxju1y+qsonZn71Ked9964YfJoP6WQ=
Date: Thu, 28 Jan 2010 18:33:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] perf,hw_breakpoint,kgdb: No mutex taken for kernel
	debugger
Message-ID: <20100128173307.GB18683@nowhere>
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com> <1264631124-4837-4-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264631124-4837-4-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 04:25:24PM -0600, Jason Wessel wrote:
> The kernel debugger cannot use any mutex_lock() calls because it can
> start the kernel running from an invalid context.
> 
> The possibility for a breakpoint reservation to be concurrently
> processed at the time that kgdb interrupts the system is improbable.
> As a safety check against this condition the kernel debugger will
> prohibit updating the hardware breakpoint reservations and an error
> will be returned to the end user.
> 
> Any time the kernel debugger reserves a hardware breakpoint it will be
> a system wide reservation.
> 
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: K.Prasad <prasad@linux.vnet.ibm.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  arch/x86/kernel/kgdb.c        |   49 +++++++++++++++++++++++++++++++++++++-
>  include/linux/hw_breakpoint.h |    2 +
>  kernel/hw_breakpoint.c        |   52 +++++++++++++++++++++++++++++++++--------
>  3 files changed, 92 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index 9f47cd3..7c3e929 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -239,6 +239,45 @@ static void kgdb_correct_hw_break(void)
>  	hw_breakpoint_restore();
>  }
>  
> +static int hw_break_reserve_slot(int breakno)
> +{
> +	int cpu;
> +	int cnt = 0;
> +	struct perf_event **pevent;
> +
> +	for_each_online_cpu(cpu) {
> +		cnt++;
> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
> +		if (dbg_reserve_bp_slot(*pevent))
> +			goto fail;
> +	}
> +
> +	return 0;
> +
> +fail:
> +	for_each_online_cpu(cpu) {
> +		cnt--;
> +		if (!cnt)
> +			break;
> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
> +		dbg_release_bp_slot(*pevent);
> +	}
> +	return -1;
> +}
> +
> +static int hw_break_release_slot(int breakno)
> +{
> +	struct perf_event **pevent;
> +	int ret;
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
> +		ret = dbg_release_bp_slot(*pevent);



So, you are missing some return errors there. Actually, a slot
release shouldn't return an error.



> +/*
> + * Allow the kernel debugger to reserve breakpoint slots without
> + * taking a lock using the dbg_* variant of for the reserve and
> + * release breakpoint slots.
> + */
> +int dbg_reserve_bp_slot(struct perf_event *bp)
> +{
> +	if (mutex_is_locked(&nr_bp_mutex))
> +		return -1;
> +
> +	return __reserve_bp_slot(bp);
> +}
> +
> +int dbg_release_bp_slot(struct perf_event *bp)
> +{
> +	if (mutex_is_locked(&nr_bp_mutex))
> +		return -1;
> +
> +	__release_bp_slot(bp);
> +
> +	return 0;
> +}



Ok, best effort fits well for reserve, but is certainly not
suitable for release. We can't leave a fake occupied slot like
this. If it fails, we should do this asynchronously, using the
usual release_bp_slot, may be toward the workqueues.




>  
>  int register_perf_hw_breakpoint(struct perf_event *bp)
>  {
> -- 
> 1.6.4.rc1
> 

