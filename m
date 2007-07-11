Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbXGKTEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbXGKTEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXGKTEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:04:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760370AbXGKTEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:04:41 -0400
From: Roland McGrath <roland@frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Add /sys/kernel/notes
X-Windows: it could be worse, but it'll take time.
Message-Id: <20070711190434.D0F0C4D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 12:04:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the /sys/kernel/notes magic file.  Reading this delivers
the contents of the kernel's .notes section.  This lets userland easily
glean any detailed information about the running kernel's build that was
stored there at compile time.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ksysfs.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 559deca..873fc17 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -62,6 +62,28 @@ static ssize_t kexec_crash_loaded_show(struct kset *kset, char *page)
 KERNEL_ATTR_RO(kexec_crash_loaded);
 #endif /* CONFIG_KEXEC */
 
+/*
+ * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
+ */
+extern const char __start_notes __attribute__((weak));
+extern const char __stop_notes __attribute__((weak));
+#define	notes_size (&__stop_notes - &__start_notes)
+
+static ssize_t notes_read(struct kobject *kobj,
+			  char *buf, loff_t off, size_t count)
+{
+	memcpy(buf, &__start_notes + off, count);
+	return count;
+}
+
+static struct bin_attribute notes_attr = {
+	.attr = {
+		.name = "notes",
+		.mode = S_IRUGO,
+	},
+	.read = &notes_read,
+};
+
 decl_subsys(kernel, NULL, NULL);
 EXPORT_SYMBOL_GPL(kernel_subsys);
 
@@ -88,6 +110,12 @@ static int __init ksysfs_init(void)
 		error = sysfs_create_group(&kernel_subsys.kobj,
 					   &kernel_attr_group);
 
+	if (!error && notes_size > 0) {
+		notes_attr.size = notes_size;
+		error = sysfs_create_bin_file(&kernel_subsys.kobj,
+					      &notes_attr);
+	}
+
 	return error;
 }
 
