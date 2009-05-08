Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZEHI7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZEHI7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZEHI7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:59:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZEHI72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:59:28 -0400
Date: Fri, 8 May 2009 10:58:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/x86-64: clean up warnings
	aboutIST-using traps
Message-ID: <20090508085805.GA28455@elte.hu>
References: <4A032EE0.9030607@goop.org> <4A03F947.76EA.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03F947.76EA.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Jeremy Fitzhardinge <jeremy@goop.org> 07.05.09 20:56 >>>
> >Ignore known IST-using traps.  Aside from the debugger traps, they're
> >low-level faults which Xen will handle for us, so the kernel needn't
> >worry about them.  Keep warning in case unknown trap starts using IST.
> >
> >Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >---
> > arch/x86/xen/enlighten.c |   22 ++++++++++++++++++++--
> > 1 files changed, 20 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> >index cb49f57..88f3aa4 100644
> >--- a/arch/x86/xen/enlighten.c
> >+++ b/arch/x86/xen/enlighten.c
> >@@ -439,12 +439,30 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
> > 
> > 	addr = gate_offset(*val);
> > #ifdef CONFIG_X86_64
> >+	/*
> >+	 * Look for known traps using IST, and substitute them
> >+	 * appropriately.  The debugger ones are the only ones we care
> >+	 * about.  Xen will handle faults like double_fault and
> >+	 * machine_check, so we should never see them.  Warn if
> >+	 * there's an unexpected IST-using fault handler.
> >+	 */
> > 	if (addr == (unsigned long)debug)
> > 		addr = (unsigned long)xen_debug;
> > 	else if (addr == (unsigned long)int3)
> > 		addr = (unsigned long)xen_int3;
> >-	else
> >-		WARN_ON(val->ist != 0);
> >+	else if (addr == (unsigned long)double_fault ||
> >+		 addr == (unsigned long)stack_segment) {
> 
> I don't think you want to exclude handling stack faults: Ordinary 
> memory references using rsp or rbp as the base register will cause 
> these instead of general protection faults when the resulting 
> effective address is non- canonical.

Yes. Also, patches 1-2-3 really just do the same thing, one fixes 
the other one. Would be nice to have a single patch for that whole 
ugly topic of 64-bit Xen not handling ISTs properly.

If this was a CPU we'd say "sorry, dont run Linux on it then" ...

I've applied the reservation fix to x86/urgent, and the #5 patch to 
x86/xen (it's more of a cleanup, not a fix for .30, right?).

	Ingo
