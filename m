Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXLUHje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXLUHje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXLUHjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:39:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:37935 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbXLUHjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:39:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,193,1196668800"; 
   d="scan'208";a="244169269"
Subject: [PATCH 2/3 -mm] kexec jump -v8 : add write support to oldmem device
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Dec 2007 15:33:40 +0800
Message-Id: <1198222420.1965.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Dec 2007 07:38:18.0502 (UTC) FILETIME=[744DEA60:01C843A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds writing support for /dev/oldmem. This can be used to

- Communicate between original kernel and kexeced kernel through write
  to some pages in original kernel.

- Restore the memory contents of hibernated system in kexec based
  hibernation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/crash_dump_32.c |   27 +++++++++++++++++++++++++++
 drivers/char/mem.c              |   32 ++++++++++++++++++++++++++++++++
 include/linux/crash_dump.h      |    2 ++
 3 files changed, 61 insertions(+)

--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -59,6 +59,33 @@ ssize_t copy_oldmem_page(unsigned long p
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
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -11,6 +11,8 @@
 extern unsigned long long elfcorehdr_addr;
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
+extern ssize_t write_oldmem_page(unsigned long, const char *, size_t,
+				 unsigned long, int);
 extern const struct file_operations proc_vmcore_operations;
 extern struct proc_dir_entry *proc_vmcore;
 
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -348,6 +348,37 @@ static ssize_t read_oldmem(struct file *
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
@@ -783,6 +814,7 @@ static const struct file_operations full
 #ifdef CONFIG_CRASH_DUMP
 static const struct file_operations oldmem_fops = {
 	.read	= read_oldmem,
+	.write	= write_oldmem,
 	.open	= open_oldmem,
 };
 #endif

