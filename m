Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYG1IRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYG1IRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYG1IQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:16:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYG1IQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:16:57 -0400
Date: Mon, 28 Jul 2008 10:16:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080728081639.GA27708@elte.hu>
References: <20080727190601.GA764@elte.hu> <200807281053.58267.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281053.58267.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Mike: I now think the right long-term answer is Linus' dense cpumap 
> idea + a convenience allocator for cpumasks.  We sweep the kernel for 
> all on-stack vars and replace them with one or the other.  Thoughts?

The dense cpumap for constant cpumasks is OK as it's clever, compact and 
static.

All-dynamic allocator for on-stack cpumasks ... is a less obvious 
choice.

I dont fundamentally oppose it, but doing that we might be throwing the 
baby out with the bathwater. In many cases having 0.5K on the kernel 
stack is OK. (especially for high-level functions.)

We could do all-dynamic allocations, and it's simpler in many ways (less 
ugly dual-use initialization macros), but it's intrusive for the common 
case. I kind of liked Mike's approach to push the dynamic overhead to 
the less common case - although i dont like all of the end result. 
That's been the driving principle behind the existing patches: dont hurt 
the common case.

Anyway, Mike's solution gives us the option to go in both directions now 
as we've essentially annotated the most difficult on-stack users and 
added a dynamic alloc/free path to them and tested it. Making them all 
dynamic will be easy as it just gets rid of the small-mask 
special-cases.

	Ingo
