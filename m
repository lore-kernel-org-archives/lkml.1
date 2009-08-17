Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZHQXqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZHQXqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZHQXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:46:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZHQXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:46:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=eK5IwQy1s+ayC+NdZ5bfuAODtFObU/WyznBnbokUSv+njpsgwS4ILvD73ouIBb+hw
	rMlaEbHbriIzAS3xn0Y3g==
Date: Mon, 17 Aug 2009 16:46:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/3] flex_array: fix get function for elements in base starting
 at non-zero
Message-ID: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all array elements fit into the base structure and data is copied
using flex_array_put() starting at a non-zero index, flex_array_get()
will fail to return the data.

This fixes the bug by only checking for NULL parts when all elements do
not fit in the base structure when flex_array_get() is used.  Otherwise,
fa_element_to_part_nr() will always be 0 since there are no parts
structures needed and such element may never have been put.  Thus, it
will remain NULL due to the kzalloc() of the base.

Additionally, flex_array_put() now only checks for a NULL part when all
elements do not fit in the base structure.  This is otherwise unnecessary
since the base structure is guaranteed to exist (or we would have already
hit a NULL pointer).

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/flex_array.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -198,10 +198,11 @@ int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
-	else
+	else {
 		part = __fa_get_part(fa, part_nr, flags);
-	if (!part)
-		return -ENOMEM;
+		if (!part)
+			return -ENOMEM;
+	}
 	dst = &part->elements[index_inside_part(fa, element_nr)];
 	memcpy(dst, src, fa->element_size);
 	return 0;
@@ -257,11 +258,12 @@ void *flex_array_get(struct flex_array *fa, int element_nr)
 
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
-	if (!fa->parts[part_nr])
-		return NULL;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
-	else
+	else {
 		part = fa->parts[part_nr];
+		if (!part)
+			return NULL;
+	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
