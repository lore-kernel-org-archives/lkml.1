Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXCAIx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXCAIx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXCAIx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:53:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbXCAIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:53:56 -0500
Date: Thu, 1 Mar 2007 09:46:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Message-ID: <20070301084657.GA31728@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200702281007.16316.kernel@kolivas.org> <1172636499.6534.101.camel@Homer.simpson.net> <200703010901.41715.kernel@kolivas.org> <1172707341.7027.95.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172707341.7027.95.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> I see no real difference between the two assertions.  Nice is just a 
> mechanism to set priority, so I applied your assertion to a different 
> range of priorities than nice covers, and returned it to show that the 
> code contradicts itself.  It can't be bad for a nice 1 task to run 
> with a nice 0 task, but OK for a minimum RT task to run with a maximum 
> RT task.  Iff HT without corrective measures breaks nice, then it 
> breaks realtime priorities as well.

i'm starting to lean towards your view that we should not artificially 
keep tasks from running, when there's a free CPU available. We should 
still keep the 'other half' of SMT scheduling: the immediate pushing of 
tasks to a related core, but this bit of 'do not run tasks on this CPU' 
dependent-sleeper logic is i think a bit fragile. Plus these days SMT 
siblings do not tend to influence each other in such a negative way as 
older P4 ones where a HT sibling would slow down the other sibling 
significantly.

plus with an increasing number of siblings (which seems like an 
inevitable thing on the hardware side), the dependent-sleeper logic 
becomes less and less scalable. We'd have to cross-check every other 
'related' CPU's current priority to decide what to run.

if then there should be a mechanism /in the hardware/ to set the 
priority of a CPU - and then the hardware could decide how to prioritize 
between siblings. Doing this in software is really hard.

	Ingo
