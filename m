Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZBLImy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZBLImy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBLImp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:42:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZBLImo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:42:44 -0500
Date: Thu, 12 Feb 2009 09:42:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>
Subject: Re: [patch] irq threading: fix PF_HARDIRQ definition
Message-ID: <20090212084222.GA32091@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090211205533.329cea1c@torg> <20090212083850.GA29995@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212083850.GA29995@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hardirq_count() is correct, but looking at PF_HARDIRQ's definition in sched.h:
> 
>  #define PF_EXITPIDONE  0x00000008      /* pi exit done on shut down */
>  #define PF_VCPU        0x00000010      /* I'm a virtual CPU */
>  #define PF_HARDIRQ     0x08000020      /* hardirq context */
>  #define PF_NOSCHED     0x00000020      /* Userspace does not expect scheduling */
>  #define PF_FORKNOEXEC  0x00000040      /* forked but didn't exec */
> 
> Reveals that due to a typo it not only overlaps the PF_NOSCHED bit, but
> also has a spurious 0x08000000 component.

The reason is that when we forward ported the definition, i first moved it
to the 0x08000000 slot - but that slot was already taken. (our PF_ task
flag space is really crowded ...)

Then i moved it to a free spot, 0x20. Or so i thought: a later -rt patch
in the queue introduced PF_NOSCHED which overlapped it.

But the bigger problem was the spurious 0x08000000 component, which overlaps
with:

 #define PF_SOFTIRQ      0x08000000      /* softirq context */

Explaining why the warning triggered in ksoftirqd ;-)

Anyway, my fix should solve this. Do you still see the lockup under X? (make
sure you also have the IPI fix applied, see the patch in this same thread.)

	Ingo
