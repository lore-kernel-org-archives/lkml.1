Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZBWKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZBWKSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZBWKSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:18:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZBWKSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:18:06 -0500
Date: Mon, 23 Feb 2009 11:17:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Message-ID: <20090223101741.GP9582@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org> <499FAE55.8070801@kernel.org> <20090222193817.GC21320@elte.hu> <49A1F132.8080004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1F132.8080004@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Ingo Molnar wrote:
> > Heck no. It is absolutely crazy to complicate __pa()/__va() in 
> > _any_ way just to 'save' one more 2MB dTLB.
> 
> Are __pa()/__va() that hot paths?  Or am I over-estimating the 
> cost of 2MB dTLB?

yes, __pa()/__va() is a very hot path - in a defconfig they are 
used in about a thousand different places.

In fact it would be nice to get rid of the __phys_addr() 
redirection on the 64-bit side (which is non-linear and a 
function there, and all __pa()s go through it) and make it a 
constant offset again.

This isnt trivial/possible to do though as .data/.bss is in the 
high alias. (high .text aliases alone wouldnt be a big issue to 
fix, but the data aliases are an issue.)

Moving .data/.bss into the linear space isnt feasible as we'd 
lose RIP-relative addressing shortcuts.

Maybe we could figure out the places that do __pa() on a high 
alias and gradually eliminate them. __pa() on .data/.bss is a 
rare and unusal thing to do, and CONFIG_DEBUG_VIRTUAL could warn 
about them without crashing the kernel.

Later on we could make this check unconditional, and then switch 
over __pa() to addr-PAGE_OFFSET in the !CONFIG_DEBUG_VIRTUAL 
case (which is the default).

	Ingo
