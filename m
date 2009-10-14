Return-Path: <linux-kernel-owner+w=401wt.eu-S1762002AbZJNS4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002AbZJNS4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbZJNS4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:56:21 -0400
Received: from vena.lwn.net ([206.168.112.25]:49775 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbZJNS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:56:20 -0400
Date: Wed, 14 Oct 2009 12:55:42 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH] update flex_array document
Message-ID: <20091014125542.53dfe602@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I promised I would update this document for the 2.6.32 changes.
Amazingly enough, I actually did it; results below.  If nobody objects,
I'll send this upward shortly.

jon
---
Update flex_arrays.txt

The 2.6.32 merge window brought a number of changes to the flexible array
API; this patch updates the documentation to match the new state of
affairs.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/flexible-arrays.txt |   43 +++++++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/Documentation/flexible-arrays.txt b/Documentation/flexible-arrays.txt
index 84eb268..cb8a3a0 100644
--- a/Documentation/flexible-arrays.txt
+++ b/Documentation/flexible-arrays.txt
@@ -1,5 +1,5 @@
 Using flexible arrays in the kernel
-Last updated for 2.6.31
+Last updated for 2.6.32
 Jonathan Corbet <corbet@lwn.net>
 
 Large contiguous memory allocations can be unreliable in the Linux kernel.
@@ -40,6 +40,13 @@ argument is passed directly to the internal memory allocation calls.  With
 the current code, using flags to ask for high memory is likely to lead to
 notably unpleasant side effects.
 
+It is also possible to define flexible arrays at compile time with:
+
+    DEFINE_FLEX_ARRAY(name, element_size, total);
+
+This macro will result in a definition of an array with the given name; the
+element size and total will be checked for validity at compile time.
+
 Storing data into a flexible array is accomplished with a call to:
 
     int flex_array_put(struct flex_array *array, unsigned int element_nr,
@@ -76,16 +83,30 @@ particular element has never been allocated.
 Note that it is possible to get back a valid pointer for an element which
 has never been stored in the array.  Memory for array elements is allocated
 one page at a time; a single allocation could provide memory for several
-adjacent elements.  The flexible array code does not know if a specific
-element has been written; it only knows if the associated memory is
-present.  So a flex_array_get() call on an element which was never stored
-in the array has the potential to return a pointer to random data.  If the
-caller does not have a separate way to know which elements were actually
-stored, it might be wise, at least, to add GFP_ZERO to the flags argument
-to ensure that all elements are zeroed.
-
-There is no way to remove a single element from the array.  It is possible,
-though, to remove all elements with a call to:
+adjacent elements.  Flexible array elements are normally initialized to the
+value FLEX_ARRAY_FREE (defined as 0x6c in <linux/poison.h>), so errors
+involving that number probably result from use of unstored array entries.
+Note that, if array elements are allocated with __GFP_ZERO, they will be
+initialized to zero and this poisoning will not happen.
+
+Individual elements in the array can be cleared with:
+
+    int flex_array_clear(struct flex_array *array, unsigned int element_nr);
+
+This function will set the given element to FLEX_ARRAY_FREE and return
+zero.  If storage for the indicated element is not allocated for the array,
+flex_array_clear() will return -EINVAL instead.  Note that clearing an
+element does not release the storage associated with it; to reduce the
+allocated size of an array, call:
+
+    int flex_array_shrink(struct flex_array *array);
+
+The return value will be the number of pages of memory actually freed.
+This function works by scanning the array for pages containing nothing but
+FLEX_ARRAY_FREE bytes, so (1) it can be expensive, and (2) it will not work
+if the array's pages are allocated with __GFP_ZERO.
+
+It is possible to remove all elements of an array with a call to:
 
     void flex_array_free_parts(struct flex_array *array);
 
-- 
1.6.2.5

