Return-Path: <linux-kernel-owner+w=401wt.eu-S965973AbXCFRMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973AbXCFRMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965971AbXCFRMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:12:40 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:42032 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965967AbXCFRMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:12:31 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch v2] epoll use a single inode ...
Date: Tue, 6 Mar 2007 18:12:28 +0100
User-Agent: KMail/1.9.5
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <45ED08A9.9050501@cosmosbay.com> <45ED96A6.3000704@zytor.com>
In-Reply-To: <45ED96A6.3000704@zytor.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8Da7FhdfOrYC6As"
Message-Id: <200703061812.28478.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8Da7FhdfOrYC6As
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 06 March 2007 17:28, H. Peter Anvin wrote:
> Eric Dumazet wrote:
> > For epoll, I suspect this is harmless : Programs dont allocate epolls fd
> > every milli second, but at startup only.
> >
> > For pipes/sockets, using a 64 bits would be problematic, because
> > sprintf() uses a divide for each digit. And a divide is slow. Ten
> > divides are *very* slow.
>
> That's true for *any* sprintf(), though.  sprintf() converts all its
> arguments to 64 bits.
>
> However, this could be optimized.  I think right now sprintf() uses a
> generic divide-by-base, but a divide by 8 and 16 can of course be
> handled with a shift, and divide by 10 can be replaced with a
> multiplication by 0x1999999999999999ULL on most architectures.

Or maybe just use reciprocal division, to keep the  35 bases available in 
number() 

Something like :

[PATCH] : Use reciprocal divides in sprintf()

pipe() syscalls spend a noticeable amount of time in sprintf() to format their 
dentry name. One name may want to print 9 or 10 digits, using one divide per 
digit.

Using reciprocal divides permits to change each divide by two multiplies, less 
expensive on current CPUS.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--Boundary-00=_8Da7FhdfOrYC6As
Content-Type: text/plain;
  charset="iso-8859-1";
  name="reciprocal_divide_in_sprintf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="reciprocal_divide_in_sprintf.patch"

diff --git a/include/linux/reciprocal_div.h b/include/linux/reciprocal_div.h
index f9c90b3..55a79e0 100644
--- a/include/linux/reciprocal_div.h
+++ b/include/linux/reciprocal_div.h
@@ -23,7 +23,10 @@ #include <linux/types.h>
  * or else the performance is slower than a normal divide.
  */
 extern u32 reciprocal_value(u32 B);
-
+/*
+ * precomputed reciprocal values of integers from 0 to 36
+ */
+extern const u32 reciprocal_values[36 + 1];
 
 static inline u32 reciprocal_divide(u32 A, u32 R)
 {
diff --git a/lib/reciprocal_div.c b/lib/reciprocal_div.c
index 6a3bd48..2dcea45 100644
--- a/lib/reciprocal_div.c
+++ b/lib/reciprocal_div.c
@@ -1,6 +1,31 @@
 #include <asm/div64.h>
 #include <linux/reciprocal_div.h>
 
+#define CONSTANT_RECIPROCAL_VALUE(k) \
+	(u32)(((1LL << 32) + (k - 1)) / k)
+
+const u32 reciprocal_values[36 + 1] = {
+	0,
+	CONSTANT_RECIPROCAL_VALUE(1),	CONSTANT_RECIPROCAL_VALUE(2),
+	CONSTANT_RECIPROCAL_VALUE(3),	CONSTANT_RECIPROCAL_VALUE(4),
+	CONSTANT_RECIPROCAL_VALUE(5),	CONSTANT_RECIPROCAL_VALUE(6),
+	CONSTANT_RECIPROCAL_VALUE(7),	CONSTANT_RECIPROCAL_VALUE(8),
+	CONSTANT_RECIPROCAL_VALUE(9),	CONSTANT_RECIPROCAL_VALUE(10),
+	CONSTANT_RECIPROCAL_VALUE(11),	CONSTANT_RECIPROCAL_VALUE(12),
+	CONSTANT_RECIPROCAL_VALUE(13),	CONSTANT_RECIPROCAL_VALUE(14),
+	CONSTANT_RECIPROCAL_VALUE(15),	CONSTANT_RECIPROCAL_VALUE(16),
+	CONSTANT_RECIPROCAL_VALUE(17),	CONSTANT_RECIPROCAL_VALUE(18),
+	CONSTANT_RECIPROCAL_VALUE(19),	CONSTANT_RECIPROCAL_VALUE(20),
+	CONSTANT_RECIPROCAL_VALUE(21),	CONSTANT_RECIPROCAL_VALUE(22),
+	CONSTANT_RECIPROCAL_VALUE(23),	CONSTANT_RECIPROCAL_VALUE(24),
+	CONSTANT_RECIPROCAL_VALUE(25),	CONSTANT_RECIPROCAL_VALUE(26),
+	CONSTANT_RECIPROCAL_VALUE(27),	CONSTANT_RECIPROCAL_VALUE(28),
+	CONSTANT_RECIPROCAL_VALUE(29),	CONSTANT_RECIPROCAL_VALUE(30),
+	CONSTANT_RECIPROCAL_VALUE(31),	CONSTANT_RECIPROCAL_VALUE(32),
+	CONSTANT_RECIPROCAL_VALUE(33),	CONSTANT_RECIPROCAL_VALUE(34),
+	CONSTANT_RECIPROCAL_VALUE(35),	CONSTANT_RECIPROCAL_VALUE(36),
+};
+
 u32 reciprocal_value(u32 k)
 {
 	u64 val = (1LL << 32) + (k - 1);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b025864..9c98cc4 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -22,6 +22,7 @@ #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
+#include <linux/reciprocal_div.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -180,8 +181,16 @@ static char * number(char * buf, char * 
 	i = 0;
 	if (num == 0)
 		tmp[i++]='0';
-	else while (num != 0)
-		tmp[i++] = digits[do_div(num,base)];
+	else {
+		while (num >> 32)
+			tmp[i++] = digits[do_div(num,base)];
+		while (num != 0) {
+			u32 next = reciprocal_divide((u32)num,
+				reciprocal_values[base]);
+			tmp[i++] = digits[num - next*base];
+			num = next;
+		}
+	}
 	if (i > precision)
 		precision = i;
 	size -= precision;

--Boundary-00=_8Da7FhdfOrYC6As--
