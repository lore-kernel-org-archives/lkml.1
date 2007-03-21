Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXCURs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXCURs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXCURs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:48:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbXCURs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:48:58 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Supply get_unmapped_area() to fix NOMMU SYSV SHM
To: torvalds@osdl.org, akpm@osdl.org, agl@us.ibm.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 21 Mar 2007 17:44:45 +0000
Message-ID: <20070321174445.23664.91613.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Supply a get_unmapped_area() to fix NOMMU SYSV SHM support.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 23fb033..ba6df4d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1193,6 +1193,28 @@ void unmap_mapping_range(struct address_space *mapping,
 EXPORT_SYMBOL(unmap_mapping_range);
 
 /*
+ * ask for an unmapped area at which to create a mapping on a file
+ */
+unsigned long get_unmapped_area(struct file *file, unsigned long addr,
+				unsigned long len, unsigned long pgoff,
+				unsigned long flags)
+{
+	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
+				  unsigned long, unsigned long);
+
+	get_area = current->mm->get_unmapped_area;
+	if (file && file->f_op && file->f_op->get_unmapped_area)
+		get_area = file->f_op->get_unmapped_area;
+
+	if (!get_area)
+		return -ENOSYS;
+
+	return get_area(file, addr, len, pgoff, flags);
+}
+
+EXPORT_SYMBOL(get_unmapped_area);
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.

