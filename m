Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYJ3SVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYJ3SVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYJ3SVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:21:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbYJ3SVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:21:12 -0400
Date: Thu, 30 Oct 2008 19:20:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Message-ID: <20081030182056.GA14102@elte.hu>
References: <490A08E3.2040201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490A08E3.2040201@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi.
> 
> First of all, I want to say this patch is absolutely not ready for 
> inclusion. Some parts are really ugly and the thing is only 
> partially functionning.
> 
> It's just an idea or a kind of proof of concept. I just wanted to 
> make ftrace able to measure the time of execution of a function. For 
> that I had to hook both the function call and its return.
> 
> By using mcount, we can hook the function on enter and we can 
> override its return address. So we can catch the time at those two 
> points. The problem comes when a function run concurrently through 
> preemption or smp. We can measure the return time but how to be sure 
> which time capture we had on call since this time could have been 
> captured multiple times. And for the same reason, how to make sure 
> of the return address.
> 
> So the idea is to allocate a general set of slots on which we can 
> save our original return address and the call time. After that we 
> change the return address of the hooked function to jump on a 
> trampoline which will push the offset for us to retrieve the slot on 
> the set for this function call. Then the trampoline will call a 
> return handler that will trace the return time and send all of these 
> informations to a specific tracer. And then the return handler will 
> return to the original return address.
> 
> To determine quickly which slot is free, I use a bitmap of 32 bits. 
> Perhaps it is a bad assumption but I could enlarge it and there is 
> an overrun counter. This is the only point which needs to be 
> protected against concurrent access.
> 
> I made a tracer for this but the problem is that the capture by 
> ftrace will hang the system if we can use several slots. When I 
> dedicate only one free slot, wherever on the set, there is no 
> problem but I miss a lot of calls. So by default on this patch, 
> there is only one slot dedicated on the bitmap.
>
> Don't hesitate to comment this patch made of trashes...

hm, are you aware of the -finstrument-functions feature of GCC?

that feature generates such entry points at build time:

                   void __cyg_profile_func_enter (void *this_fn,
                                                  void *call_site);
                   void __cyg_profile_func_exit  (void *this_fn,
                                                  void *call_site);

this might be faster/cleaner than using a trampoline approach IMO.

OTOH, entry+exit profiling has about double the cost of just entry 
profiling - so maybe there should be some runtime flexibility there. 
Plus the same recordmcount trick should be used to patch up these 
entry points to NOP by default.

	Ingo
