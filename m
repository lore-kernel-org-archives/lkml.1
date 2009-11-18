Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbZKRQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbZKRQq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbZKRQq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:46:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbZKRQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:46:26 -0500
Subject: Re: [PATCH] perf_events: fix validate_event bug
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
In-Reply-To: <1256223091-6002-1-git-send-email-eranian@gmail.com>
References: <>  <1256223091-6002-1-git-send-email-eranian@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:46:25 +0100
Message-ID: <1258562785.3918.685.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 16:51 +0200, Stephane Eranian wrote:
> 	The validate_event() was failing on valid event
> 	combinations. The function was assuming that if
> 	x86_schedule_event() returned 0, it meant error.
> 	But x86_schedule_event() returns the counter index
> 	and 0 is a perfectly valid value. An error is returned
> 	if the function returns a negative value.

Good point.

> 	Furthermore, validate_event() was also failing for
> 	event groups because the event->pmu was not set until
> 	after hw_perf_pmu_init().

(hw_perf_event_init, right?)

Won't this give very funny results for mixed pmu groups?

How about something like:

 if (event->pmu && event->pmu != &pmu)
	return 0;

That should deal with new events, who do not yet have their pmu set and
for those we know they're for us, but exclude events for other PMUs.

> 	Signed-off-by: Stephane Eranian <eranian@gmail.com>
> --
>  arch/x86/kernel/cpu/perf_event.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 2e20bca..d321ff7 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -2229,10 +2229,7 @@ validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
>  {
>  	struct hw_perf_event fake_event = event->hw;
>  
> -	if (event->pmu != &pmu)
> -		return 0;
> -
> -	return x86_schedule_event(cpuc, &fake_event);
> +	return x86_schedule_event(cpuc, &fake_event) >= 0;
>  }
>  
>  static int validate_group(struct perf_event *event)


