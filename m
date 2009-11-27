Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZK0P3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZK0P3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZK0P3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:29:06 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:10949 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZK0P3E convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 27 Nov 2009 10:29:04 -0500
Message-Id: <4B0FFE56020000780002272B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 27 Nov 2009 15:29:10 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/alternatives: check replacementlen <= instrlen
	 at build time
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jan Beulich 27.11.09 16:04 >>>
>Having run into the run-(boot-)time check a couple of times lately, I
>finally took time to find a build-time check so that one doesn't need
>to analyze the register/stack dump and resolve this (through manual
>lookup in vmlinux) to the offending construct. The assembler will emit
>a message like "Error: value of <num> too large for field of 1 bytes
>at <offset>", which while not pointing out the source location still
>makes analysis quite a bit easier.
>
>Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
>---
> arch/x86/include/asm/alternative.h     |    1 +
> 1 files changed, 1 insertion(+)
>
>--- linux-2.6.32-rc8/arch/x86/include/asm/alternative.h
>+++ 2.6.32-rc8-x86-alternative/arch/x86/include/asm/alternative.h
>@@ -84,6 +84,7 @@ static inline void alternatives_smp_swit
>       "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
>       "	 .byte 662b-661b\n"			/* sourcelen       */	\
>       "	 .byte 664f-663f\n"			/* replacementlen  */	\
>+      "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
>       ".previous\n"							\
>       ".section .altinstr_replacement, \"ax\"\n"			\
>       "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\

This really is only one of several possible ways to do the check, and while
looking at this construct I realized that it would need some more extensive
changes. The primary issue is that the number of feature bits already
exceeds 256, and hence using a byte to store the bit number is no longer
sufficient (at least as soon as someone wants to make an alternative
depend on one of these high numbered bits).

The question is whether playing with the field sizes here is generally
compatible, since the module symbol CRCs will not catch old (out-of-tree)
modules using the current format once the format got changed. While
this may not be of significant concern, once touching the layout I'd want
to re-assign the meaning and/or sizes of some of the other fields, too.
Hence, these changes should ideally all happen together, so that the
negative effect on external modules can be minimized. Therefore, before
submitting an all-in-one patch (or a series of patches), I'd like to
understand whether the following changes would be acceptable:

1) As said, widen the feature field to a word.
2) Rather than storing original and replacement lengths, store original
lenght and a biased delta, so that the checking above patch implements
becomes an integral part of the data stored. The goal is to avoid growth
of the structure on 32-bits.
3) Rather than storing absolute pointers to original and replacement
instructions, use relative ones so that the size of the 64-bit variant of
the structure can be shrunk to the same as the 32-bit one.
4) Rather than using numeric labels in the inline assembly string, use gcc's
%= format specifier to get truely unique labels.

Items 3 and 4 should probably also be applied to the LOCK_PREFIX
definition.

Finally, in order to have changes to the data format used here prevent
old modules from loading (namely for distros which try to ensure kABI
invariance), I wonder whether a pseudo dependency similar to the
module_layout one shouldn't be introduced for modules using any of
the alternative constructs.

Jan

