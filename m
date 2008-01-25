Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYAYNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYAYNaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYAYNa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:30:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbYAYNa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:30:28 -0500
Date: Fri, 25 Jan 2008 14:30:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git] new CPA implementation
Message-ID: <20080125133015.GA29040@elte.hu>
References: <20080125002401.GA31745@elte.hu> <200801250901.48422.ak@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801250901.48422.ak@novell.com>
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


* Andi Kleen <ak@novell.com> wrote:

> > - the new implementation is much more scalable, because it is 
> > lockless
> >   in the fastpath
> 
> What fast path?  This should not really be called that often, 
> especially not when DEBUG_PAGEALLOC has its own simple implementation.

that's a point you are still missing badly in all these discussions 
about unification and sound design practices: code reuse and a clean, 
layered design. PAGEALLOC now uses change_page_attr() again and that 
approach is working really well.

You made PAGEALLOC use a special-purpose remapping function but that 
would make c_p_a() unrobust indirectly - simply because it would be used 
much less.

So i've removed that change and have fixed c_p_a() instead to both be 
fast and scalable enough for PAGEALLOC and to be robust enough for 
PAGEALLOC. Both sides of the equation (PAGEALLOC and c_p_a()) benefit 
from that.

> Anyways the most important general optimization imho (which you 
 > unfortunately dropped) was to get rid of the WBINVDs which unlike 
> everything else cpa does are _really_ costly.

it wasnt "dropped" - your wbinvd->clflush feature was never submitted in 
a clean fashion. The "great CPA" patchset you submitted to lkml 3 weeks 
ago was a badly interwined tangle of features and fixes, which just 
added ontop of the existing set of bad practices and design. We asked 
you to restructure, we even added your patchset to x86.git to encourage 
you to do it (and you wrote the whole code to begin with), but you did 
not clean it up and you generally were not showing interest in such 
efforts. We finally got sick of your stance and i rewrote the code with 
Thomas.

The current CPA patchset in x86.git does it the right way around: 
_first_ it got rid of the sources of unrobustness, consolidated and 
cleaned up the structure and design of the codebase, and now we can 
layer features ontop of it. (once we can trust the new codebase)

> > - the CPA-testsuite now passes without failures on both 32-bit and
> >   64-bit. (it never fully worked with your CPA series.)
> 
> Without reassembly implemented CPA_TEST will always imply running a 
> lot of the direct memory as 4K pages so it can't be safely enabled on 
> production kernels anymore. You should probably at least add a warning 
> or limit the test to only work on a small portion of the direct 
> mapping now.

good point - i have made it dependent on DEBUG_KERNEL now and extended 
the help text.

	Ingo
