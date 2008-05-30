Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYFEJ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYFEJ4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYFEJxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:53:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbYFEJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:53:22 -0400
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080605.foo@pmac.infradead.org>
References: <20080605.foo@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
Date: Fri, 30 May 2008 13:57:27 +0300
Subject: [PATCH 10/18] ihex.h: binary representation of ihex records
Message-Id: <E1K4C9q-0001dA-5i@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices need their firmware as a set of {address, len, data...}
records in some specific order rather than a simple blob.

The normal way of doing this kind of thing is 'ihex', which is a text
format and not entirely suitable for use in the kernel.

This provides a binary representation which is very similar, but much
more compact -- and a helper routine to skip to the next record,
because the alignment constraints mean that everybody will screw it up
for themselves otherwise.

Also a helper function which can verify that a 'struct firmware'
contains a valid set of ihex records, and that following them won't run
off the end of the loaded data.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 include/linux/ihex.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/ihex.h

diff --git a/include/linux/ihex.h b/include/linux/ihex.h
new file mode 100644
index 0000000..3da4855
--- /dev/null
+++ b/include/linux/ihex.h
@@ -0,0 +1,44 @@
+/*
+ * Compact binary representation of ihex records. Some devices need their
+ * firmware loaded in strange orders rather than a single big blob, but 
+ * actually parsing ihex-as-text within the kernel seems silly. Thus,...
+ */
+
+#ifndef __LINUX_IHEX_H__
+#define __LINUX_IHEX_H__
+
+#include <linux/types.h>
+#include <linux/firmware.h>
+
+struct ihex_binrec {
+	__be32 addr;
+	uint8_t len;
+	uint8_t data[0];
+} __attribute__((aligned(4)));
+
+/* Find the next record, taking into account the 4-byte alignment */
+static inline const struct ihex_binrec *
+ihex_next_binrec(const struct ihex_binrec *rec)
+{
+	int next = ((rec->len + 4) & ~3) - 1;
+	rec = (void *)&rec->data[next];
+
+	return rec->len ? rec : NULL;
+}
+
+/* Check that ihex_next_binrec() won't take us off the end of the image... */
+static inline int ihex_validate_fw(const struct firmware *fw)
+{
+	const struct ihex_binrec *rec, *end;
+
+	rec = (void *)fw->data;
+	end = (void *)fw->data + fw->size - 4;
+
+	while (rec) {
+		if (rec >= end)
+			return -EINVAL;
+		rec = ihex_next_binrec(rec);
+	}
+	return 0;
+}
+#endif /* __LINUX_IHEX_H__ */
-- 
1.5.4.5

