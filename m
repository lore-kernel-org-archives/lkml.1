Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZCKOOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZCKOOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZCKOOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:14:14 -0400
Received: from msxmx04.webde.de ([217.72.192.159]:51143 "EHLO msxmx04.webde.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZCKOON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:14:13 -0400
X-Greylist: delayed 2049 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 10:14:13 EDT
From: "Thomas Schoebel-Theuer" <thomas.schoebel-theuer@1und1.de>
Organization: 1und1 Internet AG
To: jack marrow <jackmarrow2@gmail.com>
Subject: Re: Memory usage per memory zone
Date: Wed, 11 Mar 2009 14:39:56 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
In-Reply-To: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_t87tJFqozkjl6dj"
Message-Id: <200903111439.57510.thomas.schoebel-theuer@1und1.de>
X-OriginalArrivalTime: 11 Mar 2009 13:40:00.0267 (UTC) FILETIME=[DFCCF5B0:01C9A24E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_t87tJFqozkjl6dj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch, 11. M=E4rz 2009 11:41:43 schrieb jack marrow:
> I have a box where the oom-killer is killing processes due to running
> out of memory in zone_normal. I can see using slabtop that the inode
> caches are using up lots of memory and guess this is the problem, so
> have cleared them using an echo to drop_caches.

Hi Jack,

my experience with plain old 2.6.24 on 32bit _production_ boxes was that un=
der=20
heavy load and after >30days uptime we saw an sudden inflation of oom-kille=
rs=20
on some of them until those boxes died. The standard kernel statistics abou=
t=20
memory looked much the same as yours (and I suspect they could have been=20
wrong or at least misleading, but I have neither checked nor tried to fix).

> is it possible to use slabtop
> (or any other way) to view ram usage per zone so I can pick out the
> culprit?

Try the attached experimental hack which can provide you with some insight=
=20
about whats really going on in the _physical_ memory. Since it does not=20
allocate any memory for the purpose of displaying those memory patterns it=
=20
wants to examine, you have to allocate a large enough buffer in userspace.=
=20
Don't use cat, but something like dd with parameters such as bs=3D4M (as=20
mentioned in the comment). Probably you have to adjust the patch to some=20
newer kernel versions, and/or to fix some sysctl table checks if you want t=
o=20
get it upstreams (I will not). And, of course, you can visualize more/other=
=20
flags as well.

After gaining some insight with /proc/sys/vm/mempattern and some developmen=
t=20
of further experimental patches which successfully reduced fragmentation (b=
ut=20
finally only _delayed_ the oom problems without being able to _fundamentall=
y_=20
resolve them), the ultimate solution was just to use CONFIG_VMSPLIT_2G or=20
even CONFIG_VMSPLIT_1G in order to overcome the artificial shortening of=20
zone_normal.

This supports old wisdom that an OS cannot give you resources it just does =
not=20
possess... Just make sure you have enough resources for your working set.=20
Thats all.

In the hope of being helpful,

Thomas

--Boundary-00=_t87tJFqozkjl6dj
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="fragmentation-visualisation-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fragmentation-visualisation-v2.patch"

diff -urw linux-2.6.24.fragmentation-base/include/linux/mmzone.h linux-2.6.24.fragmentation-info/include/linux/mmzone.h
--- linux-2.6.24.fragmentation-base/include/linux/mmzone.h	2008-09-30 12:50:05.000000000 +0200
+++ linux-2.6.24.fragmentation-info/include/linux/mmzone.h	2009-01-27 14:27:42.000000000 +0100
@@ -687,6 +687,11 @@
 			struct file *, void __user *, size_t *, loff_t *);
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN 16	/* string buffer size */
+int sysctl_mempattern(struct ctl_table *table, int __user *name, int nlen,
+		      void __user *oldval, size_t __user *oldlenp,
+		      void __user *newval, size_t newlen);
+int mempattern_sysctl_handler(struct ctl_table *, int, struct file *, 
+			      void __user *, size_t *, loff_t *);
 
 #include <linux/topology.h>
 /* Returns the number of the current Node. */
diff -urw linux-2.6.24.fragmentation-base/include/linux/sysctl.h linux-2.6.24.fragmentation-info/include/linux/sysctl.h
--- linux-2.6.24.fragmentation-base/include/linux/sysctl.h	2008-11-12 12:41:47.000000000 +0100
+++ linux-2.6.24.fragmentation-info/include/linux/sysctl.h	2009-01-27 14:05:17.000000000 +0100
@@ -225,6 +225,7 @@
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_MEMPATTERN=36,	 /* output physical memory patterns */
 };
 
 
