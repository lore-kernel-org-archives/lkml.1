Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbZHUXVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbZHUXVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbZHUXVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:21:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41028 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZHUXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:21:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HvcGjiA2RUWRgCKmlwuHhFBwm5pAkUr4sp77JReZ9o3LAimJhJQkF3n8txGppFUqT
	bNyiNwMIplOMZoOiqfN+w==
Date: Fri, 21 Aug 2009 16:21:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/4 -mm] flex_array: add flex_array_clear function
In-Reply-To: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new function to the flex_array API:

	int flex_array_clear(struct flex_array *fa,
				unsigned int element_nr)

This function will zero the element at element_nr in the flex_array.

Although this is equivalent to using flex_array_put() and passing a
pointer to zero'd memory, flex_array_clear() does not require such
a pointer to memory that would most likely need to be allocated on
the caller's stack which could be significantly large depending on
element_size.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/flex_array.h |    1 +
 lib/flex_array.c           |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -44,6 +44,7 @@ void flex_array_free(struct flex_array *fa);
 void flex_array_free_parts(struct flex_array *fa);
 int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 		gfp_t flags);
+int flex_array_clear(struct flex_array *fa, unsigned int element_nr);
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
 
 #endif /* _FLEX_ARRAY_H */
diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -207,6 +207,32 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 }
 
 /**
+ * flex_array_clear - clear element in array at @element_nr
+ * @element_nr:	index of the position to clear.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
+{
+	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	struct flex_array_part *part;
+	void *dst;
+
+	if (element_nr >= fa->total_nr_elements)
+		return -ENOSPC;
+	if (elements_fit_in_base(fa))
+		part = (struct flex_array_part *)&fa->parts[0];
+	else {
+		part = fa->parts[part_nr];
+		if (!part)
+			return -EINVAL;
+	}
+	dst = &part->elements[index_inside_part(fa, element_nr)];
+	memset(dst, 0, fa->element_size);
+	return 0;
+}
+
+/**
  * flex_array_prealloc - guarantee that array space exists
  * @start:	index of first array element for which space is allocated
  * @end:	index of last (inclusive) element for which space is allocated
