Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZCRCzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZCRCzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZCRCzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:55:03 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43026 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCRCzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:55:01 -0400
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator -
 hang traced
From: john stultz <johnstul@us.ibm.com>
To: Frans Pop <elendil@planet.nl>, schwidefsky@de.ibm.com
Cc: linux-s390@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1237343170.6160.131.camel@localhost>
References: <200903080230.10099.elendil@planet.nl>
	 <1236817822.7680.148.camel@localhost.localdomain>
	 <1236818863.7680.156.camel@localhost.localdomain>
	 <200903121805.48041.elendil@planet.nl>
	 <1237343170.6160.131.camel@localhost>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 19:54:57 -0700
Message-Id: <1237344897.6160.136.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 19:26 -0700, john stultz wrote:
> So two issues that I've found so far:
> 1) do_div() isn't dividing correctly in this case. Not sure why.

Patch to prove this is part of the issue below. Disables the s390
specific __div64_32() implementation and uses the generic code.

Frans: Mind giving this a try to verify the issue goes away with this?

Martin: I'm not sure if the problem here is the __div64_32
implementation or if the emulator is doing something wrong here. Might
need some help from you in sorting this out.



> 2) We *really* shouldn't be using oneshot mode while the jiffies
> clocksource is in use. I believe x86 avoids this specifically, so I'm
> not sure why s390 isn't doing the same. Still have to investigate.

Still working this.

thanks
-john


diff --git a/arch/s390/lib/div64.c b/arch/s390/lib/div64.c
index a5f8300..6c249fa 100644
--- a/arch/s390/lib/div64.c
+++ b/arch/s390/lib/div64.c
@@ -68,7 +68,7 @@ static uint32_t __div64_31(uint64_t *n, uint32_t base)
 	words[1] = reg3;
 	return reg2;
 }
-
+#if 0
 /*
  * Function to divide an unsigned 64 bit integer by an unsigned
  * 32 bit integer using the unsigned 64/31 bit division.
@@ -123,9 +123,9 @@ uint32_t __div64_32(uint64_t *n, uint32_t base)
 	}
 	return r;
 }
-
+#endif
 #else /* MARCH_G5 */
-
+#if 0
 uint32_t __div64_32(uint64_t *n, uint32_t base)
 {
 	register uint32_t reg2 asm("2");
@@ -145,5 +145,5 @@ uint32_t __div64_32(uint64_t *n, uint32_t base)
 	words[1] = reg3;
 	return reg2;
 }
-
+#endif
 #endif /* MARCH_G5 */


