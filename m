Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZEIIbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZEIIbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZEIIbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:31:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZEIIbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:31:08 -0400
Date: Sat, 9 May 2009 10:30:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
Message-ID: <20090509083017.GA3656@elte.hu>
References: <1241795429.28600.61.camel@penberg-laptop> <alpine.DEB.1.10.0905081127240.26361@qirst.com> <1241797017.28600.63.camel@penberg-laptop> <1241797364.6311.2914.camel@laptop> <1241797558.28600.68.camel@penberg-laptop> <1241797858.6311.2925.camel@laptop> <20090508161553.GL6132@lenovo> <1241800267.6311.2969.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241800267.6311.2969.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-05-08 at 20:15 +0400, Cyrill Gorcunov wrote:
> > [Peter Zijlstra - Fri, May 08, 2009 at 05:50:58PM +0200]
> > | On Fri, 2009-05-08 at 18:45 +0300, Pekka Enberg wrote:
> > | 
> > | > On Fri, 2009-05-08 at 17:42 +0200, Peter Zijlstra wrote:
> > | > > BUG_ON((gfp & __GFP_PANIC) && (system_state != STATE_BOOTING));
> > | > 
> > | > There's no technical reason not to use GFP_PANIC when system_state !=
> > | > STATE_BOOTING so I don't think it's needed. It's just that GFP_PANIC
> > | > (and BUG_ON) is IMHO too harsh for create_unique_id().
> > | 
> > | Shouldn't we handle every allocation failure after booting?
> > 
> > Definitely
> > 
> > | 
> > | I think it _is_ a bug to panic on allocation failures once we're
> > | running.
> > |
> > 
> > But Peter I believe there was no suggestion to use GFP_PANIC everywhere
> > to get rid of error handling. But rather to use it in case if kmalloc is
> > followed by BUG_ON.
> 
> Well, what I'm saying is that that either is a genuine bug we 
> should fix, or its boot code, which is exactly what my assertion 
> above tests for.

This is about boot code - and only about boot code.

This is a really simple thing. Replace existing x86 platform code 
early boot allocaton patterns of:

	x = alloc(GFP_KERNEL, ...);
	BUG_ON(!x);

	y = alloc(GFP_KERNEL, ...);
	BUG_ON(!y);

With:

	x = alloc(GFP_KERNEL | __GFP_PANIC, ...);

	y = alloc(GFP_KERNEL | __GFP_PANIC, ...);

it makes code shorter, smaller and easier to read. Nothing more, 
nothing less. And yes, i agree that we should disallow this after 
bootup has finished - but the boot-alloc case Cyrill and me would 
like to handle via this is still fully valid.

	Ingo
