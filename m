Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYIEQb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYIEQb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYIEQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:31:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbYIEQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:31:19 -0400
Date: Fri, 5 Sep 2008 09:30:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <200809051138.20615.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0809050916540.3117@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Sep 2008, David Sanders wrote:
>
> The patch disables a optimization used in one place by commenting out some 
> lines in nop.h.  Please comment.

Hmm.. I'm not a huge fan of the ASM_NOP mess, but you also disable it for 
64-bit x86 too.

On 32-bit, at least the generic nops are fairly reasonable, but the 
default nops for 64-bit really look pretty sad, and the P6 nops really do 
look better.

So I would suggest perhaps moving the static P6 nop selection into the 
CONFIG_X86_64 thing.

The alternative is to just get rid of that static nop selection, and just 
have two cases: 32-bit and 64-bit, and just pick obviously safe cases for 
them. 

So I think that particular part would be better off with changing the 
Kconfig language instead. Ie something like this..

(I removed the 32-bit CPU's from the choices, except for MPENTIUM4 that 
really should be merged with MPSC - the difference between MPENTIUM4 and 
MPSC seems to be just a totally bogus 32-bit vs 64-bit thing. Yes, yes, 
there are PENTIUM4's without 64-bit, but there are also Prescott chips 
that run 32-bit kernels, so the thing is a bit confused.

		Linus

---
 arch/x86/Kconfig.cpu |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2c518fb..b225219 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -382,14 +382,17 @@ config X86_OOSTORE
 # P6_NOPs are a relatively minor optimization that require a family >=
 # 6 processor, except that it is broken on certain VIA chips.
 # Furthermore, AMD chips prefer a totally different sequence of NOPs
-# (which work on all CPUs).  As a result, disallow these if we're
-# compiling X86_GENERIC but not X86_64 (these NOPs do work on all
-# x86-64 capable chips); the list of processors in the right-hand clause
-# are the cores that benefit from this optimization.
+# (which work on all CPUs).  In addition, it looks like Virtual PC
+# does not understand them.
+#
+# As a result, disallow these if we're not compiling for X86_64 (these
+# NOPs do work on all x86-64 capable chips); the list of processors in
+# the right-hand clause are the cores that benefit from this optimization.
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)
+	depends on X86_64
+	depends on (MCORE2 || MPENTIUM4 || MPSC)
 
 config X86_TSC
 	def_bool y
