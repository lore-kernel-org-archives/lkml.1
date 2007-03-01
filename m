Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXCAANL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXCAANL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932813AbXCAANL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:13:11 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:40286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbXCAANK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:13:10 -0500
Subject: [PATCH] make sscanf honor %n at end of input string
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 01:12:31 +0100
Message-Id: <1172707951.11911.3.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was playing with some code that sometimes got a string where a %n
match should have been done where the input string ended, for example
like this:

  sscanf("abc123", "abc%d%n", &a, &n);

However, the scanf function in the kernel doesn't convert the %n in that
case because it has already matched the complete input after %d. This
patch changes that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Shrug. My use case for this collapsed, but I figured having scanf doing
that correctly might be a good thing.

 lib/vsprintf.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- wireless-dev.orig/lib/vsprintf.c	2007-03-01 00:28:31.776381760 +0100
+++ wireless-dev/lib/vsprintf.c	2007-03-01 00:59:33.256381760 +0100
@@ -825,6 +825,15 @@ int vsscanf(const char * buf, const char
 			break;
 		str = next;
 	}
+
+	/* Now we've come all the way through so either the input string or
+	 * the format ended. In the former case, there can be a %n at the
+	 * current position in the format that needs to be filled. */
+	if (*fmt == '%' && *(fmt+1) == 'n') {
+		int *i = (int *)va_arg(args,int*);
+		*i = str - buf;
+	}
+
 	return num;
 }
 


