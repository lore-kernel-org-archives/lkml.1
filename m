Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbZEALvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbZEALvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbZEALvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:51:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZEALvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:51:01 -0400
Date: Fri, 1 May 2009 13:50:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter atomic
Message-ID: <20090501115047.GA24706@elte.hu>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501022403.826182932@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The entries counter in cpu buffer is not atomic. Although it only 
> gets updated by a single CPU, interrupts may come in and update 
> the counter too. This would cause missing entries to be added.

> -	unsigned long			entries;
> +	atomic_t			entries;

Hm, that's not really good as atomics can be rather expensive and 
this is the fastpath.

This is the upteenth time or so that the fact that we do not disable 
irqs while generating trace entries bites us in one way or another. 
IRQs can come in and confuse function trace output, etc. etc.

Please lets do what i suggested a long time ago: disable irqs _once_ 
in any trace point and run atomically from that point on, and enable 
them once, at the end.

The cost is very small and it turns into a win immediately by 
elimination of a _single_ atomic instruction. (even on Nehalem they 
cost 20 cycles. More on older CPUs.) We can drop the preempt-count 
disable/enable as well and a lot of racy code as well. Please.

	Ingo
