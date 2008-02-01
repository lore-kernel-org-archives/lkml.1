Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYBAJQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYBAJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYBAJQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:16:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:26811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYBAJQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:16:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,289,1199692800"; 
   d="scan'208";a="294847909"
Subject: [PATCH 2.6.24] Add new string functions strict_strto* and convert
	kernel params to use them, take 3
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de
In-Reply-To: <1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	 <1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
	 <1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
	 <1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 01 Feb 2008 08:02:56 +0800
Message-Id: <1201824176.3925.13.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, i'm really very very sorry for those mistakes, here is the latest, it
adds documentation for every new function, please use it to replace the patch
in -mm tree you added just now:

add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch

Thank you, Andrew and Randy.

Currently, for every sysfs node, the callers will be responsible for
implementing store operation, so many many callers are doing duplicate
things to validate input, they have the same mistakes because they are
calling simple_strtol/ul/ll/uul, especially for module params, they are
just numeric, but you can echo such values as 0x1234xxx, 07777888 and
1234aaa, for these cases, module params store operation just ignores
succesive invalid char and converts prefix part to a numeric although
input is acctually invalid.

This patch tries to fix the aforementioned issues and implements strict_strtox
serial functions, kernel/params.c uses them to strictly validate input,
so module params will reject such values as 0x1234xxxx and returns an error:

write error: Invalid argument

Any modules which export numeric sysfs node can use strict_strtox instead of
simple_strtox to reject any invalid input. Please consider to merge to -mm tree
in order to test.

Here are some test results:

Before applying this patch:

[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]#


After applying this patch:

[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo -n 4096 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]#


Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 include/linux/kernel.h |    4 +
 kernel/params.c        |   20 +++----
 lib/vsprintf.c         |  123 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 10 deletions(-)

