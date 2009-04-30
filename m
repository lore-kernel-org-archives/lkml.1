Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbZD3Ryd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbZD3Ryd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbZD3RbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:31:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:43705 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbZD3RbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:31:20 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] Implement trivial struct feature macros
Date: Thu, 30 Apr 2009 19:31:17 +0200
Message-Id: <1241112678-6615-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241112678-6615-1-git-send-email-jack@suse.cz>
References: <1241112678-6615-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is useful to have a generic main structure (like struct inode)
and then with some of these structures you want to associate additional
information (like quota information, block device information etc.).
Traditionally, we solved this by having a pointer to associated data in
the generic structure. This gets inefficient when there are lots of
various kinds of data that can be associated with the generic structure
(we need one pointer per type of associated information). This is an
attempt to address the issue.

The idea is simple. There is some chunk of allocated memory that contains
the generic structure and all the associated information. The generic
structure has a pointer to the (usually static) table of offsets (from
the beginning of the generic structure) of associated structures for
each possible associated structure type.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h             |    5 +++++
 include/linux/struct_feature.h |   12 ++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/struct_feature.h

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..2404b16 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -710,6 +710,10 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
 #define i_size_ordered_init(inode) do { } while (0)
 #endif
 
+enum {
+	INODE_FEATURES
+};
+
 struct inode {
 	struct hlist_node	i_hash;
 	struct list_head	i_list;
@@ -775,6 +779,7 @@ struct inode {
 	void			*i_security;
 #endif
 	void			*i_private; /* fs or device private pointer */
+	int			*feature_table;
 };
 
 /*
diff --git a/include/linux/struct_feature.h b/include/linux/struct_feature.h
new file mode 100644
index 0000000..0849d3d
--- /dev/null
+++ b/include/linux/struct_feature.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_STRUCT_FEATURE_H
+#define _LINUX_STRUCT_FEATURE_H
+
+
+#define FEATURE_OFFSET(str, generic, feature) (offsetof(str, feature) - offsetof(str, generic))
+
+#define GET_FEATURE(generic, feature) \
+	((generic)->feature_table && (generic)->feature_table[feature] ? \
+	((void *)(((char *)(generic)) + (generic)->feature_table[feature])) : \
+	NULL)
+
+#endif
-- 
1.6.0.2

