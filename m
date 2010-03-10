Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0CJVRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:17:36 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46874 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0CJVRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:17:31 -0500
Date: Wed, 10 Mar 2010 22:17:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] drivers/char/ppdev.c: Use kasprintf
Message-ID: <Pine.LNX.4.64.1003102216510.1672@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/ppdev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/drivers/char/ppdev.c b/drivers/char/ppdev.c
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -286,12 +286,10 @@ static int register_device (int minor, s
 	char *name;
 	int fl;
 
-	name = kmalloc (strlen (CHRDEV) + 3, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, CHRDEV "%x", minor);
 	if (name == NULL)
 		return -ENOMEM;
 
-	sprintf (name, CHRDEV "%x", minor);
-
 	port = parport_find_number (minor);
 	if (!port) {
 		printk (KERN_WARNING "%s: no associated port!\n", name);
