Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbYEFAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbYEFAbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763915AbYEFAbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:31:00 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:51856 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268AbYEFAa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:30:59 -0400
X-ClientAddr: 220.233.82.121
Subject: Re: [PATCH 24/56] microblaze_v2: time support
From: John Williams <john.williams@petalogix.com>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <481F1830.5090309@seznam.cz>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
	 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
	 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
	 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
	 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
	 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
	 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
	 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
	 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
	 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
	 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
	 <1209953949.5798.66.camel@localhost>  <481F1830.5090309@seznam.cz>
Content-Type: multipart/mixed; boundary="=-BT3czlA/9k1udLOfRU6g"
Organization: PetaLogix
Date: Tue, 06 May 2008 10:30:11 +1000
Message-Id: <1210033811.5798.188.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BT3czlA/9k1udLOfRU6g
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Michal,

On Mon, 2008-05-05 at 16:22 +0200, Michal Simek wrote:
> Hi John,
> 
> you wrote me you have smarter implementation that xilinx did. Can you find it
> and send me it?

It's not much (any?) better?  One less multiply I think?  Attached
anyway - feel free to discard for now.

We could do a nice asm implementation with the optional mulhi
instruction, but that can wait.

Cheers,

John


--=-BT3czlA/9k1udLOfRU6g
Content-Disposition: attachment; filename=delay-improvement.patch
Content-Type: text/x-patch; name=delay-improvement.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/include/asm-microblaze/delay.h b/include/asm-microblaze/delay.h
index 481359c..e29a4de 100644
--- a/include/asm-microblaze/delay.h
+++ b/include/asm-microblaze/delay.h
@@ -2,32 +2,72 @@
  * include/asm-microblaze/delay.h
  *
  * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
+ * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
  * Copyright (C) 2006 Atmark Techno, Inc.
  */
 
-#ifndef _ASM_MICROBLAZE_DELAY_H
-#define _ASM_MICROBLAZE_DELAY_H
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
 
-#include <asm/param.h>
+#include <asm/param.h>		/* For HZ */
 
-static inline void __delay(unsigned long loops)
+extern inline void __delay(unsigned long loops)
 {
 	asm volatile ("# __delay		\n\t"		\
-			"1: addi	%0, %0, -1 \t\n"	\
-			"bneid	%0, 1b		\t\n"		\
-			"nop			\t\n"
-			: "=r" (loops)
-			: "0" (loops));
+		      "1: addi	%0, %0, -1	\t\n"		\
+		      "bneid	%0, 1b		\t\n"		\
+		      "nop			\t\n"
+		      : "=r" (loops)
+		      : "0" (loops));
 }
 
-static inline void udelay(unsigned long usec)
+/*
+ * Note that 19 * 226 == 4294 ==~ 2^32 / 10^6, so
+ * loops = (4294 * usecs * loops_per_jiffy * HZ) / 2^32.
+ *
+ * The mul instruction gives us loops = (a * b) / 2^32.
+ * We choose a = usecs * 19 * HZ and b = loops_per_jiffy * 226
+ * because this lets us support a wide range of HZ and
+ * loops_per_jiffy values without either a or b overflowing 2^32.
+ * Thus we need usecs * HZ <= (2^32 - 1) / 19 = 226050910 and
+ * loops_per_jiffy <= (2^32 - 1) / 226 = 19004280
+ * (which corresponds to ~3800 bogomips at HZ = 100).
+ *  -- paulus
+ */
+#define __MAX_UDELAY	(226050910UL/HZ)	/* maximum udelay argument */
+#define __MAX_NDELAY	(4294967295UL/HZ)	/* maximum ndelay argument */
+
+extern unsigned long loops_per_jiffy;
+
+extern __inline__ void __udelay(unsigned int x)
 {
-	unsigned long long tmp = usec;
-	unsigned long loops = (tmp * 4295 * HZ * loops_per_jiffy) >> 32;
+	unsigned long long tmp=(unsigned long long)x*(unsigned long long)loops_per_jiffy*226LL;
+	unsigned loops=tmp>>32;
+
 	__delay(loops);
 }
 
-#endif /* _ASM_MICROBLAZE_DELAY_H */
+extern __inline__ void __ndelay(unsigned int x)
+{
+	unsigned long long tmp=(unsigned long long)x*(unsigned long long)loops_per_jiffy*226LL;
+	unsigned loops=tmp>>32;
+
+	__delay(loops);
+}
+
+extern void __bad_udelay(void);		/* deliberately undefined */
+extern void __bad_ndelay(void);		/* deliberately undefined */
+
+#define udelay(n) (__builtin_constant_p(n)? \
+	((n) > __MAX_UDELAY? __bad_udelay(): __udelay((n) * (19 * HZ))) : \
+	__udelay((n) * (19 * HZ)))
+
+#define ndelay(n) (__builtin_constant_p(n)? \
+	((n) > __MAX_NDELAY? __bad_ndelay(): __ndelay((n) * HZ)) : \
+	__ndelay((n) * HZ))
+
+#define muldiv(a, b, c)    (((a)*(b))/(c))
+
+#endif /* _ASM_DELAY_H */

--=-BT3czlA/9k1udLOfRU6g--

