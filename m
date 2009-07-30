Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbZG3OBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbZG3OBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZG3OBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:01:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41457 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbZG3OBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:01:34 -0400
Date: Thu, 30 Jul 2009 16:00:33 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/video: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0907301559530.8734@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/au1100fb.c            |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index 378f277..1766846 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -716,6 +716,10 @@ int au1100fb_setup(char *options)
 			/* Mode option (only option that start with digit) */
 			else if (isdigit(this_opt[0])) {
 				mode = kmalloc(strlen(this_opt) + 1, GFP_KERNEL);
+				if (!mode) {
+					print_err("memory allocation failed");
+					return -ENOMEM;
+				}
 				strncpy(mode, this_opt, strlen(this_opt) + 1);
 			}
 			/* Unsupported option */
