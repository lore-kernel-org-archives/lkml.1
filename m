Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXLRXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXLRXmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXLRXmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:42:23 -0500
Received: from mga05.intel.com ([192.55.52.89]:47691 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbXLRXmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:42:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,182,1196668800"; 
   d="scan'208";a="448248552"
Message-ID: <476859A5.2070002@linux.intel.com>
Date: Tue, 18 Dec 2007 15:37:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, protasnb@gmail.com,
       tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <20071218174845.GV17536@waste.org>
In-Reply-To: <20071218174845.GV17536@waste.org>
Content-Type: multipart/mixed;
 boundary="------------040804010106040802020605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040804010106040802020605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Matt Mackall wrote:
> 
> Blech. Invoking the random pool machinery at oops time is moderately
> safe, but not very shiny. Going through all the sprintf ugliness to
> format it to an irrelevant UUID standard is not very shiny either. At
> least refactor it so it's not duplicating code.
> 
> And I'd much rather the static variable lived with its user, as
> random.c is already too miscellaneous:

ok so something like this?


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch] Print end-of-oops marker with UUID

Right now, it's nearly impossible for parsers to detect the end-of-oops
condition; for example this is a problem for www.kerneloops.org.
In addition, it's not currently possible to detect whether or not
2 oopses that look alike are actually the same oops reported twice,
or truely 2 unique oopses.

This patch factors out the "sprintf a UUID into a string" code from
random.c into a separate function (using snprintf as suggested by
Randy). So far I left the %02x in place instead of using Linus'
"improvement"; if someone really hates the %02x's he/she can do that
later.

It also reduces the stack footprint of proc_do_uuid(); it
was using 64 bytes for the string where 37 is sufficient.
With these random.c changes, the oops_exit() function can print an
end-of-oops marker from the oops_exit() function.

Normally, the UUID used for oopses is calculated as late_initcall
(in the hope that at that time there is enough entropy to get a
unique enough UUID); however for early oopses the oops_exit() function
needs to generate the UUID on the fly.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: Matt
CC: Ted
CC: Randy

--- linux-2.6.24-rc5/drivers/char/random.c.org	2007-12-18 11:37:22.000000000 -0800
+++ linux-2.6.24-rc5/drivers/char/random.c	2007-12-18 12:20:48.000000000 -0800
@@ -1176,8 +1175,34 @@ static int max_read_thresh = INPUT_POOL_
  static int max_write_thresh = INPUT_POOL_WORDS * 32;
  static char sysctl_bootid[16];

+
+/**
+ * snprintf_uuid - Convert a 16 byte UUID into string format
+ * @string: buffer to store the UUID into
+ * @len:    size of @string
+ * @uuid:   the UUID to convert
+ *
+ * This function converts a 16 byte binary UUID into canonical
+ * ASCII form. This ASCII form needs 37 bytes of storage space,
+ * allocated and provided by the caller.
+ *
+ * Returns: pointer to @string
+ *
+ * Locking: none
+ */
+const char *snprintf_uuid(char *string, int len, unsigned char *uuid)
+{
+	snprintf(string, len,  "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		"%02x%02x-%02x%02x%02x%02x%02x%02x",
+		uuid[0],  uuid[1],  uuid[2],  uuid[3],
+		uuid[4],  uuid[5],  uuid[6],  uuid[7],
+		uuid[8],  uuid[9],  uuid[10], uuid[11],
+		uuid[12], uuid[13], uuid[14], uuid[15]);
+	return string;
+}
+
  /*
- * These functions is used to return both the bootid UUID, and random
+ * These functions are used to return both the bootid UUID, and random
   * UUID.  The difference is in whether table->data is NULL; if it is,
   * then a new UUID is generated and returned to the user.
   *
@@ -1189,7 +1214,7 @@ static int proc_do_uuid(ctl_table *table
  			void __user *buffer, size_t *lenp, loff_t *ppos)
  {
  	ctl_table fake_table;
-	unsigned char buf[64], tmp_uuid[16], *uuid;
+	unsigned char buf[37], tmp_uuid[16], *uuid;

  	uuid = table->data;
  	if (!uuid) {
@@ -1199,12 +1224,7 @@ static int proc_do_uuid(ctl_table *table
  	if (uuid[8] == 0)
  		generate_random_uuid(uuid);

-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x",
-		uuid[0],  uuid[1],  uuid[2],  uuid[3],
-		uuid[4],  uuid[5],  uuid[6],  uuid[7],
-		uuid[8],  uuid[9],  uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15]);
+	snprintf_uuid(buf, sizeof(buf), uuid);
  	fake_table.data = buf;
  	fake_table.maxlen = sizeof(buf);

--- linux-2.6.24-rc5/include/linux/random.h.org	2007-12-18 12:22:49.000000000 -0800
+++ linux-2.6.24-rc5/include/linux/random.h	2007-12-18 12:22:57.000000000 -0800
@@ -71,6 +71,7 @@ unsigned long randomize_range(unsigned l

  u32 random32(void);
  void srandom32(u32 seed);
+const char *snprintf_uuid(char *string, int len, unsigned char *uuid);

  #endif /* __KERNEL___ */

