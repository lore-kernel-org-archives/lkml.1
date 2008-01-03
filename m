Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYACV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYACV3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYACV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:29:23 -0500
Received: from mga06.intel.com ([134.134.136.21]:15604 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbYACV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:29:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="248526394"
Message-ID: <477D5340.9090809@linux.intel.com>
Date: Thu, 03 Jan 2008 22:27:28 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, akpm@linux-foundation.org, olof@lixom.net
Subject: [patch 2/2] Add the end-of-trace marker and the module list to WARN_ON()
Content-Type: multipart/mixed;
 boundary="------------040009030105080203010608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040009030105080203010608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Subject: Add the end-of-trace marker and the module list to WARN_ON()
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Olof Johansson <olof@lixom.net>

Unlike oopses, WARN_ON() currently doesn't print the loaded modules list.
This makes it harder to take action on certain bug reports. For example,
recently there were a set of WARN_ON()s reported in the mac80211 stack,
which were just signaling a driver bug. It takes then anther round trip
to the bug reporter (if he responds at all) to find out which driver
is at fault.

Another issue is that, unlike oopses, WARN_ON() doesn't currently printk
the helpful "cut here" line, nor the "end of trace" marker.
Now that WARN_ON() is out of line, the size increase due to this is
minimal and it's worth adding.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
  kernel/panic.c |   16 ++++++++++++----
  1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.24-rc6/kernel/panic.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/panic.c
+++ linux-2.6.24-rc6/kernel/panic.c
@@ -281,6 +281,13 @@ static int init_oops_id(void)
  }
  late_initcall(init_oops_id);

+static void print_oops_end_marker(void)
+{
+	init_oops_id();
+	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+		(unsigned long long)oops_id);
+}
+
  /*
   * Called when the architecture exits its oops handler, after printing
   * everything.
@@ -288,9 +295,7 @@ late_initcall(init_oops_id);
  void oops_exit(void)
  {
  	do_oops_enter_exit();
-	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-		(unsigned long long)oops_id);
+	print_oops_end_marker();
  }


@@ -298,11 +303,14 @@ void warn_on_slowpath(const char *file,
  {
  	char function[KSYM_SYMBOL_LEN];
  	unsigned long caller = (unsigned long) __builtin_return_address(0);
-
  	sprint_symbol(function, caller);
+
+	printk(KERN_WARNING "------------[ cut here ]------------\n");
  	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
  		line, function);
+	print_modules();
  	dump_stack();
+	print_oops_end_marker();
  }
  EXPORT_SYMBOL(warn_on_slowpath);


--------------040009030105080203010608
Content-Type: text/x-patch;
 name="enhance-warnon-output.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="enhance-warnon-output.patch"

Subject: Add the end-of-trace marker and the module list to WARN_ON()
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Olof Johansson <olof@lixom.net>

Unlike oopses, WARN_ON() currently does't print the loaded modules list.
This makes it harder to take action on certain bug reports. For example,
recently there were a set of WARN_ON()s reported in the mac80211 stack,
which were just signalling a driver bug. It takes then anther round trip
to the bug reporter (if he responds at all) to find out which driver
is at fault.

Another issue is that, unlike oopses, WARN_ON() doesn't currently printk
the helpful "cut here" line, nor the "end of trace" marker.
Now that WARN_ON() is out of line, the size increase due to this is
minimal and it's worth adding.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 kernel/panic.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.24-rc6/kernel/panic.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/panic.c
+++ linux-2.6.24-rc6/kernel/panic.c
@@ -281,6 +281,13 @@ static int init_oops_id(void)
 }
 late_initcall(init_oops_id);
 
+static void print_oops_end_marker(void)
+{
+	init_oops_id();
+	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+		(unsigned long long)oops_id);
+}
+
 /*
  * Called when the architecture exits its oops handler, after printing
  * everything.
@@ -288,9 +295,7 @@ late_initcall(init_oops_id);
 void oops_exit(void)
 {
 	do_oops_enter_exit();
-	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-		(unsigned long long)oops_id);
+	print_oops_end_marker();
 }
 
 
@@ -298,11 +303,14 @@ void warn_on_slowpath(const char *file, 
 {
 	char function[KSYM_SYMBOL_LEN];
 	unsigned long caller = (unsigned long) __builtin_return_address(0);
-
 	sprint_symbol(function, caller);
+
+	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
 		line, function);
+	print_modules();
 	dump_stack();
+	print_oops_end_marker();
 }
 EXPORT_SYMBOL(warn_on_slowpath);
 

--------------040009030105080203010608--
