Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYHVPf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYHVPf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYHVPfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:35:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:20015 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYHVPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:35:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] vsprintf: use new vsprintf symbolic function pointer format
Date: Fri, 22 Aug 2008 09:34:43 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808220934.44782.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the '%pF' format to get rid of an "#ifdef DEBUG" and make
some printks atomic.

This removes the last in-tree uses of print_fn_descriptor_symbol().
I marked print_fn_descriptor_symbol() deprecated and scheduled it
for removal next year to give time for out-of-tree modules to be
updated.

I cc'd the parisc folks because print_fn_descriptor_symbol() is
currently broken there (it needs to dereference the function pointer
similar to ia64 and power).  This patch shouldn't make anything worse,
but it means we need to fix dereference_function_descriptor() instead
of print_fn_descriptor_symbol() to get meaningful initcall_debug
output.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/base/power/main.c                  |    7 ++-----
 drivers/pci/quirks.c                       |    5 +----
 include/linux/kallsyms.h                   |    8 +++-----
 init/main.c                                |   14 ++++++--------
 5 files changed, 20 insertions(+), 22 deletions(-)


diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index eb1a47b..6951fb4 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -322,3 +322,11 @@ Why:  Accounting can now be enabled/disabled without kernel recompilation.
       controlled by a kernel/module/sysfs/sysctl parameter.
 Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
 
+---------------------------
+
+What: print_fn_descriptor_symbol()
+When: October 2009
+Why:  The %pF vsprintf format provides the same functionality in a
+      simpler way.  print_fn_descriptor_symbol() is deprecated but
+      still present to give out-of-tree modules time to change.
+Who:  Bjorn Helgaas <bjorn.helgaas@hp.com>
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 3250c52..cd12708 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -787,10 +787,7 @@ EXPORT_SYMBOL_GPL(device_suspend);
 
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
-	if (ret) {
-		printk(KERN_ERR "%s(): ", function);
-		print_fn_descriptor_symbol("%s returns ", fn);
-		printk("%d\n", ret);
-	}
+	if (ret)
+		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9236e7f..0143268 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1560,10 +1560,7 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_f
 	while (f < end) {
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
-#ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s\n", f->hook);
-#endif
+			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 			f->hook(dev);
 		}
 		f++;
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index b961448..f3fe343 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -93,12 +93,10 @@ static inline void print_symbol(const char *fmt, unsigned long addr)
 }
 
 /*
- * Pretty-print a function pointer.
- *
- * ia64 and ppc64 function pointers are really function descriptors,
- * which contain a pointer the real address.
+ * Pretty-print a function pointer.  This function is deprecated.
+ * Please use the "%pF" vsprintf format instead.
  */
-static inline void print_fn_descriptor_symbol(const char *fmt, void *addr)
+static inline void __deprecated print_fn_descriptor_symbol(const char *fmt, void *addr)
 {
 #if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
 	addr = *(void **)addr;
diff --git a/init/main.c b/init/main.c
index f6f7042..75a038d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -708,7 +708,7 @@ int do_one_initcall(initcall_t fn)
 	int result;
 
 	if (initcall_debug) {
-		print_fn_descriptor_symbol("calling  %s\n", fn);
+		printk("calling  %pF\n", fn);
 		t0 = ktime_get();
 	}
 
@@ -718,9 +718,8 @@ int do_one_initcall(initcall_t fn)
 		t1 = ktime_get();
 		delta = ktime_sub(t1, t0);
 
-		print_fn_descriptor_symbol("initcall %s", fn);
-		printk(" returned %d after %Ld msecs\n", result,
-			(unsigned long long) delta.tv64 >> 20);
+		printk("initcall %pF returned %d after %Ld msecs\n", fn,
+		       result, (unsigned long long) delta.tv64 >> 20);
 	}
 
 	msgbuf[0] = 0;
@@ -736,10 +735,9 @@ int do_one_initcall(initcall_t fn)
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 		local_irq_enable();
 	}
-	if (msgbuf[0]) {
-		print_fn_descriptor_symbol(KERN_WARNING "initcall %s", fn);
-		printk(" returned with %s\n", msgbuf);
-	}
+	if (msgbuf[0])
+		printk(KERN_WARNING "initcall %pF returned with %s\n",
+		       fn, msgbuf);
 
 	return result;
 }
