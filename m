Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbYASPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbYASPbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbYASPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:31:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555AbYASPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:31:09 -0500
Date: Sat, 19 Jan 2008 16:30:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems
Message-ID: <20080119153055.GA12054@elte.hu>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119152649.GA1375@one.firstfloor.org>
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


(Cc:-ing to lkml, because this might interest others too)

* Andi Kleen <andi@firstfloor.org> wrote:

> > would be interesting to figure out what's going on here - i doubt 
> > it's an ACPI bug, because then we'd be getting a hard page fault, 
> > right? In
> 
> ACPI hasn't changed at all in git-x86 and it worked fine before. So I 
> don't really blame it.

yes, it did not change, but there are latent ACPI bugs/uncleanlinesses 
where it references an already unmapped table. This worked by chance 
until now, because we didnt actually unmap any tables - but now we 
explicitly map/unmap the tables via the MMU. But, i dont think that's 
the cause of the failure here - those bugs typically show up in other 
ways.

> > that case it's a 64-bit early_ioremap() bug that we want to find 
> > even if ACPI didnt use early_ioremap().
> > 
> > and this all runs before zap_low_mappings(), right?
> 
> No after. Since some time x86-64 does the equivalent of z_l_m() in 
> head64(); this means before start_kernel and definitely before 
> setup_arch which sets up ACPI.

that would mean early_ioremap() should switch to ioremap() after that 
point. Could you try that, does it resolve the failure you are seeing? 

Long-term we want to have a single, uniform ioremap() interface (on 
32-bit and 64-bit x86 as well) that can be used anytime, which just 
switches to the right lowlevel method depending on how far we are into 
the pagetable and memory subsystem bootstrap - instead of these more 
fragile "can we now use early_ioremap() or should we already be using 
ioremap()" usages.

	Ingo
