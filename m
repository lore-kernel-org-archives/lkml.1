Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXK1QFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXK1QFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 11:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760997AbXK1QFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 11:05:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424AbXK1QFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:05:19 -0500
Date: Wed, 28 Nov 2007 17:05:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128160501.GA7986@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128150840.GB5518@c2.user-mode-linux.org> <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu> <20071128154152.GA742@elte.hu> <E1IxPKU-00079S-UH@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxPKU-00079S-UH@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > it doesnt need it - turn IRQOFF_TRACING off.
> 
> # CONFIG_CRITICAL_IRQSOFF_TIMING is not set
> 
> This seems to be off.
> 
> But latency_trace.c uses irqs_disabled_flags(), which is defined in 
> <linux/irqflags.h> only if CONFIG_TRACE_IRQFLAGS_SUPPORT is set.
> 
> So perhaps latency_trace.c should be using raw_irqs_disabled_flags() 
> instead.  But UML doesn't define that either and I have no idea how to 
> do that, so this is still not solved yet.

irqs_disabled_flags() gives us a nonessential bit of the trace output:

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
 privoxy-12926 1.Ns1    0us : ktime_get_ts (ktime_get)
 privoxy-12926 1.Ns1    0us : getnstimeofday (ktime_get_ts)
 privoxy-12926 1.Ns1    1us : set_normalized_timespec (ktime_get_ts)
 privoxy-12926 1.Ns1    1us : rb_first (htb_dequeue)

it's the 'irqs-off' flag, which is 'd', 'D' or '.'.

so you can define irqs_off_flags to always-0 and you should be able to 
get pretty good traces still. It should have no functional impact.

	Ingo
