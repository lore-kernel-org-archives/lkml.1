Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZBTKZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZBTKZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZBTKZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:25:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48018 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbZBTKZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:25:10 -0500
Date: Fri, 20 Feb 2009 11:24:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, v2] x86: use the right protections for split-up
	pagetables
Message-ID: <20090220102434.GA24020@elte.hu>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain> <20090220072915.GB28085@elte.hu> <20090220073932.GA17648@elte.hu> <20090220080246.GA28669@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220080246.GA28669@elte.hu>
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

> [...] There's never any good reason to play protection games 
> with higher-level pagetable entries. We dont do it to 
> user-space pagetables either - we just populate them to 
> _PAGE_TABLE and that's it.

btw., this means that we could probably even use _PAGE_TABLE 
here (i.e. with the _PAGE_USER bit set), and rely on the PTE 
clearing the user bit ... but in this case that tiny bit of 
paranoia seems justified.

Btw., i also checked when this bug got introduced, and it got 
introduced 5 years ago (in May 2004) in 2.6.7-rc1, via this 
commit [historic-git sha1]:

 fb75a3d: [PATCH] x86-64 updates

 Date:   Fri May 14 20:40:53 2004 -0700

 [...]
     - Handle NX bit for code pages correctly in change_page_attr()
 [...]

-                       set_pte(kpte,mk_pte(split, PAGE_KERNEL));
+                       set_pte(kpte,mk_pte(split, ref_prot));

( That 'set_pte(kpte,...)' sequence is not a pte update but a 
  _pmd_ update, it is the ex-largepage pte, i.e. the pmd. )

So it's an ancient, dormant bug in the CPA code that nobody ever 
triggered, and we didnt notice when we rewrote that code either.

	Ingo
