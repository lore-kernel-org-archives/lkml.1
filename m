Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0CBNKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:10:14 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60748 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0CBNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:10:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XNRrya74El7GKQIKM6RoFHg9gaJh3AD69pxbjrQ2NEXZZcKbf2MMhBl6pbLKBU5fzz
         OAjEE/JlAgTUqHy1nMvvUermQpXWMamftPVN2gbduEN0ksqN9JncxeKYrKZmVpIedP+0
         xkFrSs4xfBBl9L+UcFchVdzGRb+WEuPkUa1QI=
Date: Tue, 2 Mar 2010 14:10:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com
Subject: Re: [PATCH] perf_events: add sampling period randomization support
Message-ID: <20100302131002.GD5137@nowhere>
References: <1267510029-19750-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267510029-19750-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 10:07:09PM -0800, eranian@google.com wrote:
> This patch adds support for randomizing the sampling period.
> Randomization is very useful to mitigate the bias that exists
> with sampling. The random number generator does not need to
> be sophisticated. This patch uses the builtin random32()
> generator.
> 
> The user activates randomization by setting the perf_event_attr.random
> field to 1 and by passing a bitmask to control the range of variation
> above the base period. Period will vary from period to period & mask.
> Note that randomization is not available when a target interrupt rate
> (freq) is enabled.
> 
> The last used period can be collected using the PERF_SAMPLE_PERIOD flag
> in sample_type.
> 
> The patch has been tested on X86. There is also code for PowerPC but
> I could not test it.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> --
>  arch/powerpc/kernel/perf_event.c       |    3 +++
>  arch/x86/kernel/cpu/perf_event.c       |    2 ++
>  arch/x86/kernel/cpu/perf_event_intel.c |    4 ++++
>  include/linux/perf_event.h             |    7 +++++--
>  kernel/perf_event.c                    |   24 ++++++++++++++++++++++++
>  5 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> index b6cf8f1..994df17 100644
> --- a/arch/powerpc/kernel/perf_event.c
> +++ b/arch/powerpc/kernel/perf_event.c
> @@ -1150,6 +1150,9 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  	val = 0;
>  	left = atomic64_read(&event->hw.period_left) - delta;
>  	if (period) {
> +		if (event->attr.random)
> +			perf_randomize_event_period(event);
> +
>  		if (left <= 0) {
>  			left += period;
>  			if (left <= 0)
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 641ccb9..159d951 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1110,6 +1110,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>  		if (val & (1ULL << (x86_pmu.event_bits - 1)))
>  			continue;
>  
> +		if (event->attr.random)
> +			perf_randomize_event_period(event);
>  		/*
>  		 * event overflow
>  		 */
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index cf6590c..5c8d6ed 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -690,6 +690,10 @@ static int intel_pmu_save_and_restart(struct perf_event *event)
>  	int ret;
>  
>  	x86_perf_event_update(event, hwc, idx);
> +
> +	if (event->attr.random)
> +		perf_randomize_event_period(event);
> +
>  	ret = x86_perf_event_set_period(event, hwc, idx);
>  
>  	return ret;
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 04f06b4..e91a759 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -203,8 +203,8 @@ struct perf_event_attr {
>  				enable_on_exec :  1, /* next exec enables     */
>  				task           :  1, /* trace fork/exit       */
>  				watermark      :  1, /* wakeup_watermark      */
> -
> -				__reserved_1   : 49;
> +				random	       :  1, /* period randomization  */


I'd rather name this field random_period. Even though the comment
tell us enough, it's better that the code speak for itself.

