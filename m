Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXINIR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXINIR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbXINIRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:17:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbXINIRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:17:42 -0400
Date: Fri, 14 Sep 2007 10:17:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070914081735.GC16159@elte.hu>
References: <1189725940.4485.53.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189725940.4485.53.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* dimm <dmitry.adamushko@gmail.com> wrote:

> and here's something a bit more intrusive.
> 
> The initial idea was to completely get rid of 'se->fair_key'. It's 
> always equal to 'se->vruntime' for all runnable tasks but the 
> 'current'. The exact key within the tree for the 'current' has to be 
> known in order for __enqueue_entity() to work properly (if we just use 
> 'vruntime', we may go a wrong way down the tree while looking for the 
> correct position for a new element). Sure, it's possible to cache the 
> current's key in the 'cfs_rq' and add a few additional checks, but 
> that's not very nice... so what if we don't keep the 'current' within 
> the tree? :-)
> 
> The illustration is below. Some bits can be missed so far but a 
> patched kernel boots/works (haven't done real regression tests yet... 
> can say that the mail client is still working at this very moment :-).
> 
> There are 2 benefits:
> 
> (1) no more 'fair_key' ;
> (2) entity_tick() is simpler/more effective : 'update_curr()' now vs.
> 'dequeue_entity() + enqueue_entity()' before.

cool patch - i like it! It removes some code as well, besides shrinking 
struct task_struct with another 64-bit variable - so it's a nice 
speedup:

   text    data     bss     dec     hex filename
  34467    3466      24   37957    9445 sched.o.before
  34414    3466      24   37904    9410 sched.o.after

i've applied it to the end of the queue - it depends on whether 
->vruntime works out well.

	Ingo
