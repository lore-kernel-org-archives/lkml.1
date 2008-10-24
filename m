Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYJXMUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYJXMUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYJXMUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:20:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYJXMUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:20:00 -0400
Date: Fri, 24 Oct 2008 08:19:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] ftrace : Fix section mismatch warning.
In-Reply-To: <20081024115005.GA5214@elte.hu>
Message-ID: <alpine.DEB.1.10.0810240802070.25677@gandalf.stny.rr.com>
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com> <20081020162756.GA31201@elte.hu> <20081022070312.GA24749@elte.hu> <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com> <20081024115005.GA5214@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Oct 2008, Ingo Molnar wrote:

> 
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
> 
> > Does the following solves the problem?
> > Thanks.
> > 
> > --- linux-2.6-orig/arch/x86/kernel/ftrace.c	2008-10-24 16:35:48.000000000 +0600
> > +++ linux-2.6/arch/x86/kernel/ftrace.c	2008-10-24 16:40:09.000000000 +0600
> > @@ -129,7 +129,7 @@ int __init ftrace_dyn_arch_init(void *da
> >  	asm volatile (
> >  		"jmp ftrace_test_jmp\n"
> >  		/* This code needs to stay around */
> > -		".section .text, \"ax\"\n"
> > +		".section .text.init, \"ax\"\n"
> 
> how about the "This code needs to stay around" comment?

Yes that is correct. That part can not be converted into .init.
The code is used later at run time when the tracer is enabled and we
patch the code back to a call to mcount. We use this code as to know what
we should expect should be at the nop locations. But that code is used 
later as data and not exectude, which means that we do not need to worry 
about it calling back into the .init section.

If you only want to get rid of the section mismatch warning. Just remove 
the __init from the "ftrace_dyn_arch_init" function. But then we are just 
wasting those bytes that will never be used again.

The real solution should probably be this:

(Compiled tested only)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-23 19:23:28.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-24 08:11:57.000000000 -0400
@@ -22,7 +22,7 @@
 
 
 /* Long is fine, even if it is only 4 bytes ;-) */
-static unsigned long *ftrace_nop;
+static unsigned long ftrace_nop[MCOUNT_INSN_SIZE];
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -126,8 +126,7 @@ int __init ftrace_dyn_arch_init(void *da
 	 */
 	asm volatile (
 		"jmp ftrace_test_jmp\n"
-		/* This code needs to stay around */
-		".section .text, \"ax\"\n"
+		".section .text.init, \"ax\"\n"
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
 		"nop\n"
@@ -154,15 +153,15 @@ int __init ftrace_dyn_arch_init(void *da
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
 
