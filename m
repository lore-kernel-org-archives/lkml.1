Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbZEEGle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbZEEGle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbZEEGlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:41:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbZEEGlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:41:08 -0400
Date: Tue, 5 May 2009 08:40:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: round-robining per-cpu counters
Message-ID: <20090505064051.GA27191@elte.hu>
References: <18943.47474.963294.862139@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18943.47474.963294.862139@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> It used to be, and as far as I can see still is, the case that 
> per-cpu counters take priority over per-task counters by virtue of 
> being scheduled in first.  That is, if you have N hardware 
> counters and >= N per-cpu counters, then no per-task counters will 
> ever get scheduled onto the PMU.
> 
> That being the case, I don't see what the point of having the 
> perf_reserved_percpu variable is.  It doesn't do anything except 
> set cpuctx->max_pertask, which isn't actually used anywhere.  In 
> any case with the current counter scheduling system there's no 
> need to "reserve" hardware counters for use by per-cpu counters 
> since any new per-cpu counters will just bump existing per-task 
> counters off - if not immediately then the next time that 
> perf_counter_task_tick gets called.
> 
> What was the intended meaning of perf_reserved_percpu?  I presume 
> it was that there would always be that many hardware counters 
> available for per-cpu counters regardless of how many per-task 
> counters there are.  But that doesn't answer the complementary 
> question - how many hardware counters can we rely on being 
> available for per-task counters?  At the moment the answer is 0, 
> but I don't think that is a good answer.
> 
> Does anyone have any good ideas about what the scheduling policy 
> should be?

The reservation mechanism really suffered from not being used by 
anything or anyone, and it thus bit-rotted across 300 follow-on 
commits.

What would be the primary usecase? Allow admin to set aside (and 
guarantee) space for task counters? Allow admin to 'force' 
exclusivity of counter ownership?

I think a better general solution would be to have a single 
round-robin list for all currently active counters (both percpu and 
task counters) - and fairly round-robin all of them. The scaling 
information makes it obvious when this is happening.

If admin wants stronger ownership of counters then the 
pinned/exclusive attribute can be used.

We really want to keep the counter-scheduler simple, and we also 
want to make the default to be as permissive as possible.

	Ingo
