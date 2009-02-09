Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZBIRy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZBIRy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZBIRyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:54:17 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:62851 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZBIRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PAJ1iyNGl4sMADvu/QOEynzC4a2xjQz/OA4L9FaYJvvN3L0LFS5tqlJ/2IY8GSjx4i
         A37i8s2TAmAADQPqjk69bTuRDyKlOtGJX2z4Y1KHC7MEvibqboa7oI/VYGGGwJEdJD3f
         HSWu1q8wQ6PEmbzsY2fIVxHk+ISTWzQzWK3AQ=
MIME-Version: 1.0
In-Reply-To: <8447d6730901281117g3a8b7ddfp26e937111b6b6304@mail.gmail.com>
References: <8447d6730901080149l4146139an9fad00fd88d72fb9@mail.gmail.com>
	 <20090108112741.GA3053@local>
	 <8447d6730901080806r238354c7u81071a28d8b483ff@mail.gmail.com>
	 <20090108163024.GB26413@suse.de>
	 <8447d6730901281117g3a8b7ddfp26e937111b6b6304@mail.gmail.com>
Date: Mon, 9 Feb 2009 18:54:12 +0100
Message-ID: <8447d6730902090954p454a3310o3fc2f5fefbde04f7@mail.gmail.com>
Subject: [PATCH 2/2] Driver for user access to internal clocks
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Cc: ben-linux@fluff.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a proposal for adding 2 functions to clk interface to allow higher
 level drivers to enumerate and list all clocks, and to modify clk_get
 to accept device specific clk names in the form "name.id"
There is also the implementation for Samsung S3C24xx platform.

Signed-off-by: Davide Rizzo <elpa.rizzo@gmail.com>
---diff -urpN linux-2.6.29-rc2/arch/arm/plat-s3c/clock.c
linux-2.6.29-rc2.elpa/arch/arm/plat-s3c/clock.c
--- linux-2.6.29-rc2/arch/arm/plat-s3c/clock.c  2009-01-17
11:32:38.000000000 +0100
+++ linux-2.6.29-rc2.elpa/arch/arm/plat-s3c/clock.c     2009-01-28
19:32:08.000000000 +0100
@@ -69,11 +69,19 @@ static int clk_null_enable(struct clk *c

 struct clk *clk_get(struct device *dev, const char *id)
 {
+       long idno;
+       char *name = (char *)id;
+       char *dotpos = strrchr(id, '.');
       struct clk *p;
       struct clk *clk = ERR_PTR(-ENOENT);
-       int idno;

-       if (dev == NULL || dev->bus != &platform_bus_type)
+       if (dotpos) {
+               int err = strict_strtol(dotpos + 1, 10, &idno);
+               if (err)
+                               return ERR_PTR(err);
+               name = kstrdup(id, GFP_KERNEL);
+               name[dotpos - id] = '\0';
+       } else if (dev == NULL || dev->bus != &platform_bus_type)
               idno = -1;
       else
               idno = to_platform_device(dev)->id;
@@ -82,7 +90,7 @@ struct clk *clk_get(struct device *dev,

       list_for_each_entry(p, &clocks, list) {
               if (p->id == idno &&
-                   strcmp(id, p->name) == 0 &&
+                   strcmp(name, p->name) == 0 &&
                   try_module_get(p->owner)) {
                       clk = p;
                       break;
@@ -94,7 +102,7 @@ struct clk *clk_get(struct device *dev,

       if (IS_ERR(clk)) {
               list_for_each_entry(p, &clocks, list) {
-                       if (p->id == -1 && strcmp(id, p->name) == 0 &&
+                       if (p->id == -1 && strcmp(name, p->name) == 0 &&
                           try_module_get(p->owner)) {
                               clk = p;
                               break;
@@ -103,6 +111,8 @@ struct clk *clk_get(struct device *dev,
       }

       spin_unlock(&clocks_lock);
+       if (dotpos)
+               kfree(name);
       return clk;
 }

@@ -222,6 +232,42 @@ EXPORT_SYMBOL(clk_set_rate);
 EXPORT_SYMBOL(clk_get_parent);
 EXPORT_SYMBOL(clk_set_parent);

+int clk_for_each(int(*fn)(struct clk *, void *), void *data)
+       {
+       struct clk *clk;
+       int ret = 0;
+
+       list_for_each_entry(clk, &clocks, list)
+       {
+               ret = fn(clk, data);
+               if (ret)
+                       break;
+       }
+       return ret;
+}
+EXPORT_SYMBOL(clk_for_each);
+
+/* Returned pointer must be deallocated with kfree() */
+const char *clk_get_name(struct clk *clk)
+{
+       char *s;
+       int len;
+
+       if (IS_ERR(clk))
+               return ERR_PTR(-EINVAL);
+
+       len = strlen(clk->name) + 8;
+       s = kmalloc(len, GFP_KERNEL);
+       if (!s)
+               return ERR_PTR(-ENOMEM);
+       if (clk->id == -1)
+               strlcpy(s, clk->name, len);
+       else if (snprintf(s, len, "%s.%d", clk->name, clk->id) > len)
+               s[len - 1] = '\0';
+       return s;
+}
+EXPORT_SYMBOL(clk_get_name);
+
 /* base clocks */

 static int clk_default_setrate(struct clk *clk, unsigned long rate)
diff -urpN linux-2.6.29-rc2/include/linux/clk.h
linux-2.6.29-rc2.elpa/include/linux/clk.h
--- linux-2.6.29-rc2/include/linux/clk.h        2008-12-25
00:26:37.000000000 +0100
+++ linux-2.6.29-rc2.elpa/include/linux/clk.h   2009-01-28
19:21:43.000000000 +0100
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
