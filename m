Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbYJ0PxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbYJ0PxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJ0PxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:53:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56903 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYJ0PxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:53:01 -0400
Date: Mon, 27 Oct 2008 16:52:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: use a real variable for ftrace_nop in x86
Message-ID: <20081027155244.GR5704@elte.hu>
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com> <20081020162756.GA31201@elte.hu> <20081022070312.GA24749@elte.hu> <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com> <20081024115005.GA5214@elte.hu> <alpine.DEB.1.10.0810240910020.3882@gandalf.stny.rr.com> <alpine.DEB.1.10.0810240916350.3882@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810240916350.3882@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 24 Oct 2008, Steven Rostedt wrote:
> 
> > 
> > The dynamic ftrace determines which nop is safe to use at start up.
> > When it finds a safe nop for patching, it sets a pointer called ftrace_nop
> > to point to the code. All call sites are then patched to this nop.
> > 
> > Later, when tracing is turned on, this ftrace_nop variable is again used
> > to compare the location to make sure it is a nop before we update it to
> > a mcount call. If this fails just once, a warning is outputed and ftrace
> > is disabled.
> > 
> > Rakib Mullick noted that the code that sets up the nop is a .init section
> > where as the nop itself is in the .text section. This is needed because
> > the nop is used later on after boot up. The problem is that the test of the
> > nop jumps back to the setup code and causes a "section mismatch" warning.
> > 
> > Rabik first recommended to convert the nop to .init.text, but as stated
> > above, this would fail since that text is used later.
> > 
> > The real solution is to extend Rabik's patch, and to make the ftrace_nop
> > into an array, and just save the code from the assembly to this array.
> 
> Rereading what I sent, I see I misspelled Rakib's name twice.
> 
> Ingo, could you fix the changelog here before commiting it.

done - find the tip/tracing/urgent commit below. I also added an 
Impact: line.

	Ingo

---------------->
>From 8115f3f0c939c5db0fe3c6c6c58911fd3a205b1e Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 24 Oct 2008 09:12:17 -0400
Subject: [PATCH] ftrace: use a real variable for ftrace_nop in x86

Impact: avoid section mismatch warning, clean up

The dynamic ftrace determines which nop is safe to use at start up.
When it finds a safe nop for patching, it sets a pointer called ftrace_nop
to point to the code. All call sites are then patched to this nop.

Later, when tracing is turned on, this ftrace_nop variable is again used
to compare the location to make sure it is a nop before we update it to
an mcount call. If this fails just once, a warning is printed and ftrace
is disabled.

Rakib Mullick noted that the code that sets up the nop is a .init section
where as the nop itself is in the .text section. This is needed because
the nop is used later on after boot up. The problem is that the test of the
nop jumps back to the setup code and causes a "section mismatch" warning.

Rakib first recommended to convert the nop to .init.text, but as stated
above, this would fail since that text is used later.

The real solution is to extend Rabik's patch, and to make the ftrace_nop
into an array, and just save the code from the assembly to this array.

Now the section can stay as an init section, and we have a nop to use
later on.

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ftrace.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b1e5e22..50ea0ac 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -21,8 +21,7 @@
 #include <asm/nops.h>
 
 
-/* Long is fine, even if it is only 4 bytes ;-) */
-static unsigned long *ftrace_nop;
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -40,7 +39,7 @@ static int ftrace_calc_offset(long ip, long addr)
 
 unsigned char *ftrace_nop_replace(void)
 {
-	return (char *)ftrace_nop;
+	return ftrace_nop;
 }
 
 unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
@@ -125,9 +124,6 @@ int __init ftrace_dyn_arch_init(void *data)
 	 * TODO: check the cpuid to determine the best nop.
 	 */
 	asm volatile (
-		"jmp ftrace_test_jmp\n"
-		/* This code needs to stay around */
-		".section .text, \"ax\"\n"
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
 		"nop\n"
@@ -138,8 +134,6 @@ int __init ftrace_dyn_arch_init(void *data)
 		"jmp 1f\n"
 		"ftrace_test_nop5:"
 		".byte 0x66,0x66,0x66,0x66,0x90\n"
-		"jmp 1f\n"
-		".previous\n"
 		"1:"
 		".section .fixup, \"ax\"\n"
 		"2:	movl $1, %0\n"
@@ -154,15 +148,15 @@ int __init ftrace_dyn_arch_init(void *data)
 	switch (faulted) {
 	case 0:
 		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
-		ftrace_nop = (unsigned long *)ftrace_test_p6nop;
+		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
 		break;
 	case 1:
 		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
-		ftrace_nop = (unsigned long *)ftrace_test_nop5;
+		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
 		break;
 	case 2:
 		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
-		ftrace_nop = (unsigned long *)ftrace_test_jmp;
+		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
 		break;
 	}
 
