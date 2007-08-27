Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbXH0BOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbXH0BOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbXH0BOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:14:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:28382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXH0BOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,309,1183359600"; 
   d="scan'208";a="268264297"
Subject: [RFC][PATCH 2/2 -mm] kexec based hibernation: kexec restore
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Aug 2007 09:14:56 +0800
Message-Id: <1188177296.3247.38.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 27 Aug 2007 01:14:00.0268 (UTC) FILETIME=[8C9BA0C0:01C7E847]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds writing support for /dev/oldmem. This is used to
restore the memory contents of hibernated system.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/i386/kernel/crash_dump.c |   27 +++++++++++++++++++++++++++
 drivers/char/mem.c            |   32 ++++++++++++++++++++++++++++++++
 include/linux/crash_dump.h    |    2 ++
 3 files changed, 61 insertions(+)

Index: linux-2.6.23-rc3/arch/i386/kernel/crash_dump.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/i386/kernel/crash_dump.c	2007-08-25 21:56:52.000000000 +0800
+++ linux-2.6.23-rc3/arch/i386/kernel/crash_dump.c	2007-08-25 21:57:11.000000000 +0800
@@ -58,6 +58,33 @@
 	return csize;
 }
 
+ssize_t write_oldmem_page(unsigned long pfn, const char *buf,
+			  size_t csize, unsigned long offset, int userbuf)
+{
+	void  *vaddr;
+
+	if (!csize)
+		return 0;
+
+	if (!userbuf) {
+		vaddr = kmap_atomic_pfn(pfn, KM_PTE0);
+		memcpy(vaddr + offset, buf, csize);
+	} else {
+		if (!kdump_buf_page) {
+			printk(KERN_WARNING "Kdump: Kdump buffer page not"
+				" allocated\n");
+			return -EFAULT;
+		}
+		if (copy_from_user(kdump_buf_page, buf, csize))
+			return -EFAULT;
+		vaddr = kmap_atomic_pfn(pfn, KM_PTE0);
+		memcpy(vaddr + offset, kdump_buf_page, csize);
+	}
+	kunmap_atomic(vaddr, KM_PTE0);
+
+	return csize;
+}
+
 static int __init kdump_buf_page_init(void)
 {
 	int ret = 0;
Index: linux-2.6.23-rc3/include/linux/crash_dump.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/crash_dump.h	2007-08-25 21:56:52.000000000 +0800
+++ linux-2.6.23-rc3/include/linux/crash_dump.h	2007-08-25 21:57:11.000000000 +0800
@@ -11,6 +11,8 @@
 extern unsigned long long elfcorehdr_addr;
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+extern ssize_t write_oldmem_page(unsigned long, const char *, size_t,
+				 unsigned long, int);
 extern const struct file_operations proc_vmcore_operations;
 extern struct proc_dir_entry *proc_vmcore;
 
Index: linux-2.6.23-rc3/drivers/char/mem.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/char/mem.c	2007-08-25 21:56:52.000000000 +0800
+++ linux-2.6.23-rc3/drivers/char/mem.c	2007-08-25 21:57:11.000000000 +0800
@@ -348,6 +348,37 @@
 	}
 	return read;
 }
+
+/*
+ * Write memory corresponding to the old kernel.
+ */
+static ssize_t write_oldmem(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	unsigned long pfn, offset;
+	size_t write = 0, csize;
+	int rc = 0;
+
+	while (count) {
+		pfn = *ppos / PAGE_SIZE;
+		if (pfn > saved_max_pfn)
+			return write;
+
+		offset = (unsigned long)(*ppos % PAGE_SIZE);
+		if (count > PAGE_SIZE - offset)
+			csize = PAGE_SIZE - offset;
+		else
+			csize = count;
+		rc = write_oldmem_page(pfn, buf, csize, offset, 1);
+		if (rc < 0)
+			return rc;
+		buf += csize;
+		*ppos += csize;
+		write += csize;
+		count -= csize;
+	}
+	return write;
+}
 #endif
 
 extern long vread(char *buf, char *addr, unsigned long count);
@@ -783,6 +814,7 @@
 #ifdef CONFIG_CRASH_DUMP
 static const struct file_operations oldmem_fops = {
 	.read	= read_oldmem,
+	.write	= write_oldmem,
 	.open	= open_oldmem,
 };
 #endif
