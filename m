Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbYEOXsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbYEOXsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYEOXsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:48:08 -0400
Received: from fugue.toroid.org ([85.10.196.113]:32948 "EHLO fugue.toroid.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbYEOXsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:48:07 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 19:48:07 EDT
Date: Fri, 16 May 2008 05:11:14 +0530
From: Abhijit Menon-Sen <ams@toroid.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Add a void * alternative to print_fn_descriptor_symbol()
Message-ID: <20080515234114.GA656@toroid.org>
References: <20080514154402.GF6902@cvg> <20080515105803.7c9ab8c7.akpm@linux-foundation.org> <20080515180528.GC7481@cvg> <Pine.LNX.4.64.0805152132530.22059@anakin> <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com> <20080515134928.83b2d948.akpm@linux-foundation.org> <alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org> <20080515144554.7b759b3c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515144554.7b759b3c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 2008-05-15 14:45:54 -0700, akpm@linux-foundation.org wrote:
>
> > Would somebody please want to move that cast into the macro (or
> > better yet, make it an inline function that takes a 'void *'),
> > and remove all the casts from the callers?
> 
> Would be nice.

Something like this?

-- ams

All the callers of print_fn_descriptor_symbol() had to cast their void *
argument to unsigned long. This patch adds an inline print_fn_symbolic()
that takes a void * directly, and updates the callers to use it instead.

Signed-off-by: Abhijit Menon-Sen <ams@toroid.org>
---
 include/linux/kallsyms.h  |   10 ++++++++++
 drivers/base/power/main.c |    2 +-
 drivers/pci/quirks.c      |    3 +--
 drivers/pnp/quirks.c      |    3 +--
 init/main.c               |    9 +++------
 5 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 82de2fb..ed8ab42 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -101,6 +101,16 @@ static inline void print_symbol(const char *fmt, unsigned long addr)
 		       __builtin_extract_return_addr((void *)addr));
 }
 
+static inline void print_fn_symbolic(const char *fmt, const void *addr)
+{
+#if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
+	unsigned long *faddr = (unsigned long *)addr;
+	print_symbol(fmt, faddr[0]);
+#else
+	print_symbol(fmt, (unsigned long)addr);
+#endif
+}
+
 #ifndef CONFIG_64BIT
 #define print_ip_sym(ip)		\
 do {					\

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 7b76fd3..9625317 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -418,7 +418,7 @@ void __suspend_report_result(const char *function, void *fn, int ret)
 {
 	if (ret) {
 		printk(KERN_ERR "%s(): ", function);
-		print_fn_descriptor_symbol("%s() returns ", (unsigned long)fn);
+		print_fn_symbolic("%s returns ", fn);
 		printk("%d\n", ret);
 	}
 }

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f2d9c77..12d07eb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1503,8 +1503,7 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_f
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 #ifdef DEBUG
 			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s()\n",
-				(unsigned long) f->hook);
+			print_fn_symbolic("%s\n", f->hook);
 #endif
 			f->hook(dev);
 		}

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index ffdb12a..f84d79f 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -331,8 +331,7 @@ void pnp_fixup_device(struct pnp_dev *dev)
 			continue;
 #ifdef DEBUG
 		dev_dbg(&dev->dev, "%s: calling ", f->id);
-		print_fn_descriptor_symbol("%s\n",
-				(unsigned long) f->quirk_function);
+		print_fn_symbolic("%s\n", f->quirk_function);
 #endif
 		f->quirk_function(dev);
 	}

diff --git a/init/main.c b/init/main.c
index f406fef..c456ca8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -706,8 +706,7 @@ static void __init do_initcalls(void)
 		int result;
 
 		if (initcall_debug) {
-			print_fn_descriptor_symbol("calling  %s()\n",
-					(unsigned long) *call);
+			print_fn_symbolic("calling %s\n", *call);
 			t0 = ktime_get();
 		}
 
@@ -717,8 +716,7 @@ static void __init do_initcalls(void)
 			t1 = ktime_get();
 			delta = ktime_sub(t1, t0);
 
-			print_fn_descriptor_symbol("initcall %s()",
-					(unsigned long) *call);
+			print_fn_symbolic("initcall %s", *call);
 			printk(" returned %d after %Ld msecs\n", result,
 				(unsigned long long) delta.tv64 >> 20);
 		}
@@ -737,8 +735,7 @@ static void __init do_initcalls(void)
 			local_irq_enable();
 		}
 		if (msgbuf[0]) {
-			print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
-					(unsigned long) *call);
+			print_fn_symbolic(KERN_WARNING "initcall %s", *call);
 			printk(" returned with %s\n", msgbuf);
 		}
 	}
-- 
1.5.5.1

