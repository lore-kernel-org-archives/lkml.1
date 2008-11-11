Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYKKJzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYKKJzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYKKJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:55:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51561 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbYKKJzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:55:02 -0500
Date: Tue, 11 Nov 2008 10:54:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081111095439.GA30425@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <20081110085846.GG22392@elte.hu> <1226321061.23701.1283927805@webmail.messagingengine.com> <20081110130709.GA32613@elte.hu> <1226352907.25721.1284024167@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226352907.25721.1284024167@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> > OTOH, unless i'm misreading them, it's a bit hard to compare them 
> > visually: the integral of the histograms does not seem to be 
> > constant, they dont seem to be normalized.
> 
> The total number of measured intervals (between two almost-adjacent 
> rdtsc's) is exactly the same for all histograms (10^10). Almost all 
> measurements are of the "nothing happened" type, i.e., around 11 
> clock cycles on this machine. The user time spent inside the 
> rdtsctest program is almost independent of the load, but it measures 
> time spent outside of the program... But what should be attributed 
> to what effect is unclear to me at the moment.

a high-pass filter should be applied in any case, to filter out the 
"nothing happened" baseline. Eliminating every delta below 500-1000 
cycles would do the trick i think, all IRQ costs are at least 1000 
cycles.

then a low-pass filter should be applied to eliminate non-irq noise 
such as scheduling effects or expensive irqs (which are both 
uninteresting to such analysis).

and then _that_ double-filtered dataset should be normalized: the 
number of events should be made the same. (just clip the larger 
dataset to the length of the smaller dataset)

> > It should be made constant for them to be comparable. (i.e. the 
> > total number of irq hits profiled should be equal - or should be 
> > normalized with the sum after the fact)
> 
> Basically the difference between the "idle" and "hack10" versions 
> should indicate the effect of extra interrupts (timer) and 
> additional exceptions and cache effects due to context switching.

i was only looking at before/after duos, for the same basic type of 
workload. Idle versus hackbench is indeed apples to oranges.

	Ingo
