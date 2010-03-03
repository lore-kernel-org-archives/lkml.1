Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0CCAwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:52:34 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54189 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab0CCAqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:46 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 06/26] ceph: dynamic pagelist buffer
Date: Tue,  2 Mar 2010 16:46:37 -0800
Message-Id: <1267577217-31923-7-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267577217-31923-1-git-send-email-sage@newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ceph_pagelist is a simple linked list of pages for encoding
data into.  Whole pages are allocated and added to the list as needed.
This is used for encoding large outgoing messages when the final
buffer size is known know ahead of time and we do not want to worry
about something like valloc failing due to fragmentation.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/pagelist.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/pagelist.h |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/pagelist.c
 create mode 100644 fs/ceph/pagelist.h

diff --git a/fs/ceph/pagelist.c b/fs/ceph/pagelist.c
new file mode 100644
index 0000000..370e936
--- /dev/null
+++ b/fs/ceph/pagelist.c
@@ -0,0 +1,54 @@
+
+#include <linux/pagemap.h>
+#include <linux/highmem.h>
+
+#include "pagelist.h"
+
+int ceph_pagelist_release(struct ceph_pagelist *pl)
+{
+	if (pl->mapped_tail)
+		kunmap(pl->mapped_tail);
+	while (!list_empty(&pl->head)) {
+		struct page *page = list_first_entry(&pl->head, struct page,
+						     lru);
+		list_del(&page->lru);
+		__free_page(page);
+	}
+	return 0;
+}
+
+static int ceph_pagelist_addpage(struct ceph_pagelist *pl)
+{
+	struct page *page = alloc_page(GFP_NOFS);
+	if (!page)
+		return -ENOMEM;
+	pl->room += PAGE_SIZE;
+	list_add_tail(&page->lru, &pl->head);
+	if (pl->mapped_tail)
+		kunmap(pl->mapped_tail);
+	pl->mapped_tail = kmap(page);
+	return 0;
+}
+
+int ceph_pagelist_append(struct ceph_pagelist *pl, void *buf, size_t len)
+{
+	while (pl->room < len) {
+		size_t bit = pl->room;
+		int ret;
+
+		memcpy(pl->mapped_tail + (pl->length & ~PAGE_CACHE_MASK),
+		       buf, bit);
+		pl->length += bit;
+		pl->room -= bit;
+		buf += bit;
+		len -= bit;
+		ret = ceph_pagelist_addpage(pl);
+		if (ret)
+			return ret;
+	}
+
+	memcpy(pl->mapped_tail + (pl->length & ~PAGE_CACHE_MASK), buf, len);
+	pl->length += len;
+	pl->room -= len;
+	return 0;
+}
diff --git a/fs/ceph/pagelist.h b/fs/ceph/pagelist.h
new file mode 100644
index 0000000..e8a4187
--- /dev/null
+++ b/fs/ceph/pagelist.h
@@ -0,0 +1,54 @@
+#ifndef __FS_CEPH_PAGELIST_H
+#define __FS_CEPH_PAGELIST_H
+
+#include <linux/list.h>
+
+struct ceph_pagelist {
+	struct list_head head;
+	void *mapped_tail;
+	size_t length;
+	size_t room;
+};
+
+static inline void ceph_pagelist_init(struct ceph_pagelist *pl)
+{
+	INIT_LIST_HEAD(&pl->head);
+	pl->mapped_tail = NULL;
+	pl->length = 0;
+	pl->room = 0;
+}
+extern int ceph_pagelist_release(struct ceph_pagelist *pl);
+
+extern int ceph_pagelist_append(struct ceph_pagelist *pl, void *d, size_t l);
+
+static inline int ceph_pagelist_encode_64(struct ceph_pagelist *pl, u64 v)
+{
+	__le64 ev = cpu_to_le64(v);
+	return ceph_pagelist_append(pl, &ev, sizeof(ev));
+}
+static inline int ceph_pagelist_encode_32(struct ceph_pagelist *pl, u32 v)
+{
+	__le32 ev = cpu_to_le32(v);
+	return ceph_pagelist_append(pl, &ev, sizeof(ev));
+}
+static inline int ceph_pagelist_encode_16(struct ceph_pagelist *pl, u16 v)
+{
+	__le16 ev = cpu_to_le16(v);
+	return ceph_pagelist_append(pl, &ev, sizeof(ev));
+}
+static inline int ceph_pagelist_encode_8(struct ceph_pagelist *pl, u8 v)
+{
+	return ceph_pagelist_append(pl, &v, 1);
+}
+static inline int ceph_pagelist_encode_string(struct ceph_pagelist *pl,
+					      char *s, size_t len)
+{
+	int ret = ceph_pagelist_encode_32(pl, len);
+	if (ret)
+		return ret;
+	if (len)
+		return ceph_pagelist_append(pl, s, len);
+	return 0;
+}
+
+#endif
-- 
1.7.0

