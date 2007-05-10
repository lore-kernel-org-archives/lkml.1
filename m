Return-Path: <linux-kernel-owner+w=401wt.eu-S1763185AbXEKTKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763185AbXEKTKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762812AbXEKTJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:09:39 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:60046 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758742AbXEKTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:09:38 -0400
Message-Id: <20070511000027.091968000@goop.org>
References: <20070510235708.155502000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 16:57:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Arnaldo Carvalho de Melo <acme@mandriva.com>,
       Al Viro <viro@ftp.linux.org.uk>, Panagiotis Issaris <takis@issaris.org>
Subject: [patch 3/7] add kstrndup
Content-Disposition: inline; filename=add-kstrndup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kstrndup function, modelled on strndup.  Like strndup this
returns a string copied into its own allocated memory, but it copies
no more than the specified number of bytes from the source.

Remove private strndup() from irda code.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Panagiotis Issaris <takis@issaris.org>

---
 include/linux/string.h  |    1 +
 mm/util.c               |   30 +++++++++++++++++++++++++++---
 net/irda/irias_object.c |   43 +++++--------------------------------------
 3 files changed, 33 insertions(+), 41 deletions(-)

===================================================================
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -105,6 +105,7 @@ extern void * memchr(const void *,int,__
 #endif
 
 extern char *kstrdup(const char *s, gfp_t gfp);
+extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
 #ifdef __cplusplus
===================================================================
--- a/mm/util.c
+++ b/mm/util.c
@@ -18,9 +18,8 @@ void *__kzalloc(size_t size, gfp_t flags
 }
 EXPORT_SYMBOL(__kzalloc);
 
-/*
+/**
  * kstrdup - allocate space for and copy an existing string
- *
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
  */
@@ -39,6 +38,32 @@ char *kstrdup(const char *s, gfp_t gfp)
 	return buf;
 }
 EXPORT_SYMBOL(kstrdup);
+
+/**
+ * kstrndup - allocate space for and copy an existing string
+ * @s: the string to duplicate
+ * @max: read at most @max chars from @s
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ */
+char *kstrndup(const char *s, size_t max, gfp_t gfp)
+{
+	size_t len;
+	char *buf;
+
+	if (!s)
+		return NULL;
+
+	len = strlen(s);
+	if (len > max)
+		len = max;
+	buf = kmalloc_track_caller(len+1, gfp);
+ 	if (buf) {
+		memcpy(buf, s, len);
+		buf[len] = '\0';
+	}
+	return buf;
+}
+EXPORT_SYMBOL(kstrndup);
 
 /**
  * kmemdup - duplicate region of memory
@@ -60,7 +85,6 @@ EXPORT_SYMBOL(kmemdup);
 
 /*
  * strndup_user - duplicate an existing string from user space
- *
  * @s: The string to duplicate
  * @n: Maximum number of bytes to copy, including the trailing NUL.
  */
===================================================================
--- a/net/irda/irias_object.c
+++ b/net/irda/irias_object.c
@@ -36,39 +36,6 @@ hashbin_t *irias_objects;
  */
 struct ias_value irias_missing = { IAS_MISSING, 0, 0, 0, {0}};
 
-/*
- * Function strndup (str, max)
- *
- *    My own kernel version of strndup!
- *
- * Faster, check boundary... Jean II
- */
-static char *strndup(char *str, size_t max)
-{
-	char *new_str;
-	int len;
-
-	/* Check string */
-	if (str == NULL)
-		return NULL;
-	/* Check length, truncate */
-	len = strlen(str);
-	if(len > max)
-		len = max;
-
-	/* Allocate new string */
-	new_str = kmalloc(len + 1, GFP_ATOMIC);
-	if (new_str == NULL) {
-		IRDA_WARNING("%s: Unable to kmalloc!\n", __FUNCTION__);
-		return NULL;
-	}
-
-	/* Copy and truncate */
-	memcpy(new_str, str, len);
-	new_str[len] = '\0';
-
-	return new_str;
-}
 
 /*
  * Function ias_new_object (name, id)
@@ -90,7 +57,7 @@ struct ias_object *irias_new_object( cha
 	}
 
 	obj->magic = IAS_OBJECT_MAGIC;
-	obj->name = strndup(name, IAS_MAX_CLASSNAME);
+	obj->name = kstrndup(name, IAS_MAX_CLASSNAME, GFP_ATOMIC);
 	if (!obj->name) {
 		IRDA_WARNING("%s(), Unable to allocate name!\n",
 			     __FUNCTION__);
@@ -360,7 +327,7 @@ void irias_add_integer_attrib(struct ias
 	}
 
 	attrib->magic = IAS_ATTRIB_MAGIC;
-	attrib->name = strndup(name, IAS_MAX_ATTRIBNAME);
+	attrib->name = kstrndup(name, IAS_MAX_ATTRIBNAME, GFP_ATOMIC);
 
 	/* Insert value */
 	attrib->value = irias_new_integer_value(value);
@@ -404,7 +371,7 @@ void irias_add_octseq_attrib(struct ias_
 	}
 
 	attrib->magic = IAS_ATTRIB_MAGIC;
-	attrib->name = strndup(name, IAS_MAX_ATTRIBNAME);
+	attrib->name = kstrndup(name, IAS_MAX_ATTRIBNAME, GFP_ATOMIC);
 
 	attrib->value = irias_new_octseq_value( octets, len);
 	if (!attrib->name || !attrib->value) {
@@ -446,7 +413,7 @@ void irias_add_string_attrib(struct ias_
 	}
 
 	attrib->magic = IAS_ATTRIB_MAGIC;
-	attrib->name = strndup(name, IAS_MAX_ATTRIBNAME);
+	attrib->name = kstrndup(name, IAS_MAX_ATTRIBNAME, GFP_ATOMIC);
 
 	attrib->value = irias_new_string_value(value);
 	if (!attrib->name || !attrib->value) {
@@ -506,7 +473,7 @@ struct ias_value *irias_new_string_value
 
 	value->type = IAS_STRING;
 	value->charset = CS_ASCII;
-	value->t.string = strndup(string, IAS_MAX_STRING);
+	value->t.string = kstrndup(string, IAS_MAX_STRING, GFP_ATOMIC);
 	if (!value->t.string) {
 		IRDA_WARNING("%s: Unable to kmalloc!\n", __FUNCTION__);
 		kfree(value);

-- 

