Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbYFESlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbYFESlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYFESlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:41:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49082 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbYFESlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:41:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=N52DEtZZMKfTjr0C6fiZs0bApAFgjP75MmlKM5X4z49Iuoimv3VlNPx67Miqr2Z0r
	G89V21pdOcUL9LLMGXrww==
Message-ID: <4ca0a85e0806051140m4709cddat793f72043cccc17@mail.gmail.com>
Date: Thu, 5 Jun 2008 14:40:59 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] pagemap: Add documentation for pagemap
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a quick explanation of the pagemap interface from a userspace point
of view, and an example of how to use it (in English, not code).

Signed-off-by: Thomas  Tuttle
---
 Documentation/vm/pagemap.txt |   77 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/vm/pagemap.txt

diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
new file mode 100644
index 0000000..b33a5e4
--- /dev/null
+++ b/Documentation/vm/pagemap.txt
@@ -0,0 +1,77 @@
+pagemap, from the userspace perspective
+---------------------------------------
+
+pagemap is a new (as of 2.6.25) set of interfaces in the kernel that allow
+userspace programs to examine the page tables and related information by
+reading files in /proc.
+
+There are three components to pagemap:
+
+ * /proc/pid/pagemap.  This file lets a userspace process find out which
+   physical frame each virtual page is mapped to.  It contains one 64-bit
+   value for each virtual page, containing the following data (from
+   fs/proc/task_mmu.c, above pagemap_read):
+
+    * Bits 0-55  page frame number (PFN) if present
+    * Bits 0-4   swap type if swapped
+    * Bits 5-55  swap offset if swapped
+    * Bits 55-60 page shift (page size = 1<<page shift)
+    * Bit  61    reserved for future use
+    * Bit  62    page swapped
+    * Bit  63    page present
+
+   If the page is not present but in swap, then the PFN contains an
+   encoding of the swap file number and the page's offset into the
+   swap. Unmapped pages return a null PFN. This allows determining
+   precisely which pages are mapped (or in swap) and comparing mapped
+   pages between processes.
+
+   Efficient users of this interface will use /proc/pid/maps to
+   determine which areas of memory are actually mapped and llseek to
+   skip over unmapped regions.
+
+ * /proc/kpagecount.  This file contains a 64-bit count of the number of
+   times each page is mapped, indexed by PFN.
+
+ * /proc/kpageflags.  This file contains a 64-bit set of flags for each
+   page, indexed by PFN.
+
+   The flags are (from fs/proc/proc_misc, above kpageflags_read):
+
+     0. LOCKED
+     1. ERROR
+     2. REFERENCED
+     3. UPTODATE
+     4. DIRTY
+     5. LRU
+     6. ACTIVE
+     7. SLAB
+     8. WRITEBACK
+     9. RECLAIM
+    10. BUDDY
+
+Using pagemap to do something useful:
+
+The general procedure for using pagemap to find out about a process' memory
+usage goes like this:
+
+ 1. Read /proc/pid/maps to determine which parts of the memory space are
+    mapped to what.
+ 2. Select the maps you are interested in -- all of them, or a particular
+    library, or the stack or the heap, etc.
+ 3. Open /proc/pid/pagemap and seek to the pages you would like to examine.
+ 4. Read a u64 for each page from pagemap.
+ 5. Open /proc/kpagecount and/or /proc/kpageflags.  For each PFN you just
+    read, seek to that entry in the file, and read the data you want.
+
+For example, to find the "unique set size" (USS), which is the amount of
+memory that a process is using that is not shared with any other process,
+you can go through every map in the process, find the PFNs, look those up
+in kpagecount, and tally up the number of pages that are only referenced
+once.
+
+Other notes:
+
+Reading from any of the files will return -EINVAL if you are not starting
+the read on an 8-byte boundary (e.g., if you seeked an odd number of bytes
+into the file), or if the size of the read is not a multiple of 8 bytes.
--
1.5.3.6
