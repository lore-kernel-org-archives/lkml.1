Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZKQRmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZKQRmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZKQRmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:42:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbZKQRms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:42:48 -0500
Date: Tue, 17 Nov 2009 09:41:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
In-Reply-To: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009, Uwe Kleine-König wrote:
>
> strcmp("\x01", "\xef") returns 18 but it should return something < 0.
> The reason is that the variable holding the result of the subtraction is
> too small and overflows.

No. The reason is that whoever wrote that function is a moron and doesn't 
know the standard. And your fix is not correct _either_

The comparison should be done as *unsigned char*. As specified by POSIX

  "The sign of a non-zero return value shall be determined by the sign of 
   the difference between the values of the first pair of bytes (both 
   interpreted as type unsigned char) that differ in the strings being 
   compared."

and both the original code and your change gets it wrong in different 
ways.

>  int strcmp(const char *cs, const char *ct)
>  {
> -	signed char __res;
> +	int __res;
>  
>  	while (1) {
>  		if ((__res = *cs - *ct++) != 0 || !*cs++)

So this is fundamentally incorrect both with "signed char __res" _and_ 
with "int __res", because '*cs' and '*ct' are both (possibly - it depends 
on the compiler and architecture) signed chars.

So in the case you mention, strcmp() _should_ return a negative value, 
because "\x01" is smaller than "\xef", but you have:

 - *cs = 1, *ct = (char) 0xef = -17 _OR_ 239 depending on sign of 'char'

and as a result:

 - signed char __res = 18 (incorrect, regardless: ct is larger)

 - int __res = 18 (incorrect) or -238 (correct) depending on sign of char

so your patch doesn't actually help at all.

What would help is something like the appended, but I have not tested it 
AT ALL. It may be total and utter crap too. Maybe it doesn't compile, 
maybe it buggers your pet hedgehog. I just don't know.

		Linus

---
 lib/string.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index b19b87a..e96421a 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -246,13 +246,17 @@ EXPORT_SYMBOL(strlcat);
 #undef strcmp
 int strcmp(const char *cs, const char *ct)
 {
-	signed char __res;
+	unsigned char c1, c2;
 
 	while (1) {
-		if ((__res = *cs - *ct++) != 0 || !*cs++)
+		c1 = *cs++;
+		c2 = *ct++;
+		if (c1 != c2)
+			return c1 < c2 ? -1 : 1;
+		if (!c1)
 			break;
 	}
-	return __res;
+	return 0;
 }
 EXPORT_SYMBOL(strcmp);
 #endif
@@ -266,14 +270,18 @@ EXPORT_SYMBOL(strcmp);
  */
 int strncmp(const char *cs, const char *ct, size_t count)
 {
-	signed char __res = 0;
+	unsigned char c1, c2;
 
 	while (count) {
-		if ((__res = *cs - *ct++) != 0 || !*cs++)
+		c1 = *cs++;
+		c2 = *ct++;
+		if (c1 != c2)
+			return c1 < c2 ? -1 : 1;
+		if (!c1)
 			break;
 		count--;
 	}
-	return __res;
+	return 0;
 }
 EXPORT_SYMBOL(strncmp);
 #endif
