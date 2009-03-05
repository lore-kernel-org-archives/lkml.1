Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZCEBDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZCEBDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZCEBD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:03:27 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:45224 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZCEBD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oXLIsx9CeMU9TADBhimDdp5R+oQgo639mhTRgtWI36UTxReM/yqZAdg2+0D3DW1D6a
         IlZEtK3C3m2eO0Z6BcKVsaJIRfPSq1ok/jK1a7pxAbgnJKxzpMEK5WpD6XrODMxRsNTG
         k1wYeP1iGUhdZ8+P7fxCQfnux7myHOsxWN5sw=
Date: Thu, 5 Mar 2009 02:03:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sched: don't rebalance if attached on NULL domain
Message-ID: <20090305010318.GB8949@nowhere>
References: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:27:02AM +0100, Frederic Weisbecker wrote:
> Impact: fix function graph trace hang / drop pointless softirq on UP
> 
> While debugging a function graph trace hang on an old PII, I saw that it
> consumed most of its time on the timer interrupt.
> And the domain rebalancing softirq was the most concerned.
> 
> The timer interrupt calls trigger_load_balance() which will decide if it is
> worth to schedule a rebalancing softirq.
> 
> In case of builtin UP kernel, no problem arises because there is no
> domain question.
> 
> In case of builtin SMP kernel running on an SMP box, still no problem,
> the softirq will be raised each time we reach the next_balance time.
> 
> In case of builtin SMP kernel running on a UP box (most distros provide default SMP
> kernels, whatever the box you have), then the CPU is attached to the NULL sched domain.
> So a kind of unexpected behaviour happen:
> 
> trigger_load_balance() -> raises the rebalancing softirq
> later on softirq: run_rebalance_domains() -> rebalance_domains() where
> the for_each_domain(cpu, sd) is not taken because of the NULL domain we are attached at.
> Which means rq->next_balance is never updated.
> So on the next timer tick, we will enter trigger_load_balance() which will always reschedule()
> the rebalacing softirq:
> 
> if (time_after_eq(jiffies, rq->next_balance))
> 	raise_softirq(SCHED_SOFTIRQ);
> 
> So for each tick, we process this pointless softirq.
> 
> This patch fixes it by checking if we are attached to the null domain before raising the softirq,
> another possible fix would be to set the maximal possible JIFFIES value to rq->next_balance if we are
> attached to the NULL domain.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


And speacking about the function graph hang, Reported-by: Ingo Molnar <mingo@elte.hu>

