Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYLRVpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYLRVpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYLRVpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:45:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYLRVpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:45:24 -0500
Date: Thu, 18 Dec 2008 22:44:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
	interrupt infinite loop
Message-ID: <20081218214458.GA30834@elte.hu>
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu> <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain> <20081218112216.GE14332@elte.hu> <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com> <20081218211637.GF24271@elte.hu> <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > Which means that it's not some hrtimer problem, but simply the traced 
> > timer tick takes more than 1 millisecond to execute under this 
> > virtualization.
> >
> >        Ingo
> >
> 
> Oh ok I see. Sorry I'm a bit slow today... So the solution would be to 
> adapt dynamically the timeout between hrtimer irq. But I don't know that 
> much hrtimer to implement such a feature...

just if you want this lockup to go away. I think you did the hardest bit 
already: to detect the situation reliably, without false positives. Now 
the 'action' needs to change: instead of 'turning off ftrace' (which is 
brutal - ftrace was just the last drop of water that pushed the system 
over the edge), we can instead do 'double the minimum clockevent delta 
threshold'.

there's already such code in kernel/time/tick-oneshot.c:

                /*
                 * We tried 2 times to program the device with the given
                 * min_delta_ns. If that's not working then we double it
                 * and emit a warning.
                 */
                if (++i > 2) {
                        /* Increase the min. delta and try again */
                        if (!dev->min_delta_ns)
                                dev->min_delta_ns = 5000;
                        else
                                dev->min_delta_ns += dev->min_delta_ns >> 1;

what would be needed is to simply double ->min_delta_ns on every such 
situation you detect? Once you do that, it takes effect on the next tick 
automatically.

Or something like that. In theory. :-)

	Ingo
