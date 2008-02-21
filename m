Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYBUTDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYBUTDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBUTDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:03:09 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:15712 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYBUTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:03:07 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47BDCACC.2030302@tremplin-utc.net>
Date: Thu, 21 Feb 2008 20:02:36 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20080214 Mandriva/2.0.0.9-8mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Christoph Hellwig <hch@lst.de>, dsdt@gaugusch.at, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       trenn@suse.de
Subject: [PATCH] Allow populate_rootfs() to be called early (was: acpi dsts
 loading and populate_rootfs)
References: <20080210071226.GA23360@lst.de>	<20080210071454.GA23428@lst.de>	<47AEE6D1.4070402@tremplin-utc.net> <20080211164719.d42c618e.vsu@altlinux.ru> <47B0DD34.4010604@tremplin-utc.net>
In-Reply-To: <47B0DD34.4010604@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12/02/08 00:41, Éric Piel wrote/a écrit:
> 11/02/08 14:47, Sergey Vlasov wrote/a écrit:
>>> Would that seem an acceptable solution? Or what other way exists?
>> Disabling call_usermodehelper() until all core initializers had
>> completed would fix the problem too; will such change be acceptable?
> Yes, that looks like a nice way. Actually, I discovered that for suspend
> and resume, there is exactly the same need, and a special flag is
> already available: usermodehelper_disabled.
> 
> So here is a proposal patch leveraging this flag. The rootfs is
> populated early but user land execution is forbidden until we reach a
> sufficient initialization state.  I think it even has the bonus of
> doing _explicitly_ what we want (avoid user land execution).
> 
> Does this look good? (if so, I can probably make it even cleaner by
> renaming/removing the rootfs_initcall level)

It's been a week and no one has screamed, so I guess the idea looks fine
to everyone :-) 

Here is a boot tested patch for integration. In addition to the previous
version, it removes also rootfs_initcall(), and uses fs_initcall_sync().
There should be absolutely no difference in behaviour as there was no
user of fs_initcall_sync() in the kernel.

I'm not sure what should be the best tree to go through. Maybe the ACPI
tree, as all this is needed for CONFIG_ACPI_CUSTOM_DSDT_INITRD...

See you,
Eric

---
For ACPI table override, we need the rootfs available early. So this patch
* removes the kludge calling populate_rootfs early _sometimes_
* leverage the usermodehelper_disabled variable to prevent too early userspace
  execution would could lead to oops if the kernel subsystem are not yet initialised

This solves a theoretical bug where someone has both a DSDT table and a
hotplug helper in his or her initramfs.

---
 include/asm-generic/vmlinux.lds.h |    1 -
 include/linux/init.h              |    1 -
 init/initramfs.c                  |    7 -------
 init/main.c                       |    4 ----
 kernel/kmod.c                     |   15 +++++++++++----
 5 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f784d2f..19ddbae 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -335,7 +335,6 @@
   	*(.initcall4s.init)						\
   	*(.initcall5.init)						\
   	*(.initcall5s.init)						\
-	*(.initcallrootfs.init)						\
   	*(.initcall6.init)						\
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
diff --git a/include/linux/init.h b/include/linux/init.h
index a404a00..ecd05cd 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -183,7 +183,6 @@ void prepare_namespace(void);
 #define subsys_initcall_sync(fn)	__define_initcall("4s",fn,4s)
 #define fs_initcall(fn)			__define_initcall("5",fn,5)
 #define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
-#define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
 #define device_initcall(fn)		__define_initcall("6",fn,6)
 #define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
 #define late_initcall(fn)		__define_initcall("7",fn,7)
diff --git a/init/initramfs.c b/init/initramfs.c
index c0b1e05..b74e845 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -577,10 +577,3 @@ int __init populate_rootfs(void)
 	}
 	return 0;
 }
-#ifndef CONFIG_ACPI_CUSTOM_DSDT_INITRD
-/*
- * if this option is enabled, populate_rootfs() is called _earlier_ in the
- * boot sequence. This insures that the ACPI initialisation can find the file.
- */
-rootfs_initcall(populate_rootfs);
-#endif
diff --git a/init/main.c b/init/main.c
index 8b19820..703ded0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -102,11 +102,7 @@ static inline void mark_rodata_ro(void) { }
 extern void tc_init(void);
 #endif
 
-#ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
 extern int populate_rootfs(void);
-#else
-static inline void populate_rootfs(void) {}
-#endif
 
 enum system_states system_state;
 EXPORT_SYMBOL(system_state);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index bb7df2a..112b261 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -267,14 +267,23 @@ static void __call_usermodehelper(struct work_struct *work)
 	}
 }
 
-#ifdef CONFIG_PM
 /*
  * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
  * (used for preventing user land processes from being created after the user
  * land has been frozen during a system-wide hibernation or suspend operation).
+ * It is also used at boot up to avoid calling a user land process before all
+ * the kernel subsystems are initialised (such as pipefs).
  */
-static int usermodehelper_disabled;
+static int usermodehelper_disabled = 1;
 
+static int __init enable_usermodehelper(void)
+{
+	usermodehelper_disabled = 0;
+	return 0;
+}
+fs_initcall_sync(enable_usermodehelper);
+
+#ifdef CONFIG_PM
 /* Number of helpers running */
 static atomic_t running_helpers = ATOMIC_INIT(0);
 
@@ -342,8 +351,6 @@ static void register_pm_notifier_callback(void)
 	pm_notifier(usermodehelper_pm_callback, 0);
 }
 #else /* CONFIG_PM */
-#define usermodehelper_disabled	0
-
 static inline void helper_lock(void) {}
 static inline void helper_unlock(void) {}
 static inline void register_pm_notifier_callback(void) {}
