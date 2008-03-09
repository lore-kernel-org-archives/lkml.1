Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYCIKUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYCIKUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYCIKUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:20:41 -0400
Received: from www.tglx.de ([62.245.132.106]:34065 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYCIKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:20:40 -0400
Date: Sun, 9 Mar 2008 11:19:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: quicklists confuse meminfo
Message-ID: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart reported http://bugzilla.kernel.org/show_bug.cgi?id=9991. He
assumed a memory leak in 32bit kernels when he analyzed the output of
/proc/meminfo.

The leak is not a leak, it's an accounting bug. quicklists keep a
large amount of pages which are accounted as used memory.

It can be easily observed by watching /proc/meminfo on an idle system
and then run

# while true; do ls >/dev/null; done

for a while. The amount of free memory decreases steadily to the
point, where the quicklist limit kicks in.

To verify this I added quicklists (patch below) to the /proc/meminfo
output and the decrease of free memory is matching the increase of the
memory which is kept in quicklists.

I'm not sure how we should handle the quicklist accounting, but the
current state of silently hiding the free memory in the quicklists is
definitely not acceptable.

Another strange observation about quicklists is the imbalance of the
quicklists across CPUs. Running the above loop on a 2way machine I can
observe that the quicklist pages are acuumulating on one CPU. Stopping
and restarting the loop a couple of times can shift the accumulation
from one to the other CPU.

Thanks,
	tglx

---
 fs/proc/proc_misc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_misc.c
+++ linux-2.6/fs/proc/proc_misc.c
@@ -49,6 +49,8 @@
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
 #include <linux/bootmem.h>
+#include <linux/quicklist.h>
+
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -183,8 +185,11 @@ static int meminfo_read_proc(char *page,
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
 		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n",
-		K(i.totalram),
+		"VmallocChunk: %8lu kB\n"
+#ifdef CONFIG_QUICKLIST
+		"QuickLists:   %8lu kB\n"
+#endif
+		,K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
 		K(cached),
@@ -215,6 +220,9 @@ static int meminfo_read_proc(char *page,
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
 		vmi.largest_chunk >> 10
+#ifdef CONFIG_QUICKLIST
+		,K(quicklist_total_size())
+#endif
 		);
 
 		len += hugetlb_report_meminfo(page + len);