--- linux-2.6.24-rc5/kernel/panic.c.org	2007-12-18 12:23:19.000000000 -0800
+++ linux-2.6.24-rc5/kernel/panic.c	2007-12-18 12:35:46.000000000 -0800
@@ -19,6 +19,7 @@
  #include <linux/nmi.h>
  #include <linux/kexec.h>
  #include <linux/debug_locks.h>
+#include <linux/random.h>

  int panic_on_oops;
  int tainted;
@@ -32,6 +33,8 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list

  EXPORT_SYMBOL(panic_notifier_list);

+static unsigned char oops_uuid[16];
+
  static int __init panic_setup(char *str)
  {
  	panic_timeout = simple_strtoul(str, NULL, 0);
@@ -265,15 +268,32 @@ void oops_enter(void)
  	do_oops_enter_exit();
  }

+static int prime_oops_uuid(void)
+{
+	if (oops_uuid[8] == 0)
+		generate_random_uuid(oops_uuid);
+	return 0;
+}
+
  /*
   * Called when the architecture exits its oops handler, after printing
   * everything.
   */
  void oops_exit(void)
  {
+	char uuid_string[37];
  	do_oops_enter_exit();
+
+	/*
+	 * normally the oops_uid is already calculated, but if we oops during
+	 * really early boot, it may not be. In that case, calculate it here.
+	 */
+	prime_oops_uuid();
+	printk("---[ end trace %s ]---\n",
+		snprintf_uuid(uuid_string, sizeof(uuid_string), oops_uuid));
  }

