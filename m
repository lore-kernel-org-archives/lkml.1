Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZIHX4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZIHX4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZIHX4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:56:05 -0400
Received: from vena.lwn.net ([206.168.112.25]:44348 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZIHX4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:56:04 -0400
Date: Tue, 8 Sep 2009 17:56:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH] Document flexible arrays
Message-ID: <20090908175603.2bb02032@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 16:35:10 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Should it be helpful: I wrote an overview of the flex_array API here:
> 
> 	http://lwn.net/Articles/345273/
> 
> I could format it up for addition to Documentation/ if people want.

Well, it only took me a few weeks...  For the curious, here's a
document for flexible arrays as found in 2.6.31.  Barring objections,
I'll drop it into my docs tree and send it during the upcoming merge
window.

jon

---
Document the flex_array library.

A brief document on how to use flexible arrays, derived from an article
first published on LWN.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/flexible-arrays.txt |   99 +++++++++++++++++++++++++++++++++++++
 1 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/flexible-arrays.txt

diff --git a/Documentation/flexible-arrays.txt b/Documentation/flexible-arrays.txt
new file mode 100644
index 0000000..39b891b
--- /dev/null
+++ b/Documentation/flexible-arrays.txt
@@ -0,0 +1,99 @@
+Using flexible arrays in the kernel
+Last updated for 2.6.31
+Jonathan Corbet <corbet@lwn.net>
+
+Large contiguous memory allocations can be unreliable in the Linux kernel.
+Kernel programmers will sometimes respond to this problem by allocating
+pages with vmalloc().  This solution not ideal, though.  On 32-bit systems,
+memory from vmalloc() must be mapped into a relatively small address space;
+it's easy to run out.  On SMP systems, the page table changes required by
+vmalloc() allocations can require expensive cross-processor interrupts on
+all CPUs.  And, on all systems, use of space in the vmalloc() range
+increases pressure on the translation lookaside buffer (TLB), reducing the
+performance of the system.
+
+In many cases, the need for memory from vmalloc() can be eliminated by
+piecing together an array from smaller parts; the flexible array library
+exists to make this task easier.
+
+A flexible array holds an arbitrary (within limits) number of fixed-sized
+objects, accessed via an integer index.  Sparse arrays are handled
+reasonably well.  Only single-page allocations are made, so memory
+allocation failures should be relatively rare.  The down sides are that the
+arrays cannot be indexed directly, individual object size cannot exceed the
+system page size, and putting data into a flexible array requires a copy
+operation.  It's also worth noting that flexible arrays do no internal
+locking at all; if concurrent access to an array is possible, then the
+caller must arrange for appropriate mutual exclusion.
+
+The creation of a flexible array is done with:
+
+    #include <linux/flex_array.h>
+
+    struct flex_array *flex_array_alloc(int element_size,
+					unsigned int total,
+					gfp_t flags);
+
+The individual object size is provided by element_size, while total is the
+maximum number of objects which can be stored in the array.  The flags
+argument is passed directly to the internal memory allocation calls.  With
+the current code, using flags to ask for high memory is likely to lead to
+notably unpleasant side effects.
+
+Storing data into a flexible array is accomplished with a call to:
+
+    int flex_array_put(struct flex_array *array, unsigned int element_nr,
+    		       void *src, gfp_t flags);
+
+This call will copy the data from src into the array, in the position
+indicated by element_nr (which must be less than the maximum specified when
+the array was created).  If any memory allocations must be performed, flags
+will be used.  The return value is zero on success, a negative error code
+otherwise.
+
+There might possibly be a need to store data into a flexible array while
+running in some sort of atomic context; in this situation, sleeping in the
+memory allocator would be a bad thing.  That can be avoided by using
+GFP_ATOMIC for the flags value, but, often, there is a better way.  The
+trick is to ensure that any needed memory allocations are done before
+entering atomic context, using:
+
+    int flex_array_prealloc(struct flex_array *array, unsigned int start,
+			    unsigned int end, gfp_t flags);
+
+This function will ensure that memory for the elements indexed in the range
+defined by start and end has been allocated.  Thereafter, a
+flex_array_put() call on an element in that range is guaranteed not to
+block.
+
+Getting data back out of the array is done with:
+
+    void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
+
+The return value is a pointer to the data element, or NULL if that
+particular element has never been allocated.
+
+Note that it is possible to get back a valid pointer for an element which
+has never been stored in the array.  Memory for array elements is allocated
+one page at a time; a single allocation could provide memory for several
+adjacent elements.  The flexible array code does not know if a specific
+element has been written; it only knows if the associated memory is
+present.  So a flex_array_get() call on an element which was never stored
+in the array has the potential to return a pointer to random data.  If the
+caller does not have a separate way to know which elements were actually
+stored, it might be wise, at least, to add GFP_ZERO to the flags argument
+to ensure that all elements are zeroed.
+
+There is no way to remove a single element from the array.  It is possible,
+though, to remove all elements with a call to:
+
+    void flex_array_free_parts(struct flex_array *array);
+
+This call frees all elements, but leaves the array itself in place.
+Freeing the entire array is done with:
+
+    void flex_array_free(struct flex_array *array);
+
+As of this writing, there are no users of flexible arrays in the mainline
+kernel.  The functions described here are also not exported to modules;
+that will probably be fixed when somebody comes up with a need for it.
-- 
1.6.2.5

