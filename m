Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXLDQAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXLDQAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXLDQAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:00:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXLDQAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:00:24 -0500
Date: Tue, 4 Dec 2007 17:00:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [local DoS] Re: Linux 2.6.24-rc4
Message-ID: <20071204160005.GA29783@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <20071204120715.4ea204a8@mandriva.com.br> <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 4 Dec 2007, Luiz Fernando N. Capitulino wrote:
> >
> > 	sched_rr_get_interval(1, NULL);
> 
> Looks like we have a zero "cfs_rq->load.weight".
> 
> Ingo? Both sched_slice() and __sched_slice() do a divide by the 
> runqueue weight, and at least dequeue_task_fair() explicitly checks 
> for that being zero, so clearly zero is a possible value. Hmm?

yeah, i can reproduce this crash too.

The problem is on SMP: if sched_rr_get_interval() gets a task from an 
otherwise idle runqueue, then rq->load.weight is 0. Normally 
sched_slice() is only used on a busy runqueue. So the correct fixup site 
is not in sched_slice() but in sys_sched_rr_get_interval() - i'm working 
on the right fix, i hope to be able to send a pull request in a few 
minutes.

	Ingo
