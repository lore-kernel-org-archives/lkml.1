Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZFWT5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZFWT5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZFWT5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:57:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZFWT5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:57:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] asm-generic fixes
Date: Tue, 23 Jun 2009 21:56:45 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Richard Henderson <rth@twiddle.net>
References: <200906231720.38105.arnd@arndb.de> <alpine.LFD.2.01.0906231126460.3240@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906231126460.3240@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906232156.46865.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/C5tWzxI8OtZeIipUCv02mJjFFzfOiVyx5ZE4
 vjv2tAWWHkZxFq4RMGYfVPAS1GOQZOH/Ea9XqNydBNMdeNIdtu
 3SdtjPjjfTCZFhCdiEeVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Linus Torvalds wrote:
> You might need to make 'result', 'carry', and 'w' be 'unsigned int' too.

Yes, you're right.

> Now, it's possible (even likely) that even with a 64-bit word, we'll never 
> actually do large enough areas that 'result' would ever have very many 
> bits set in the 32+ bit region, and since we do end up folding to 16 bits 
> twice (once after the loop and once at the end), it probably gets things 
> right in most cases. But I doubt "probably" is strong enough. Somebody 
> should check.

I think it would overrun only if we have more than 65536 u32 words of
0xffffffff in a single IP packet, on a 64 bit machine. A more obvious
reason to change it is that it relies on from32to16() actually behaving
like a from47to16() function on 64-bit. Changing it to use unsigned int
throughout makes it both more obvious and more consistent between
32 and 64 bit unsigned long types.

> Or just see arch/alpha/lib/checksum.c, which does the whole 64-bit case.
> Maybe lib/checksum.c should be lib/checksum_{32,64}.c.

Mike Frysinger earlier suggested just making the do_csum function optional
in this file because this is the one that most architectures would override.

The alpha code is the only 64-bit platform implementing do_csum in C, so
if Richard wants to use the generic code in its current form, he could simply
override the do_csum implementation.

I've now added these two patches:

commit 217a8c7b6af924379a2083439b4bb606f332e7b1
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jun 23 21:37:26 2009 +0200

    lib/checksum.c: make do_csum optional
    
    Mike Frysinger suggested that do_csum should be optional
    so that an architecture can use the generic checksum code
    but still provide an optimized fast-path for the most
    critical function.
    
    This can mean an implementation using inline assembly,
    or in case of Alpha one using 64-bit arithmetic in C.
    
    Cc: Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/lib/checksum.c b/lib/checksum.c
index 886b48d..b08c2d0 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -37,6 +37,7 @@
 
 #include <asm/byteorder.h>
 
+#ifndef do_csum
 static inline unsigned short from32to16(unsigned int x)
 {
 	/* add up 16-bit and 16-bit for 16+c bit */
@@ -102,6 +103,7 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 out:
 	return result;
 }
+#endif
 
 /*
  *	This is a version of ip_compute_csum() optimized for IP headers,

commit 5cb59758c3e2170b24e9c0d659eb6c03872155c0
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jun 23 21:22:58 2009 +0200

    lib/checksum.c: use 32-bit arithmetic consistently
    
    The use of 'unsigned long' variables in the 32-bit part of do_csum()
    is confusing at best, and potentially broken for long input on 64-bit
    machines.
    
    This changes the code to use 'unsigned int' instead, which makes
    the code behave in the same (correct) way on both 32 and 64 bit
    machines.
    
    Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/lib/checksum.c b/lib/checksum.c
index b2e2fd4..886b48d 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -37,7 +37,7 @@
 
 #include <asm/byteorder.h>
 
-static inline unsigned short from32to16(unsigned long x)
+static inline unsigned short from32to16(unsigned int x)
 {
 	/* add up 16-bit and 16-bit for 16+c bit */
 	x = (x & 0xffff) + (x >> 16);
@@ -49,7 +49,7 @@ static inline unsigned short from32to16(unsigned long x)
 static unsigned int do_csum(const unsigned char *buff, int len)
 {
 	int odd, count;
-	unsigned long result = 0;
+	unsigned int result = 0;
 
 	if (len <= 0)
 		goto out;
@@ -73,9 +73,9 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		}
 		count >>= 1;		/* nr of 32-bit words.. */
 		if (count) {
-			unsigned long carry = 0;
+			unsigned int carry = 0;
 			do {
-				unsigned long w = *(unsigned int *) buff;
+				unsigned int w = *(unsigned int *) buff;
 				count--;
 				buff += 4;
 				result += carry;
