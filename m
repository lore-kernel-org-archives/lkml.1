Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZCRJen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZCRJen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZCRJee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:34:34 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:63890 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZCRJec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:34:32 -0400
Date: Wed, 18 Mar 2009 10:28:25 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Frans Pop <elendil@planet.nl>, linux-s390@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator -
 hang traced
Message-ID: <20090318102825.32c821f3@skybase>
In-Reply-To: <1237344897.6160.136.camel@localhost>
References: <200903080230.10099.elendil@planet.nl>
	<1236817822.7680.148.camel@localhost.localdomain>
	<1236818863.7680.156.camel@localhost.localdomain>
	<200903121805.48041.elendil@planet.nl>
	<1237343170.6160.131.camel@localhost>
	<1237344897.6160.136.camel@localhost>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 19:54:57 -0700
john stultz <johnstul@us.ibm.com> wrote:

> Martin: I'm not sure if the problem here is the __div64_32
> implementation or if the emulator is doing something wrong here. Might
> need some help from you in sorting this out.

__div64_31 is incorrect. Patch and description see below.

How long did you debug this until you finally got down to div64 as the
cause of this? It must have taken you hours!

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

---
Subject: [PATCH] __div64_31 broken for CONFIG_MARCH_G5

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The implementation of __div64_31 for G5 machines is broken. The comments
in __div64_31 are correct, only the code does not do what the comments
say. The part "If the remainder has overflown subtract base and increase
the quotient" is only partially realized, the base is subtracted correctly
but the quotient is only increased if the dividend had the last bit set.
Using the correct instruction fixes the problem.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

diff -urpN linux-2.6/arch/s390/lib/div64.c linux-2.6-patched/arch/s390/lib/div64.c
--- linux-2.6/arch/s390/lib/div64.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/div64.c	2009-03-18 10:06:42.000000000 +0100
@@ -61,7 +61,7 @@ static uint32_t __div64_31(uint64_t *n, 
 		"	clr	%0,%3\n"
 		"	jl	0f\n"
 		"	slr	%0,%3\n"
-		"	alr	%1,%2\n"
+		"	ahi	%1,1\n"
 		"0:\n"
 		: "+d" (reg2), "+d" (reg3), "=d" (tmp)
 		: "d" (base), "2" (1UL) : "cc" );
