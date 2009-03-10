Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZCJMT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZCJMT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZCJMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:19:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbZCJMTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:19:14 -0400
Date: Tue, 10 Mar 2009 12:18:32 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sitsofe@yahoo.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sitsofe@yahoo.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <20090309201503.GA5010@nowhere>
References: <20090309201503.GA5010@nowhere>
Subject: [tip:core/printk] vsprintf: fix bug in negative value printing
Message-ID: <tip-39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78@git.kernel.org>
Git-Commit-ID: 39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 12:18:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78
Gitweb:     http://git.kernel.org/tip/39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78
Author:     "Frederic Weisbecker" <fweisbec@gmail.com>
AuthorDate: Mon, 9 Mar 2009 21:15:04 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 13:15:06 +0100

vsprintf: fix bug in negative value printing

Sitsofe Wheeler found and bisected that while unifying the
vsprintf format decoding in:

  fef20d9: vsprintf: unify the format decoding layer for its 3 users

The sign flag has been dropped out in favour of
precise types (ie: LONG/ULONG).

But the format helper number() still needs this flag to keep track of
the signedness unless it will consider all numbers as unsigned.

Also add an explicit cast to int (for %d) while parsing with va_arg()
to ensure the highest bit is well extended on the 64 bits number that
hosts the value in case of negative values.

Reported-Bisected-Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090309201503.GA5010@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
