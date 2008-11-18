Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYKRNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYKRNs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYKRNss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:48:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYKRNss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:48:48 -0500
Date: Tue, 18 Nov 2008 14:48:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
Message-ID: <20081118134835.GC31146@elte.hu>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Hi Steven,
> 
> I was wondering why the preemptoff and preemptirqsoff tracer 
> selftests don't work on s390. After all its just that they get 
> called from non-preemptible context:
> 
> kernel_init() will execute all initcalls, however the first line in 
> kernel_init() is lock_kernel(), which causes the preempt_count to be 
> increased. Any later calls to add_preempt_count() (especially those 
> from the selftests) will therefore not result in a call to 
> trace_preempt_off() since the check below in add_preempt_count() 
> will be false:
> 
> 	if (preempt_count() == val)
> 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
> 
> Hence the trace buffer will be empty.

ah, indeed :-)

side-effect of the removal of CONFIG_PREEMPT_BKL - these things were 
written before that and nobody noticed that the self-test stopped 
working for real.

> The patch below makes the selftests working for me, since then they 
> run in preemptible context. But it is ugly and I'm not proposing it 
> for upstream ;)
> 
> Just wanted to make you aware that there is a bug.

indeed it's ugly. We could perhaps drop the BKL in the selftests?

	Ingo
