Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZKQRNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZKQRNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZKQRNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:13:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51357 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZKQRNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:13:30 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] strcmp: fix overflow error
Date: Tue, 17 Nov 2009 17:51:40 +0100
Message-Id: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strcmp("\x01", "\xef") returns 18 but it should return something < 0.
The reason is that the variable holding the result of the subtraction is
too small and overflows.

As strcmp is e.g. used to access data in squashfs this might result in
not finding files.

The same problem is fixed in strncmp.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Hello,

I didn't hit this problem in the wild, only when checking for something
else.  Is this stable material anyhow?

Best regards
Uwe

 lib/string.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index b19b87a..661ff06 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -246,7 +246,7 @@ EXPORT_SYMBOL(strlcat);
 #undef strcmp
 int strcmp(const char *cs, const char *ct)
 {
-	signed char __res;
+	int __res;
 
 	while (1) {
 		if ((__res = *cs - *ct++) != 0 || !*cs++)
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(strcmp);
  */
 int strncmp(const char *cs, const char *ct, size_t count)
 {
-	signed char __res = 0;
+	int __res = 0;
 
 	while (count) {
 		if ((__res = *cs - *ct++) != 0 || !*cs++)
-- 
1.6.5.2

