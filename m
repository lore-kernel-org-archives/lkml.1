Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYKTLbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYKTLbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYKTLao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:30:44 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47326 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbYKTLam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:30:42 -0500
Subject: [PATCH 2.6.28-rc5 02/11] kmemleak: Add documentation on the memory
	leak detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:30:39 +0000
Message-ID: <20081120113039.16607.68994.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:30:40.0056 (UTC) FILETIME=[6A807B80:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Documentation/kmemleak.txt file with some
information about how kmemleak works.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |  125 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/kmemleak.txt

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
new file mode 100644
index 0000000..bf985df
--- /dev/null
+++ b/Documentation/kmemleak.txt
@@ -0,0 +1,125 @@
+Kernel Memory Leak Detector
+===========================
+
+Introduction
+------------
+
+Kmemleak provides a way of detecting possible kernel memory leaks in a
+way similar to a tracing garbage collector
+(http://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29#Tracing_garbage_collectors),
+with the difference that the orphan objects are not freed but only
+reported via /sys/kernel/debug/memleak. A similar method is used by
+the Valgrind tool (memcheck --leak-check) to detect the memory leaks
+in user-space applications.
+
+Usage
+-----
+
+CONFIG_DEBUG_MEMLEAK in "Kernel hacking" has to be enabled. To display
+the possible memory leaks:
+
+  # mount -t debugfs nodev /sys/kernel/debug/
+  # cat /sys/kernel/debug/memleak
+
+In order to reduce the run-time overhead, memory scanning is only
+performed when reading the /sys/kernel/debug/memleak file. Note that
+the orphan objects are listed in the order they were allocated and one
+object at the beginning of the list may cause other subsequent objects
+to be reported as orphan.
+
+Basic Algorithm
+---------------
+
+The memory allocations via kmalloc, vmalloc, kmem_cache_alloc and
+friends are tracked and the pointers, together with additional
+information like size and stack trace, are stored in a prio search
+tree. The corresponding freeing function calls are tracked and the
+pointers removed from the kmemleak data structures.
+
+An allocated block of memory is considered orphan if no pointer to its
+start address or to any location inside the block can be found by
+scanning the memory (including saved registers). This means that there
+might be no way for the kernel to pass the address of the allocated
+block to a freeing function and therefore the block is considered a
+memory leak.
+
+The scanning algorithm steps:
+
+  1. mark all objects as white (remaining white objects will later be
+     considered orphan)
+  2. scan the memory starting with the data section and stacks,
+     checking the values against the addresses stored in the hash
+     table. If a pointer to a white object is found, the object is
+     added to the grey list
+  3. scan the grey objects for matching addresses (some white objects
+     can become grey and added at the end of the grey list) until the
+     grey set is finished
+  4. the remaining white objects are considered orphan and reported
+     via /sys/kernel/debug/memleak
+
+Some allocated memory blocks have pointers stored in the kernel's
+internal data structures and they cannot be detected as orphans. To
+avoid this, kmemleak can also store the number of values pointing to
+an address inside the block address range that need to be found so
+that the block is not considered a leak. One example is __vmalloc().
+
+Limitations and Drawbacks
+-------------------------
+
+The biggest drawback is the reduced performance of memory allocation
+and freeing. To avoid other penalties, the memory scanning is only
+performed when the /sys/kernel/debug/memleak file is read. Anyway,
+this tool is intended for debugging purposes where the performance
+might not be the most important requirement.
+
+To keep the algorithm simple, kmemleak scans for values pointing to
+any address inside a block's address range. This may lead to an
+increased number of false negatives. However, it is likely that a
+realy memory leak will eventually become visible.
+
+Another source of false negatives is the data stored in non-pointer
+values. In a future version, kmemleak could only scan the pointer
+members in the allocated structures. This feature would solve many of
+the false negative cases described above.
+
+The tool can report false positives. These are cases where an
+allocated block doesn't need to be freed (some cases in the init_call
+functions), the pointer is calculated by other methods than the usual
+container_of macro or the pointer is stored in a location not scanned
+by kmemleak.
+
+Page allocations and ioremap are not tracked. Only the ARM and i386
+architectures are currently supported.
+
+Kmemleak API
+------------
+
+See the include/linux/memleak.h header for the functions prototype.
+
+memleak_init		- initialize kmemleak
+memleak_alloc		- notify of a memory block allocation
+memleak_free		- notify of a memory block freeing
+memleak_not_leak	- mark an object as not a leak
+memleak_ignore		- do not scan or report an object as leak
+memleak_scan_area	- add scan areas inside a memory block
+memleak_erase		- erase an old value in a pointer variable
+
+Dealing with false positives/negatives
+--------------------------------------
+
+To reduce the false negatives, kmemleak provides the memleak_ignore,
+memleak_scan_area and memleak_erase functions. The task stacks also
+increase the amount of false negatives and their scanning is not
+enabled by default.
+
+For objects known not to be leaks, kmemleak provides the
+memleak_not_leak function. The memleak_ignore could also be used if
+the memory block is known not to contain other pointers and it will no
+longer be scanned.
+
+Some of the reported leaks are only transient because of pointers
+temporarily stored in CPU registers or stacks. Kmemleak defines
+REPORT_THLD (defaulting to 1) representing the detection threshold
+after which the block is reported as a memory leak. This value may
+need to be increased if transient leaks are reported frequently,
+especially on SMP systems.

