Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYEKQIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYEKQIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYEKQI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:08:27 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:17903 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYEKQIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:08:25 -0400
Date: Sun, 11 May 2008 18:06:58 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Paul Jackson <pj@sgi.com>, Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: [RFC/PATCH] Make for_each_node_mask out-of-line
Message-ID: <20080511160658.GA3398@mailshack.com>
References: <20080511135039.GA3286@mailshack.com> <20080511091403.a75f5b78.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511091403.a75f5b78.pj@sgi.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sun, 11 May 2008 18:08:02 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.17; VDF: 7.0.4.23; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The for_each_node_mask loop makes use of two inlined functions:
first_node and next_node. This patch changes for_each_node_mask
to use only one out-of-line function: find_next_node_mask. An
x86_64 defconfig kernel is about 1500 bytes smaller with this
patch applied:

   text	   data	    bss	    dec	    hex	filename
5395732	 976736	 734280	7106748	 6c70bc	vmlinux.orig
5394174	 976736	 734280	7105190	 6c6aa6	vmlinux

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hello,
> Alexander wrote:
> > This patch
> > changes for_each_cpu_mask to use only one function: a newly
> > introduced find_next_cpu.
> 
> I believe that it's for_each_cpu_mask which is newly introduced,
> not find_next_cpu ... just a typo, granted.

I meant find_next_cpu_mask. That was a last-minute change of mind
about the name :/.

> Any chance that you could make the same change to nodemask.h?
> Where practical, I like to keep cpumask.h and nodemask.h the same.

Sure. This patch introduces lib/nodemask.c, but I'm not quite sure
if building it should depend on CONFIG_SMP or something else (NUMA?).
When is MAX_NUMNODES 1?

It seems to work on qemu x86_64-smp and i386-up.

I'ld be happy to take a stab at aligning the cpumask and nodemask
code even more by uninlining some more functions and using stubs
for the MAX_NUMNODES=1 case.

Greetings,
	Alexander

 include/linux/nodemask.h |   11 +++++++----
 lib/Makefile             |    2 +-
 lib/nodemask.c           |   10 ++++++++++
 3 files changed, 18 insertions(+), 5 deletions(-)
 create mode 100644 lib/nodemask.c

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 848025c..dbc80f0 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -239,6 +239,8 @@ static inline int __next_node(int n, const nodemask_t *srcp)
 	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
+int find_next_node_mask(int n, const nodemask_t *srcp);
+
 #define nodemask_of_node(node)						\
 ({									\
 	typeof(_unused_nodemask_arg_) m;				\
@@ -347,10 +349,11 @@ static inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *origp,
 }
 
 #if MAX_NUMNODES > 1
-#define for_each_node_mask(node, mask)			\
-	for ((node) = first_node(mask);			\
-		(node) < MAX_NUMNODES;			\
-		(node) = next_node((node), (mask)))
+#define for_each_node_mask(node, mask)				\
+	for ((node) = 0;					\
+		(node) = find_next_node_mask((node), &(mask)),	\
+		(node) < MAX_NUMNODES;				\
+		(node)++)
 #else /* MAX_NUMNODES == 1 */
 #define for_each_node_mask(node, mask)			\
 	if (!nodes_empty(mask))				\
diff --git a/lib/Makefile b/lib/Makefile
index 74b0cfb..48fc85c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -9,7 +9,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 proportions.o prio_heap.o ratelimit.o
 
 lib-$(CONFIG_MMU) += ioremap.o
-lib-$(CONFIG_SMP) += cpumask.o
+lib-$(CONFIG_SMP) += cpumask.o nodemask.o
 
 lib-y	+= kobject.o kref.o klist.o
 
diff --git a/lib/nodemask.c b/lib/nodemask.c
new file mode 100644
index 0000000..08341d3
--- /dev/null
+++ b/lib/nodemask.c
@@ -0,0 +1,10 @@
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/nodemask.h>
+#include <linux/module.h>
+
+int find_next_node_mask(int n, const nodemask_t *srcp)
+{
+	return find_next_bit(srcp->bits, NR_CPUS, n);
+}
+EXPORT_SYMBOL(find_next_node_mask);

