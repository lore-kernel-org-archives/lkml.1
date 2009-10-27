Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZJ0Ij3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZJ0Ij3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZJ0Ij2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:39:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37721 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZJ0Ij1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:39:27 -0400
Message-ID: <4AE6B1CC.6040603@np.css.fujitsu.com>
Date: Tue, 27 Oct 2009 17:39:40 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] [RFC][Patch x86-tip] add notifier before kdump
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel is going on panic, there are three groups of people
who want to do something for themselves at that time:
    1. Only do the work for notifying
    2. Only do the work for kdump
    3. Want to do both of the above, notifying and kdump

The first and second have been done well on current kernel, but we
can not satisfy 3rd when kdump is used, because notify_die() is located
after crash_kexec(). So I think we can do some work to make it working
well. And I am also the person who stand in the third group.

In our PC-cluster, there are two nodes working together, one is running
and the other one is on standby mode. When the running one is going
on panic, we hope the works listed as following would be done:
    1. Before the running kernel is going on panic, the node on standby
       mode should be notified firstly.
    2. After the notified work is done, the panic kernel startup on the
       second kernel to get kdump.
But the current kernel could not do them all.

For resolving this problem,I made this patch.
In my patch, because I don't want to give impact to both of all, notifying
and kdump, I do following work:
    1. I add crash_notifier instead of the existing notify_die().
       So the original functionality of notify_die() will not be changed. I
       made all of the work done just before kdump will be got.
    2. I add a switch to turn on/off crash_notifier.
       This switch could be turned on/off according to your request. For
       example, when kdump is only required to be done, the crash_notifier is
       not need any more, so the switch could be turned off.
       Also there will be not impact to the second kernel. Because it is valid
       only when the flag for crash_notifier is set via a parameter of kernel.

This patch is not tested on SH and Power PC.

Signed-off-by: Akiyama, Nobuyuki <akiyama.nobuyuk@jp.fujitsu.com>
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 include/linux/kexec.h |    2 ++
 kernel/kexec.c        |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index adc34f2..c50158c 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -9,6 +9,7 @@
 #include <linux/ioport.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/notifier.h>
 #include <asm/kexec.h>
 
 /* Verify architecture specific macros are defined */
@@ -158,6 +159,7 @@ unsigned long paddr_vmcoreinfo_note(void);
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
+extern struct raw_notifier_head crash_notifier_list;
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index f336e21..147f22d 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -31,6 +31,8 @@
 #include <linux/cpu.h>
 #include <linux/console.h>
 #include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -38,6 +40,10 @@
 #include <asm/system.h>
 #include <asm/sections.h>
 
+/* crash notifier list */
+RAW_NOTIFIER_HEAD(crash_notifier_list);
+EXPORT_SYMBOL(crash_notifier_list);
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
 
@@ -1060,6 +1066,14 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,
 }
 #endif
 
+static int		crash_notifier_valid		__read_mostly;
+
+static void notify_crash(void)
+{
+	if (crash_notifier_valid)
+		raw_notifier_call_chain(&crash_notifier_list, 0, 0);
+}
+
 void crash_kexec(struct pt_regs *regs)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load
@@ -1076,6 +1090,7 @@ void crash_kexec(struct pt_regs *regs)
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
+			notify_crash();
 			machine_kexec(kexec_crash_image);
 		}
 		mutex_unlock(&kexec_mutex);
@@ -1502,3 +1517,12 @@ int kernel_kexec(void)
 	mutex_unlock(&kexec_mutex);
 	return error;
 }
+
+static int __init kexec_crash_notifier_valid(char *str)
+{
+	crash_notifier_valid = 1;
+
+	return 1;
+}
+
+__setup("crash_notifier", kexec_crash_notifier_valid);
-- 
1.6.2.2


