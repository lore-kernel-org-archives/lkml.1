Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbZBRTSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbZBRTSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZBRTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:18:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbZBRTSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:18:37 -0500
Date: Wed, 18 Feb 2009 20:17:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
Message-ID: <20090218191757.GD8889@elte.hu>
References: <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de> <1234982620.29823.22.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234982620.29823.22.camel@vayu>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Wed, 2009-02-18 at 05:59 -0800, Nick Piggin wrote:
> > You're saying the problem is in generic_exec_single because I've
> > removed the smp_mb that inadvertently also serialises memory with
> > the x2apic on x86?
> 
> yes.
> 
> > 
> > Indeed that could cause problems on some architectures which I
> > had hoped to avoid. So the patch is probably better off to first
> > add the smp_mb() to arch_send_call_function_xxx arch code, unless
> > it is immediately obvious or confirmed by arch maintainer that
> > such barrier is not required.
> 
> For x2apic specific operations we should add the smp_mb() sequence. But
> we need to make sure that we don't end up doing it twice (once in
> generic code and another in arch code) for all the ipi paths.

right now we do have an smp_mb() due to your fix in November.

So what should happen is to move that smp_mb() from the x86 
generic IPI path to the x86 x2apic IPI path. (and turn it into 
an smp_wmb() - that should be enough - we dont care about future 
reads being done sooner than this point.)

	Ingo