diff -urw linux-2.6.24.fragmentation-base/kernel/sysctl.c linux-2.6.24.fragmentation-info/kernel/sysctl.c
--- linux-2.6.24.fragmentation-base/kernel/sysctl.c	2008-11-12 12:41:47.000000000 +0100
+++ linux-2.6.24.fragmentation-info/kernel/sysctl.c	2009-01-27 14:43:08.000000000 +0100
@@ -987,6 +987,13 @@
 		.extra1		= &zero,
 	},
 	{
+		.ctl_name	= VM_MEMPATTERN,
+		.procname	= "mempattern",
+		.mode		= 0444,
+		.proc_handler	= &mempattern_sysctl_handler,
+		.strategy	= &sysctl_mempattern,
+	},
+	{
 		.ctl_name	= VM_PERCPU_PAGELIST_FRACTION,
 		.procname	= "percpu_pagelist_fraction",
 		.data		= &percpu_pagelist_fraction,
diff -urw linux-2.6.24.fragmentation-base/mm/page_alloc.c linux-2.6.24.fragmentation-info/mm/page_alloc.c
--- linux-2.6.24.fragmentation-base/mm/page_alloc.c	2008-09-30 12:50:05.000000000 +0200
+++ linux-2.6.24.fragmentation-info/mm/page_alloc.c	2009-01-29 15:54:31.000000000 +0100
@@ -1947,6 +1947,126 @@
 	show_swap_cache_info();
 }
 
+/* Strategy routine for dumping memory patterns.
+ * It does not allocate kernel memory, but rather copies everything
+ * directly to userspace.
+ * The userspace buffer should be large enough, otherwise output is
+ * truncated.
+ * Use something like "dd if=/proc/sys/vm/mempattern bs=1M"
+ * to reserve such a large buffer in userspace.
+ */
+size_t do_mempattern(void __user *buf, size_t bufsize)
+{
+	struct zone *zone;
+        size_t pos = 0;
+
+#define WRITE_CHAR(out,order,pfn)				\
+        if(bufsize -  pos <= (1 << (order)))			\
+	          goto done;					\
+        if(!((pfn) % 64)) {					\
+	        put_user('\n', (char __user *)(buf + pos));	\
+		pos++;						\
+	}							\
+        put_user((out), (char __user *)(buf + pos));		\
+        pos++;
+
+        //printk("called do_mempattern bufsize=%ld\n", bufsize);
+	for_each_zone(zone) {
+	        size_t len = strlen(zone->name);
+		int pfn;
+
+		if(bufsize -  pos <= len+7)
+		        goto done;
+		if(copy_to_user(buf + pos, "Zone: ", 6))
+		        return -EFAULT;
+		pos += 6;
+		if(copy_to_user(buf + pos, zone->name, len))
+		        return -EFAULT;
+		pos += len;
+		WRITE_CHAR('\n', 0, -1);
+
+		for(pfn = zone->zone_start_pfn; pfn < zone->zone_start_pfn+zone->spanned_pages; pfn++) {
+			struct page *page;
+			int order = 0;
+			int i;
+			char out;
+		        if(!pfn_valid(pfn))
+			        continue;
+			page = pfn_to_page(pfn);
+			if(PageBuddy(page)) {
+			        order = page_order(page);
+				out = 'X';
+			} else if(PageSlab(page)) {
+				out = 's';
+			} else if(PageDirty(page)) {
+				out = '#';
+				if(PageLRU(page)) {
+				        out = '@';
+				}
+			} else if(PageLRU(page)) {
+				out = ':';
+			} else {
+				out = '.';
+			}
+			WRITE_CHAR(out, order, pfn);
+			for(i = 1; i < (1 << order); i++) {
+				pfn++;
+			        WRITE_CHAR('x', 0, pfn);
+			}
+		}
+		WRITE_CHAR('\n', 0, -1);
+	}
+ done:
+	return pos;
+}
+
+int sysctl_mempattern(struct ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+        size_t res;
+        size_t bufsize;
+        printk("called sysctl_mempattern\n");
+
+	if (!table->data || !table->maxlen) 
+		return -ENOTDIR;
+
+	if(!oldval || !oldlenp) {
+	        return 0;
+	}
+
+	if (get_user(bufsize, oldlenp))
+		return -EFAULT;
+
+	res = do_mempattern(oldval, bufsize);
+	if(res >= 0) {
+		if (put_user(res, oldlenp))
+		        return -EFAULT;
+	        return 1;
+	}
+	return res;
+}
+
+int mempattern_sysctl_handler(ctl_table *table, int write, 
+	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
+{
+        size_t res;
+        //printk("called mempattern_sysctl_handler write=%d length=%ld\n", write, *length);
+	if (!*length || *ppos) {
+	        *length = 0;
+		return 0;
+	}
+	res = do_mempattern(buffer, *length);
+        //printk("res=%ld\n", res);
+	if(res > 0) {
+	        *ppos += res;
+		*length = res;
+		return 0;
+	}
+	return res;
+}
+
+
 /*
  * Builds allocation fallback zone lists.
  *

--Boundary-00=_t87tJFqozkjl6dj--
