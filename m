Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbZHUXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbZHUXVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbZHUXVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:21:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41025 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbZHUXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:21:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=QEQtpJVHotwGlDKBB0Aq1idzqxu0Vf7Vgz+L5q/WK09UThR4BR/aU4QWfyhLLpwO+
	K/yNN0II8veiwAknggGvw==
Date: Fri, 21 Aug 2009 16:21:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/4 -mm] flex_array: convert element_nr formals to unsigned
Message-ID: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's problematic to allow signed element_nr's or total's to be passed as
part of the flex array API.

flex_array_alloc() allows total_nr_elements to be set to a negative
quantity, which is obviously erroneous.

flex_array_get() and flex_array_put() allows negative array indices in
dereferencing an array part, which could address memory mapped before
struct flex_array.

The fix is to convert all existing element_nr formals to be qualified as
unsigned.  Existing checks to compare it to total_nr_elements or the max
array size based on element_size need not be changed.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/flex_array.h |   10 ++++++----
 lib/flex_array.c           |   24 +++++++++++++-----------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -36,12 +36,14 @@ struct flex_array {
 	.total_nr_elements = (total),	\
 } } }
 
-struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags);
-int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags);
+struct flex_array *flex_array_alloc(int element_size, unsigned int total,
+		gfp_t flags);
+int flex_array_prealloc(struct flex_array *fa, unsigned int start,
+		unsigned int end, gfp_t flags);
 void flex_array_free(struct flex_array *fa);
 void flex_array_free_parts(struct flex_array *fa);
-int flex_array_put(struct flex_array *fa, int element_nr, void *src,
+int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 		gfp_t flags);
-void *flex_array_get(struct flex_array *fa, int element_nr);
+void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
 
 #endif /* _FLEX_ARRAY_H */
diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -99,7 +99,8 @@ static inline int elements_fit_in_base(struct flex_array *fa)
  * capacity in the base structure.  Also note that no effort is made
  * to efficiently pack objects across page boundaries.
  */
-struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags)
+struct flex_array *flex_array_alloc(int element_size, unsigned int total,
+					gfp_t flags)
 {
 	struct flex_array *ret;
 	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
@@ -115,7 +116,8 @@ struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags)
 	return ret;
 }
 
-static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
+static int fa_element_to_part_nr(struct flex_array *fa,
+					unsigned int element_nr)
 {
 	return element_nr / __elements_per_part(fa->element_size);
 }
@@ -143,14 +145,12 @@ void flex_array_free(struct flex_array *fa)
 	kfree(fa);
 }
 
-static int fa_index_inside_part(struct flex_array *fa, int element_nr)
+static unsigned int index_inside_part(struct flex_array *fa,
+					unsigned int element_nr)
 {
-	return element_nr % __elements_per_part(fa->element_size);
-}
+	unsigned int part_offset;
 
-static int index_inside_part(struct flex_array *fa, int element_nr)
-{
-	int part_offset = fa_index_inside_part(fa, element_nr);
+	part_offset = element_nr % __elements_per_part(fa->element_size);
 	return part_offset * fa->element_size;
 }
 
@@ -185,7 +185,8 @@ __fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
  *
  * Locking must be provided by the caller.
  */
-int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
+int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
+			gfp_t flags)
 {
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
@@ -217,7 +218,8 @@ int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags
  *
  * Locking must be provided by the caller.
  */
-int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags)
+int flex_array_prealloc(struct flex_array *fa, unsigned int start,
+			unsigned int end, gfp_t flags)
 {
 	int start_part;
 	int end_part;
@@ -248,7 +250,7 @@ int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags)
  *
  * Locking must be provided by the caller.
  */
-void *flex_array_get(struct flex_array *fa, int element_nr)
+void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 {
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
