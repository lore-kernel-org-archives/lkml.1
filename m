Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZBTDpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZBTDpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZBTDpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:45:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbZBTDpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:45:32 -0500
Date: Thu, 19 Feb 2009 19:44:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] changes for tip, and a nasty x86 page table bug 
In-Reply-To: <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Feb 2009, Steven Rostedt wrote:
> > 
> > How do we ever have a PMD that is read-only? That sounds like a bug to 
> > begin with. There's no reason to ever do that.
> 
> Patch 2/6 explains how this happened, and supplies the fix.

I think your fix is for a real bug, but I think it's still bogus.

That whole "ref_prot" code is SH*T. When we do a set_pmd(), the old 
huge-page protections do not matter AT ALL for the new pmd. It matters for 
the new _leaf_ entries (the "ref_prot" 20 lines higher up), but not for 
the upper level. That should have all bits set.

So the whole

        ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
        pgprot_val(ref_prot) |= _PAGE_PRESENT;
        __set_pmd_pte(kpte, address, mk_pte(base, ref_prot));

sequence is utter crap, I think. The whole "ref_prot" there should be just 
_pgprot(_KERNPG_TABLE), I think. I don't think there is any other valid 
value.

So I would argue that the comment above that piece of code is total and 
utter crap (all the protection info _and_ all the PAT bits are now in the 
pte, and trying to move them into the pmd is *buggy*), and the three lines 
should basically be

	__set_pmd_pte(kpte, address, mk_pte(base, _pgprot(_KERNPG_TABLE)));

but let's see if somebody can tell me why I'm wrong.

"git blame" attributes this all to Ying Huang and Thomas. And looking at 
the commit that introduced the pte_mkexec(), I really think the code was 
confused and people never thought about it deeply.

Comments?

		Linus
