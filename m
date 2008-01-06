Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYAFDOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYAFDOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYAFDNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:13:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57773 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbYAFDNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:13:51 -0500
Date: Sat, 5 Jan 2008 19:10:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: [patch 3/5] Add the end-of-trace marker and the module list to
 WARN_ON()
Message-ID: <20080105191044.23712dc7@laptopd505.fenrus.org>
In-Reply-To: <20080105190713.73745ec6@laptopd505.fenrus.org>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 
 #ifdef WANT_WARNON_SLOWPATH
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
 #endif



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
