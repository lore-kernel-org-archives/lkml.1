Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbXLHBQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbXLHBQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 20:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXLHBQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 20:16:47 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:59964 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbXLHBQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 20:16:46 -0500
Date: Fri, 7 Dec 2007 17:14:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vincent.fortier1@ec.gc.ca, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-Id: <20071207171455.b2eecb60.randy.dunlap@oracle.com>
In-Reply-To: <20071207151113.e9841341.akpm@linux-foundation.org>
References: <1196427774.10204.4.camel@kayak.wul.qc.ec.gc.ca>
	<20071130091239.708173db.randy.dunlap@oracle.com>
	<F1D642E5A91BC94D9504EC83AE19E6B0B8998E@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<1196776021.14468.2.camel@kayak.wul.qc.ec.gc.ca>
	<20071207141536.1e9199dc.randy.dunlap@oracle.com>
	<20071207151113.e9841341.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007 15:11:13 -0800 Andrew Morton wrote:

> On Fri, 7 Dec 2007 14:15:36 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > > Help would really be appreciated.
> > 
> > Let's try the last_sysfs_file (name) patch.
> > I've attempted to update it for 2.6.22.14.
> > Andrew, does this change in fs/sysfs/file.c look OK?
> 
> umm, yup.
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/gregkh-driver-sysfs-crash-debugging.patch
> 
> should work.

Thanks.  
I produced a cleanly applying version of it for 2.6.22.14.

Vincent, please apply this patch so we can know which file in sysfs
these oopses are happening with.

---


From: Andrew Morton <akpm@osdl.org>

Display the most-recently-opened sysfs file's name when oopsing.

From: Adrian Bunk <bunk@stusta.de>

  Build fix

From: Greg Kroah-Hartman <gregkh@suse.de>

  Modified to make the api call cleaner, and available to all arches if
  need be.  Also added it to x86-64's crash dump message.


Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/i386/kernel/traps.c   |    1 +
 arch/x86_64/kernel/traps.c |    1 +
 fs/sysfs/file.c            |   14 ++++++++++++++
 include/linux/sysfs.h      |    6 ++++++
 4 files changed, 22 insertions(+)

--- linux-2.6.22.14.orig/arch/i386/kernel/traps.c
+++ linux-2.6.22.14/arch/i386/kernel/traps.c
@@ -411,6 +411,7 @@ void die(const char * str, struct pt_reg
 #endif
 		if (nl)
 			printk("\n");
+		sysfs_printk_last_file();
 		if (notify_die(DIE_OOPS, str, regs, err,
 					current->thread.trap_no, SIGSEGV) !=
 				NOTIFY_STOP) {
--- linux-2.6.22.14.orig/arch/x86_64/kernel/traps.c
+++ linux-2.6.22.14/arch/x86_64/kernel/traps.c
@@ -516,6 +516,7 @@ void __kprobes __die(const char * str, s
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
+	sysfs_printk_last_file();
 	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
 	show_registers(regs);
 	/* Executive summary in case the oops scrolled away */
--- linux-2.6.22.14.orig/fs/sysfs/file.c
+++ linux-2.6.22.14/fs/sysfs/file.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
+#include <linux/limits.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
@@ -15,6 +16,13 @@
 
 #define to_sattr(a) container_of(a,struct subsys_attribute, attr)
 
+/* used in crash dumps to help with debugging */
+static char last_sysfs_file[PATH_MAX];
+void sysfs_printk_last_file(void)
+{
+	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
+}
+
 /*
  * Subsystem file operations.
  * These operations allow subsystems to have files that can be 
@@ -253,6 +261,12 @@ static int sysfs_open_file(struct inode 
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error = 0;
+	char *p;
+
+	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
+		   sizeof(last_sysfs_file));
+	if (p)
+		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	if (!kobj || !attr)
 		goto Einval;
--- linux-2.6.22.14.orig/include/linux/sysfs.h
+++ linux-2.6.22.14/include/linux/sysfs.h
@@ -125,6 +125,7 @@ void sysfs_remove_file_from_group(struct
 		const struct attribute *attr, const char *group);
 
 void sysfs_notify(struct kobject * k, char *dir, char *attr);
+void sysfs_printk_last_file(void);
 
 
 extern int sysfs_make_shadowed_dir(struct kobject *kobj,
@@ -240,6 +241,11 @@ static inline int __must_check sysfs_ini
 	return 0;
 }
 
+static inline void sysfs_printk_last_file(void)
+{
+	;
+}
+
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */
