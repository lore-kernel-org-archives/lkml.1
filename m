Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYBDLSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYBDLSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYBDLSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:18:17 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:59005 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYBDLSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:18:16 -0500
Date: Mon, 4 Feb 2008 12:17:47 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080204111747.GB4450@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080131102919.GC27157@elte.hu>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 04 Feb 2008 12:17:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

any progress here? I've tried to revert this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=67e9fb2a39a1d454218d50383094940982be138f

as it was marked as suspicious patch in this case
(http://www.uwsg.indiana.edu/hypermail/linux/kernel/0801.3/1665.html)

but in such a case, kernel 2.6.24-git13 does oops at startup in sched_slice.

I think this is really *big* regression in 2.6.24 kernel.

On Thu, Jan 31, 2008 at 11:29:19AM +0100, Ingo Molnar wrote:
> 
> * Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> 
> > I noticed short thread in LKM regarding "sched: add vslice" causes 
> > horrible interactivity under load.
> > 
> > I can see similar behavior. If I stress both CPU cores, even typing on 
> > keyboard suffers from huge latencies, I can see letters appearing with 
> > delay (typing into xterm). No swap is used at all, having 1GB free 
> > RAM.
> > 
> > I noticed this bad behavior with 2.6.24-git[46], 2.6.24-rc8-git was 
> > OK.
> 
> if you apply the current sched-fixes (rollup patch below), does it get 
> any better?
> 
> 	Ingo
> 
> Index: linux/kernel/sched_fair.c
> ===================================================================
> --- linux.orig/kernel/sched_fair.c
> +++ linux/kernel/sched_fair.c
> @@ -520,7 +520,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
>  
>  	if (!initial) {
>  		/* sleeps upto a single latency don't count. */
> -		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
> +		if (sched_feat(NEW_FAIR_SLEEPERS))
>  			vruntime -= sysctl_sched_latency;
>  
>  		/* ensure we never gain time by being placed backwards. */
> @@ -1106,7 +1106,11 @@ static void check_preempt_wakeup(struct 
>  	}
>  
>  	gran = sysctl_sched_wakeup_granularity;
> -	if (unlikely(se->load.weight != NICE_0_LOAD))
> +	/*
> +	 * More easily preempt - nice tasks, while not making
> +	 * it harder for + nice tasks.
> +	 */
> +	if (unlikely(se->load.weight > NICE_0_LOAD))
>  		gran = calc_delta_fair(gran, &se->load);
>  
>  	if (pse->vruntime + gran < se->vruntime)

-- 
Luká¹ Hejtmánek
