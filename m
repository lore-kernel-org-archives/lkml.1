Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYH3Ufm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYH3Ufm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYH3Ufe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:35:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:56373 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYH3Ufd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qs+6LnZwotWf+CAOEZfF3z8suXByxeNIEaHtCUD5Z9k3P2eC7ZBP5p6JEfq5dgAWzf
         Fl1fTqgF4OA6liFOesBVDaoi0IWams9Q1sDCDy5Uq6dsqaQJceyycly9Zo6mdDiW1yOK
         njJIlppO+CidThh8+OoCUsQXP74LIvnjbcL2s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
Date: Sat, 30 Aug 2008 13:34:34 -0700
Message-Id: <1220128474-23115-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try to insert_resource second time, by expand the resource...

for case: e820 reserved entry is partially overlapped with bar res...

hope it will never happen

v2: according to Linus, add insert_resource_expand_to_fit, and change
	__insert_resource to static without lock

v3: use reserve_region_with_split() instead to hand overlapping
	with test case by extend 0xe0000000 - 0xeffffff to 0xdd800000 -
	get
		e0000000-efffffff : PCI MMCONFIG 0
			 e0000000-efffffff : reserved
	in /proc/iomem
	get
		found conflict for reserved [dd800000, efffffff], try to reserve with split
		    __reserve_region_with_split: (PCI Bus #80) [dd000000, ddffffff], res: (reserved) [dd800000, efffffff]
		    __reserve_region_with_split: (PCI Bus #00) [de000000, dfffffff], res: (reserved) [de000000, efffffff]
		initcall pci_subsys_init+0x0/0x121 returned 0 after 381 msecs
	in dmesg

v4: take out __insert_resource and insert_resource_expand_to_fit : Linus already check in.
    use reserve_region_with_split at the first point
    use const char *name

v5: fix checking on overlapping

v6: only reserve common area in conflict
	so got sth in /proc/iomem
		d8000000-dfffffff : PCI Bus #00
		  dc000000-dfffffff : GART
		    dc000000-dfffffff : reserved
		e0000000-efffffff : PCI MMCONFIG 0
		  e0000000-efffffff : reserved
	when we have big range in e820
		00000000dc000000-00000000f0000000 (reserved)

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |    2 -
 include/linux/ioport.h |    3 ++
 kernel/resource.c      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1320,7 +1320,7 @@ void __init e820_reserve_resources_late(
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
 		if (!res->parent && res->end)
-			insert_resource(&iomem_resource, res);
+			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
 		res++;
 	}
 }
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h
+++ linux-2.6/include/linux/ioport.h
@@ -108,6 +108,9 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+extern void reserve_region_with_split(struct resource *root,
+			     resource_size_t start, resource_size_t end,
+			     const char *name);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -512,10 +512,77 @@ int adjust_resource(struct resource *res
 	result = 0;
 
  out:
-	write_unlock(&resource_lock);
 	return result;
 }
 
+static void __init __reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	struct resource *parent = root;
+	struct resource *conflict;
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+
+	if (!res)
+		return;
+
+	res->name = name;
+	res->start = start;
+	res->end = end;
+	res->flags = IORESOURCE_BUSY;
+
+	for (;;) {
+		conflict = __request_resource(parent, res);
+		if (!conflict)
+			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
+		}
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
+	}
+
+	if (!res) {
+		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
+			 conflict->name, conflict->start, conflict->end,
+			 name, start, end);
+
+		/* failed, split and try again */
+
+		/* conflict coverred whole area */
+		if (conflict->start <= start && conflict->end >= end)
+			return;
+
+		if (conflict->start > start)
+			__reserve_region_with_split(root, start, conflict->start-1, name);
+		if (!(conflict->flags & IORESOURCE_BUSY)) {
+			resource_size_t common_start, common_end;
+
+			common_start = max(conflict->start, start);
+			common_end = min(conflict->end, end);
+			if (common_start < common_end)
+				__reserve_region_with_split(root, common_start, common_end, name);
+		}
+		if (conflict->end < end)
+			__reserve_region_with_split(root, conflict->end+1, end, name);
+	}
+
+}
+
+void reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name);
+	write_unlock(&resource_lock);
+}
+
 EXPORT_SYMBOL(adjust_resource);
 
 /**
