Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZAHJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZAHJvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZAHJvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:51:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:33198 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZAHJu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=VGS/I0OYiO31md3IjKPn1hBdwN1TZrAtSaaMxXvf8vI3R8FlzO+yFr8Qq87EBd/Y4Q
         4rxwb/Q6ufr9U3ezPdZ6fZqpIuKoMCbOXhA0adHGtBZbZUj3Yn1xdDfGiOL1qGO1qnu2
         tq5Kwf12RHpAcnU3kMBM3PSun2Z3VzUwSudDE=
Message-ID: <8447d6730901080150r3f51c758l4d4b74cdaaf9d09c@mail.gmail.com>
Date: Thu, 8 Jan 2009 10:50:56 +0100
From: "Davide Rizzo" <elpa.rizzo@gmail.com>
To: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       ben-linux@fluff.org
Subject: [PATCH 3/3] Driver for user access to internal clocks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a proposal for adding 2 functions to clk interface to allow higher
 level drivers to enumerate and list all clocks.
There is also the implementation for Samsung S3C24xx platform.

Signed-off-by: Davide Rizzo <elpa-rizzo@gmail.com>
---
diff -urNp linux-2.6.28/arch/arm/plat-s3c24xx/clock.c
linux-2.6.28.elpa/arch/arm/plat-s3c24xx/clock.c
--- linux-2.6.28/arch/arm/plat-s3c24xx/clock.c	2008-12-25
00:26:37.000000000 +0100
+++ linux-2.6.28.elpa/arch/arm/plat-s3c24xx/clock.c	2009-01-07
19:25:07.000000000 +0100
@@ -422,6 +433,42 @@ static int s3c24xx_clkout_setparent(stru
 	return 0;
 }

+int clk_for_each(int(*fn)(struct clk *, void *), void *data)
+{
+	struct clk *clk;
+	int ret = 0;
+
+	list_for_each_entry(clk, &clocks, list)
+	{
+		ret = fn(clk, data);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(clk_for_each);
+
+/* Must be deallocated with kfree() */
+const char *clk_get_name(struct clk *clk)
+{
+	char *s;
+	int len;
+
+	if (IS_ERR(clk))
+		return ERR_PTR(-EINVAL);
+
+	len = strlen(clk->name) + 8;
+	s = kmalloc(len, GFP_KERNEL);
+	if (!s)
+		return ERR_PTR(-ENOMEM);
+	if (clk->id == -1)
+		strlcpy(s, clk->name, len);
+	else if (snprintf(s, len, "%s.%d", clk->name, clk->id) > len)
+		s[len - 1] = '\0';
+	return s;
+}
+EXPORT_SYMBOL(clk_get_name);
+
 /* external clock definitions */

 struct clk s3c24xx_dclk0 = {
diff -urNp linux-2.6.28/include/linux/clk.h
linux-2.6.28.elpa/include/linux/clk.h
--- linux-2.6.28/include/linux/clk.h	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28.elpa/include/linux/clk.h	2009-01-07 19:06:46.000000000 +0100
@@ -125,4 +125,22 @@ int clk_set_parent(struct clk *clk, stru
  */
 struct clk *clk_get_parent(struct clk *clk);

+/**
+ * clk_for_each - calls fn, iterating between registered clocks
+ * @fn: function to be called, passing each clk structure in 1st argument
+ * @data: 2nd argument to pass to fn function
+ *
+ * Returns 0 or the called fn return code if != 0
+ */
+int clk_for_each(int(*fn)(struct clk *, void *), void *data);
+
+/**
+ * clk_name - get clock name
+ * @clk: clock source
+ *
+ * Returns clock's name that must be deallocated with kfree(), or valid
+ * IS_ERR() condition containing errno.
+ */
+const char *clk_get_name(struct clk *clk);
+
 #endif