+late_initcall(prime_oops_uuid);
  #ifdef CONFIG_CC_STACKPROTECTOR
  /*
   * Called when gcc's -fstack-protector feature is used, and

--------------040804010106040802020605
Content-Type: text/x-patch;
 name="oopsend2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oopsend2.patch"

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch] Print end-of-oops marker with UUID

Right now, it's nearly impossible for parsers to detect the end-of-oops
condition; for example this is a problem for www.kerneloops.org.
In addition, it's not currently possible to detect whether or not
2 oopses that look alike are actually the same oops reported twice,
or truely 2 unique oopses. 

This patch factors out the "sprintf a UUID into a string" code from
random.c into a separate function (using snprintf as suggested by
Randy). So far I left the %02x in place instead of using Linus' 
"improvement"; if someone really hates the %02x's he/she can do that
later.

It also reduces the stack footprint of proc_do_uuid(); it
was using 64 bytes for the string where 37 is sufficient.
With these random.c changes, the oops_exit() function can print an
end-of-oops marker from the oops_exit() function.

Normally, the UUID used for oopses is calculated as late_initcall 
(in the hope that at that time there is enough entropy to get a 
unique enough UUID); however for early oopses the oops_exit() function
needs to generate the UUID on the fly.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: Matt
CC: Ted
CC: Randy

--- linux-2.6.24-rc5/drivers/char/random.c.org	2007-12-18 11:37:22.000000000 -0800
+++ linux-2.6.24-rc5/drivers/char/random.c	2007-12-18 12:20:48.000000000 -0800
@@ -1176,8 +1175,34 @@ static int max_read_thresh = INPUT_POOL_
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
 
+
+/**
+ * snprintf_uuid - Convert a 16 byte UUID into string format
+ * @string: buffer to store the UUID into
+ * @len:    size of @string
+ * @uuid:   the UUID to convert
+ *
+ * This function converts a 16 byte binary UUID into canonical
+ * ASCII form. This ASCII form needs 37 bytes of storage space,
+ * allocated and provided by the caller.
+ *
+ * Returns: pointer to @string
+ *
+ * Locking: none
+ */
+const char *snprintf_uuid(char *string, int len, unsigned char *uuid)
+{
+	snprintf(string, len,  "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		"%02x%02x-%02x%02x%02x%02x%02x%02x",
+		uuid[0],  uuid[1],  uuid[2],  uuid[3],
+		uuid[4],  uuid[5],  uuid[6],  uuid[7],
+		uuid[8],  uuid[9],  uuid[10], uuid[11],
+		uuid[12], uuid[13], uuid[14], uuid[15]);
+	return string;
+}
+
 /*
- * These functions is used to return both the bootid UUID, and random
+ * These functions are used to return both the bootid UUID, and random
  * UUID.  The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
  *
@@ -1189,7 +1214,7 @@ static int proc_do_uuid(ctl_table *table
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	ctl_table fake_table;
-	unsigned char buf[64], tmp_uuid[16], *uuid;
+	unsigned char buf[37], tmp_uuid[16], *uuid;
 
 	uuid = table->data;
 	if (!uuid) {
@@ -1199,12 +1224,7 @@ static int proc_do_uuid(ctl_table *table
 	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
 
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x",
-		uuid[0],  uuid[1],  uuid[2],  uuid[3],
-		uuid[4],  uuid[5],  uuid[6],  uuid[7],
-		uuid[8],  uuid[9],  uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15]);
+	snprintf_uuid(buf, sizeof(buf), uuid);
 	fake_table.data = buf;
 	fake_table.maxlen = sizeof(buf);
 
--- linux-2.6.24-rc5/include/linux/random.h.org	2007-12-18 12:22:49.000000000 -0800
+++ linux-2.6.24-rc5/include/linux/random.h	2007-12-18 12:22:57.000000000 -0800
@@ -71,6 +71,7 @@ unsigned long randomize_range(unsigned l
 
 u32 random32(void);
 void srandom32(u32 seed);
+const char *snprintf_uuid(char *string, int len, unsigned char *uuid);
 
 #endif /* __KERNEL___ */
 
--- linux-2.6.24-rc5/kernel/panic.c.org	2007-12-18 12:23:19.000000000 -0800
+++ linux-2.6.24-rc5/kernel/panic.c	2007-12-18 12:35:46.000000000 -0800
@@ -19,6 +19,7 @@
 #include <linux/nmi.h>
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>
+#include <linux/random.h>
 
 int panic_on_oops;
 int tainted;
@@ -32,6 +33,8 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static unsigned char oops_uuid[16];
+
 static int __init panic_setup(char *str)
 {
 	panic_timeout = simple_strtoul(str, NULL, 0);
@@ -265,15 +268,32 @@ void oops_enter(void)
 	do_oops_enter_exit();
 }
 
+static int prime_oops_uuid(void)
+{
+	if (oops_uuid[8] == 0)
+		generate_random_uuid(oops_uuid);
+	return 0;
+}
+
 /*
  * Called when the architecture exits its oops handler, after printing
  * everything.
  */
 void oops_exit(void)
 {
+	char uuid_string[37];
 	do_oops_enter_exit();
+
+	/*
+	 * normally the oops_uid is already calculated, but if we oops during
+	 * really early boot, it may not be. In that case, calculate it here.
+	 */
+	prime_oops_uuid();
+	printk("---[ end trace %s ]---\n",
+		snprintf_uuid(uuid_string, sizeof(uuid_string), oops_uuid));
 }
 
+late_initcall(prime_oops_uuid);
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
  * Called when gcc's -fstack-protector feature is used, and

--------------040804010106040802020605--
