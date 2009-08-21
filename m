Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZHUXVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZHUXVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932924AbZHUXVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:21:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbZHUXVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:21:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PY/qTH8S4TyMuOSCvE0f64aaQMLKMDvPGUc3z4lGIaPqv98MjLVPPN4hjq2EvR8+1
	eoifZn1rhwzpVIGi/OLhQ==
Date: Fri, 21 Aug 2009 16:21:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/4 -mm] flex_array: add flex_array_shrink function
In-Reply-To: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0908211621160.28611@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new function to the flex_array API:

	int flex_array_shrink(struct flex_array *fa)

This function will free all unused second-level pages.  Since elements
are now poisoned if they are not allocated with __GFP_ZERO, it's
possible to identify parts that consist solely of unused elements.

flex_array_shrink() returns the number of pages freed.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/flex_array.h |    1 +
 lib/flex_array.c           |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -46,5 +46,6 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 		gfp_t flags);
 int flex_array_clear(struct flex_array *fa, unsigned int element_nr);
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
+int flex_array_shrink(struct flex_array *fa);
 
 #endif /* _FLEX_ARRAY_H */
diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -291,3 +291,43 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
+
+static int part_is_free(struct flex_array_part *part)
+{
+	int i;
+
+	for (i = 0; i < sizeof(struct flex_array_part); i++)
+		if (part->elements[i] != FLEX_ARRAY_FREE)
+			return 0;
+	return 1;
+}
+
+/**
+ * flex_array_shrink - free unused second-level pages
+ *
+ * Frees all second-level pages that consist solely of unused
+ * elements.  Returns the number of pages freed.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_shrink(struct flex_array *fa)
+{
+	struct flex_array_part *part;
+	int max_part = nr_base_part_ptrs();
+	int part_nr;
+	int ret = 0;
+
+	if (elements_fit_in_base(fa))
+		return ret;
+	for (part_nr = 0; part_nr < max_part; part_nr++) {
+		part = fa->parts[part_nr];
+		if (!part)
+			continue;
+		if (part_is_free(part)) {
+			fa->parts[part_nr] = NULL;
+			kfree(part);
+			ret++;
+		}
+	}
+	return ret;
+}
