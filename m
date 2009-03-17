Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZCQMUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZCQMUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZCQMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:19:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:51070 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZCQMT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dR4VUH5I4pidRPTvKB9pqYUEZD7pU9yZgcrfMCi6QzDY7zUafzukaMydbbBLA7+EXG
         1tvijeGqS83gk87vciZPcQbC/om+38DtHJYq2529BHIk2NgjSsIknGCTD6uEa/SpLNY6
         te29F8nGfnvpbuZzMyU7lPfDOKJKRfSsqXxqU=
Message-ID: <49BF956B.9030109@gmail.com>
Date: Tue, 17 Mar 2009 13:19:55 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] hvc_console: prevent wrapping in hvc_console_print()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was found by code analysis, is it needed?
------------------------------>8-------------8<---------------------------------
If we subtract too much on unsigned i it wraps.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 94e7e3c..d06313c 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -161,10 +161,10 @@ static void hvc_console_print(struct console *co, const char *b,
 			}
 		} else {
 			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
-			if (r <= 0) {
+			if (r <= 0 || r > i) {
 				/* throw away chars on error */
 				i = 0;
-			} else if (r > 0) {
+			} else {
 				i -= r;
 				if (i > 0)
 					memmove(c, c+r, i);