--- a/include/linux/kernel.h	2008-01-31 00:41:46.000000000 +0800
+++ b/include/linux/kernel.h	2008-02-01 04:30:49.000000000 +0800
@@ -141,6 +141,10 @@ extern unsigned long simple_strtoul(cons
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
+extern int strict_strtoul(const char *, unsigned int, unsigned long *);
+extern int strict_strtol(const char *, unsigned int, long *);
+extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
+extern int strict_strtoll(const char *, unsigned int, long long *);
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
--- a/lib/vsprintf.c	2008-01-30 08:13:03.000000000 +0800
+++ b/lib/vsprintf.c	2008-02-01 07:36:57.000000000 +0800
@@ -126,6 +126,129 @@ long long simple_strtoll(const char *cp,
 	return simple_strtoull(cp,endp,base);
 }
 
+
+/**
+ * strict_strtoul - convert a string to an unsigned long strictly
+ * @cp: The string to be converted
+ * @base: The number base to use
+ * @res: The converted result value
+ *
+ * strict_strtoul converts a string to an unsigned long only if the
+ * string is really an unsigned long string, any string containing
+ * any invalid char at the tail will be rejected and -EINVAL is returned,
+ * only a newline char at the tail is acceptible because people generally
+ * change a module parameter in the following way:
+ *
+ * 	echo 1024 > /sys/module/e1000/parameters/copybreak
+ *
+ * echo will append a newline to the tail.
+ *
+ * It returns 0 if conversion is successful and *res is set to the converted
+ * value, otherwise it returns -EINVAL and *res is set to 0.
+ *
+ * simple_strtoul just ignores the successive invalid characters and
+ * return the converted value of prefix part of the string.
+ */
+int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
+
+/**
+ * strict_strtol - convert a string to a long strictly
+ * @cp: The string to be converted
+ * @base: The number base to use
+ * @res: The converted result value
+ *
+ * strict_strtol is similiar to strict_strtoul, but it allows the first
+ * character of a string is '-'.
+ *
+ * It returns 0 if conversion is successful and *res is set to the converted
+ * value, otherwise it returns -EINVAL and *res is set to 0.
+ */
+int strict_strtol(const char *cp, unsigned int base, long *res);
+
+/**
+ * strict_strtoull - convert a string to an unsigned long long strictly
+ * @cp: The string to be converted
+ * @base: The number base to use
+ * @res: The converted result value
+ *
+ * strict_strtoull converts a string to an unsigned long long only if the
+ * string is really an unsigned long long string, any string containing
+ * any invalid char at the tail will be rejected and -EINVAL is returned,
+ * only a newline char at the tail is acceptible because people generally
+ * change a module parameter in the following way:
+ *
+ * 	echo 1024 > /sys/module/e1000/parameters/copybreak
+ *
+ * echo will append a newline to the tail of the string.
+ *
+ * It returns 0 if conversion is successful and *res is set to the converted
+ * value, otherwise it returns -EINVAL and *res is set to 0.
+ *
+ * simple_strtoull just ignores the successive invalid characters and
+ * return the converted value of prefix part of the string.
+ */
+int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res);
+
+/**
+ * strict_strtoll - convert a string to a long long strictly
+ * @cp: The string to be converted
+ * @base: The number base to use
+ * @res: The converted result value
+ *
+ * strict_strtoll is similiar to strict_strtoull, but it allows the first
+ * character of a string is '-'.
+ *
+ * It returns 0 if conversion is successful and *res is set to the converted
+ * value, otherwise it returns -EINVAL and *res is set to 0.
+ */
+int strict_strtoll(const char *cp, unsigned int base, long long *res);
+
+#define define_strict_strtoux(type, valtype)				\
+int strict_strtou##type(const char *cp, unsigned int base, valtype *res)\
+{									\
+	char *tail;							\
+	valtype val;							\
+	size_t len;							\
+									\
+	*res = 0;							\
+	len = strlen(cp);						\
+	if (len == 0)							\
+		return -EINVAL;						\
+									\
+	val = simple_strtoul(cp, &tail, base);				\
+	if ((*tail == '\0') ||						\
+		(len == (size_t)(tail - cp) + 1) && (*tail == '\n')) {	\
+		*res = val;						\
+		return 0;						\
+	}								\
+									\
+	return -EINVAL;							\
+}									\
+
+#define define_strict_strtox(type, valtype)				\
+int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
+{									\
+	int ret;							\
+	if (*cp == '-') {						\
+		ret = strict_strtou##type(cp+1, base, res);		\
+		if (ret != 0)						\
+			*res = -(*res);					\
+	} else								\
+		ret = strict_strtou##type(cp+1, base, res);		\
+									\
+	return ret;							\
+}									\
+
+define_strict_strtoux(l, unsigned long)
+define_strict_strtox(l, long)
+define_strict_strtoux(ll, unsigned long long)
+define_strict_strtox(ll, long long)
+
+EXPORT_SYMBOL(strict_strtoul);
+EXPORT_SYMBOL(strict_strtol);
+EXPORT_SYMBOL(strict_strtoll);
+EXPORT_SYMBOL(strict_strtoull);
+
 static int skip_atoi(const char **s)
 {
 	int i=0;
--- a/kernel/params.c	2008-01-31 00:44:44.000000000 +0800
+++ b/kernel/params.c	2008-02-01 04:32:12.000000000 +0800
@@ -180,12 +180,12 @@ int parse_args(const char *name,
 #define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
 	int param_set_##name(const char *val, struct kernel_param *kp)	\
 	{								\
-		char *endp;						\
 		tmptype l;						\
+		int ret;						\
 									\
 		if (!val) return -EINVAL;				\
-		l = strtolfn(val, &endp, 0);				\
-		if (endp == val || ((type)l != l))			\
+		ret = strtolfn(val, 0, &l);				\
+		if (ret == -EINVAL || ((type)l != l))			\
 			return -EINVAL;					\
 		*((type *)kp->arg) = l;					\
 		return 0;						\
@@ -195,13 +195,13 @@ int parse_args(const char *name,
 		return sprintf(buffer, format, *((type *)kp->arg));	\
 	}
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, simple_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, simple_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, simple_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, simple_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, simple_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, simple_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, simple_strtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
 
 int param_set_charp(const char *val, struct kernel_param *kp)
 {


