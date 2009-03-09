Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZCIUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZCIUP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZCIUPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:15:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:53434 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZCIUPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OSU8fBZss4MyW5wC5U/M/XGxo0ij1P+ZUe/tMg5irsIYouejTK02gk7Eg4GPTqcV4N
         MI2znVtTfTtHrcwA/reeBCzsqQIYw36OGsO90QOXYnutUK0OWITcIOqgKaZvf4tWtw6z
         hg1M69hPRAvBkmTSzlgNRCAOTrljbJgfjM6BU=
Date: Mon, 9 Mar 2009 21:15:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive
	numbers
Message-ID: <20090309201503.GA5010@nowhere>
References: <20090308231850.GB24445@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308231850.GB24445@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 11:18:50PM +0000, Sitsofe Wheeler wrote:
> (Forgot to cc lkml. Resending...)
> 
> Formally negative nice values have started become very big in positive
> integers in -tip kernels:
> 
>     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    


The weird thing here is that number: 2147483647
It is 0xefffffff
Which means -1 without the highest bit (the sign).
I really don't know how it could have happened.

Anyway, I caught something in the signedness bits from my patch that unifies
the format decoding.
I've never seen your bug on my machine. But I note you have a 32 bits CPU.
Mine is 64 bits with a 64 bits kernel. Perhaps some weird signedness related things
happened because of the signedness bug that the following patch fixes.

Since there are no negative values in my dmesg, I did not catch this bug until now
(and my top output is normal).

Can you please give it a try?

Thanks a lot!

---
>From df7f96a703e15a995620813f1397a01d9000bbe8 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 9 Mar 2009 21:10:15 +0100
Subject: [PATCH] vsprintk: keep track of signedness

While unifying the format decoding, the sign flag has been dropped out in
favour of precise types (ie: LONG/ULONG).
But the format helper number() still needs this flag to keep track of the
signedness unless it will consider all numbers as unsigned.

Also add an explicit cast to int (for %d) while parsing with va_arg()
to ensure the highest bit is well extended on the 64 bits number that hosts the
value in case of negative values.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 25f0157..dc16743 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -768,7 +768,6 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 static int format_decode(const char *fmt, struct printf_spec *spec)
 {
 	const char *start = fmt;
-	bool sign = false;
 
 	/* we finished early by reading the field width */
 	if (spec->type == FORMAT_TYPE_WITDH) {
@@ -900,7 +899,7 @@ qualifier:
 
 	case 'd':
 	case 'i':
-		sign = true;
+		spec->flags |= SIGN;
 	case 'u':
 		break;
 
@@ -912,7 +911,7 @@ qualifier:
 	if (spec->qualifier == 'L')
 		spec->type = FORMAT_TYPE_LONG_LONG;
 	else if (spec->qualifier == 'l') {
-		if (sign)
+		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_LONG;
 		else
 			spec->type = FORMAT_TYPE_ULONG;
@@ -921,12 +920,12 @@ qualifier:
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
 	} else if (spec->qualifier == 'h') {
-		if (sign)
+		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_SHORT;
 		else
 			spec->type = FORMAT_TYPE_USHORT;
 	} else {
-		if (sign)
+		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_INT;
 		else
 			spec->type = FORMAT_TYPE_UINT;
@@ -1101,8 +1100,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			case FORMAT_TYPE_SHORT:
 				num = (short) va_arg(args, int);
 				break;
-			case FORMAT_TYPE_UINT:
-				num = va_arg(args, unsigned int);
+			case FORMAT_TYPE_INT:
+				num = (int) va_arg(args, int);
 				break;
 			default:
 				num = va_arg(args, unsigned int);
-- 
1.6.1


