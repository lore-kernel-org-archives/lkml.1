Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYBMO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYBMO1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYBMO1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:27:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:4731 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbYBMO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=ZWXsNlfI/MbGFdSKQxOySGghozie7LLa4O894el2emjmqkTRzVb4d1kMQDbXeo6m/xuWT0LCAtASdDWDMlKkudXLCRjwTyBY89aGsYVBFsdnRM+KXO0pbWjDUlrg33e50w4E0nDofWzeoSV3THYEW6Asmiql3W9pB7W1nzmbnyU=
Date: Wed, 13 Feb 2008 22:27:40 +0800
To: linux-kernel@vger.kernel.org
Cc: randy.dunlap@oracle.com, arjan@infradead.org, akpm@linux-foundation.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, kyle@parisc-linux.org,
       schwidefsky@de.ibm.com, hskinnemoen@atmel.com, lethal@linux-sh.org
Subject: Taint kernel after WARN_ON(condition) v2
Message-ID: <20080213142740.GA4895@gandalf.middleearth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Nur Hussein <nurhussein@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an improved version of the patch I sent previously, taking into
account the comments given.

The kernel is sent to tainted within the warn_on_slowpath() function,
and whenever a warning occurs the new taint flag 'W' is set. This is
useful to know if a warning occurred before a BUG by preserving the
warning as a flag in the taint state.

This does not work on architectures where WARN_ON has its own definition. 
These archs are:
	1. s390
	2. superh
	3. avr32
	4. parisc

The maintainers of these architectures have been added in the Cc: list
in this email to alert them to the situation.

The documentation in oops-tracing.txt has been updated to include the
new flag.

Signed-off-by: Nur Hussein <nurhussein@gmail.com>

--

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index 7f60dfe..b152e81 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -253,6 +253,10 @@ characters, each representing a particular tainted value.
 
   8: 'D' if the kernel has died recently, i.e. there was an OOPS or BUG.
 
+  9: 'A' if the ACPI table has been overridden.
+
+ 10: 'W' if a warning has previously been issued by the kernel.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..d90c1a4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -255,6 +255,7 @@ extern enum system_states {
 #define TAINT_USER			(1<<6)
 #define TAINT_DIE			(1<<7)
 #define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
+#define TAINT_WARN			(1<<9)
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 24af9f8..425567f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -153,6 +153,8 @@ EXPORT_SYMBOL(panic);
  *  'M' - System experienced a machine check exception.
  *  'B' - System has hit bad_page.
  *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
  *
  *	The string is overwritten by the next call to print_taint().
  */
@@ -161,7 +163,7 @@ const char *print_tainted(void)
 {
 	static char buf[20];
 	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c",
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
@@ -170,7 +172,8 @@ const char *print_tainted(void)
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
 			tainted & TAINT_USER ? 'U' : ' ',
 			tainted & TAINT_DIE ? 'D' : ' ',
-			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ');
+			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
+			tainted & TAINT_WARN ? 'W' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
@@ -312,6 +315,7 @@ void warn_on_slowpath(const char *file, int line)
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
+	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_on_slowpath);
 #endif
