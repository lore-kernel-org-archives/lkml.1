Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbXGYDzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbXGYDzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 23:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXGYDzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 23:55:22 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:45300 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbXGYDzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 23:55:21 -0400
Subject: Re: [PATCH 1/3] readahead: drop behind
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20070721210051.975382000@chello.nl>
References: <20070721210005.000228000@chello.nl>
	 <20070721210051.975382000@chello.nl>
Content-Type: multipart/mixed; boundary="=-s4IM+r/u1SeYuWaqcKpT"
Date: Tue, 24 Jul 2007 23:55:17 -0400
Message-Id: <1185335717.7105.6.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s4IM+r/u1SeYuWaqcKpT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-21-07 at 23:00 +0200, Peter Zijlstra wrote:

> Use the read-ahead code to provide hints to page reclaim.
> 
> This patch has the potential to solve the streaming-IO trashes my
> desktop problem.
> 
> It tries to aggressively reclaim pages that were loaded in a strong
> sequential pattern and have been consumed. Thereby limiting the damage
> to the current resident set.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

(sorry for the delay)

Ok, I've done some tests with your patches,

I came up with a test program that should approximate my use case. It
simply mmap() and scan (read) a 375M file which represent the usual used
memory on my desktop system.  This data is frequently used, and should
stay cached as much as possible in preference over the "used once" data
read in the page cache when copying large files. I don't claim that the
test program is perfect or even correct, I'm open for suggestions.

Test system:

- Linux x86_64 2.6.23-rc1
- 1G of RAM
- I use the basic drop behind and sysctl patches. The readahead size
patch is _not_ included.


Setting up:

dd if=/dev/zero of=/tmp/375M_file bs=1M count=375
dd if=/dev/zero of=/tmp/5G_file bs=1M count=5120

Tests with stock kernel (drop behind disabled):

echo 0 >/proc/sys/vm/drop_behind

Base test:

sync; echo 1 >/proc/sys/vm/drop_caches
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file

1st execution: 0m7.146s
2nd execution: 0m1.119s
3rd execution: 0m1.109s
4th execution: 0m1.105s

Reading a large file test:

sync; echo 1 >/proc/sys/vm/drop_caches
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file
cp /tmp/5G_file /dev/null
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file

1st execution: 0m7.224s
2nd execution: 0m1.114s
3rd execution: 0m7.178s <<< Much slower
4th execution: 0m1.115s

Copying (read+write) a large file test:

sync; echo 1 >/proc/sys/vm/drop_caches
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file
cp /tmp/5G_file /tmp/copy_of_5G_file
time ./large_app_load_simul /tmp/375M_file
time ./large_app_load_simul /tmp/375M_file
rm /tmp/copy_of_5G_file

1st execution: 0m7.203s
2nd execution: 0m1.147s
3rd execution: 0m7.238s <<< Much slower
4th execution: 0m1.129s

Tests with drop behind enabled:

echo 1 >/proc/sys/vm/drop_behind

Base test:

[same tests as above]

1st execution: 0m7.206s
2nd execution: 0m1.110s
3rd execution: 0m1.102s
4th execution: 0m1.106s

Reading a large file test:

[same tests as above]

1st execution: 0m7.197s
2nd execution: 0m1.116s
3rd execution: 0m1.114s <<< Great!!!
4th execution: 0m1.111s

Copying (read+write) a large file test:

[same tests as above]

1st execution: 0m7.186s
2nd execution: 0m1.111s
3rd execution: 0m7.339s <<< Not fixed
4th execution: 0m1.121s


Conclusion:

- The drop-behind patch works and really prevents the page cache content
from being fulled with useless read-once data.

- It doesn't help the copy (read+write) case. This should also be fixed,
as it's a common workload.

Tested-By: Eric St-Laurent (ericstl34@xxxxxxxxx.xx)



Best regards,

- Eric

(*) Test program and batch file are attached.


--=-s4IM+r/u1SeYuWaqcKpT
Content-Disposition: attachment; filename=drop-behind+sysctl.patch
Content-Type: text/x-patch; name=drop-behind+sysctl.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -urN linux-2.6/include/linux/swap.h linux-2.6-drop-behind/include/linux/swap.h
--- linux-2.6/include/linux/swap.h	2007-07-21 18:26:00.000000000 -0400
+++ linux-2.6-drop-behind/include/linux/swap.h	2007-07-22 16:22:48.000000000 -0400
@@ -180,6 +180,7 @@
 /* linux/mm/swap.c */
 extern void FASTCALL(lru_cache_add(struct page *));
 extern void FASTCALL(lru_cache_add_active(struct page *));
+extern void FASTCALL(lru_demote(struct page *));
 extern void FASTCALL(activate_page(struct page *));
 extern void FASTCALL(mark_page_accessed(struct page *));
 extern void lru_add_drain(void);
diff -urN linux-2.6/kernel/sysctl.c linux-2.6-drop-behind/kernel/sysctl.c
--- linux-2.6/kernel/sysctl.c	2007-07-21 18:26:01.000000000 -0400
+++ linux-2.6-drop-behind/kernel/sysctl.c	2007-07-22 16:20:27.000000000 -0400
@@ -163,6 +163,7 @@
 
 extern int prove_locking;
 extern int lock_stat;
+extern int sysctl_dropbehind;
 
 /* The default sysctl tables: */
 
@@ -1048,6 +1049,14 @@
 		.extra1		= &zero,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "drop_behind",
+		.data		= &sysctl_dropbehind,
+		.maxlen		= sizeof(sysctl_dropbehind),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff -urN linux-2.6/mm/readahead.c linux-2.6-drop-behind/mm/readahead.c
--- linux-2.6/mm/readahead.c	2007-07-21 18:26:01.000000000 -0400
+++ linux-2.6-drop-behind/mm/readahead.c	2007-07-22 16:41:47.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
+#include <linux/swap.h>
 
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
@@ -429,6 +430,8 @@
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
 
+int sysctl_dropbehind = 1;
+
 /**
  * page_cache_async_readahead - file readahead for marked pages
  * @mapping: address_space which holds the pagecache and I/O vectors
@@ -449,6 +452,11 @@
 			   struct page *page, pgoff_t offset,
 			   unsigned long req_size)
 {
+	pgoff_t demote_idx = offset - min_t(pgoff_t, offset, ra->size);
+	struct page *pages[16];
+	unsigned nr_pages;
+	unsigned i;
+
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -467,6 +475,36 @@
 	if (bdi_read_congested(mapping->backing_dev_info))
 		return;
 
+	/*
+	 * Read-ahead use once: when the ra window is maximal this is a good
+	 * hint that there is sequential IO, which implies that the pages that
+	 * have been used thus far can be reclaimed
+	 */
+	if (sysctl_dropbehind && ra->size == ra->ra_pages) {
+		nr_pages = find_get_pages(mapping,
+				demote_idx, ARRAY_SIZE(pages), pages);
+
+		for (i = 0; i < nr_pages; i++) {
+			page = pages[i];
+			demote_idx = page_index(page);
+
+			/*
+			 * The page is active. This means there are other
+			 * users. We should not take away somebody else's
+			 * pages, so do not drop behind beyond this point.
+			 */
+			if (demote_idx < offset && !PageActive(page)) {
+				lru_demote(page);
+			} else {
+				demote_idx = offset;
+				break;
+			}
+		}
+		demote_idx++;
+
+		release_pages(pages, nr_pages, 0);
+	} while (demote_idx < offset);
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
 }
diff -urN linux-2.6/mm/swap.c linux-2.6-drop-behind/mm/swap.c
--- linux-2.6/mm/swap.c	2007-07-21 18:26:01.000000000 -0400
+++ linux-2.6-drop-behind/mm/swap.c	2007-07-22 16:26:35.000000000 -0400
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/init.h>
+#include <linux/rmap.h>
 
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
@@ -176,6 +177,7 @@
  */
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
 static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_demote_pvecs) = { 0, };
 
 void fastcall lru_cache_add(struct page *page)
 {
@@ -197,6 +199,37 @@
 	put_cpu_var(lru_add_active_pvecs);
 }
 
+static void __pagevec_lru_demote(struct pagevec *pvec)
+{
+	int i;
+	struct zone *zone = NULL;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock_irq(&zone->lru_lock);
+		}
+		if (PageLRU(page)) {
+			page_referenced(page, 0);
+			if (PageActive(page)) {
+				ClearPageActive(page);
+				__dec_zone_state(zone, NR_ACTIVE);
+				__inc_zone_state(zone, NR_INACTIVE);
+			}
+			list_move_tail(&page->lru, &zone->inactive_list);
+		}
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
 static void __lru_add_drain(int cpu)
 {
 	struct pagevec *pvec = &per_cpu(lru_add_pvecs, cpu);
@@ -207,6 +240,9 @@
 	pvec = &per_cpu(lru_add_active_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_active(pvec);
+	pvec = &per_cpu(lru_demote_pvecs, cpu);
+	if (pagevec_count(pvec))
+		__pagevec_lru_demote(pvec);
 }
 
 void lru_add_drain(void)
@@ -403,6 +439,21 @@
 }
 
 /*
+ * Function used to forcefully demote a page to the tail of the inactive
+ * list.
+ */
+void fastcall lru_demote(struct page *page)
+{
+	if (likely(get_page_unless_zero(page))) {
+		struct pagevec *pvec = &get_cpu_var(lru_demote_pvecs);
+
+		if (!pagevec_add(pvec, page))
+			__pagevec_lru_demote(pvec);
+		put_cpu_var(lru_demote_pvecs);
+	}
+}
+
+/*
  * Try to drop buffers from the pages in a pagevec
  */
 void pagevec_strip(struct pagevec *pvec)


--=-s4IM+r/u1SeYuWaqcKpT
Content-Disposition: attachment; filename=large_app_load_simul.cpp
Content-Type: text/x-c++src; name=large_app_load_simul.cpp; charset=UTF-8
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
	if (argc != 2)
		return EXIT_FAILURE;

	FILE *file = fopen(argv[1], "rb");

	fseek(file, 0, SEEK_END);
	long size = ftell(file);

	char *buf = (char *)mmap(NULL, size, PROT_READ, MAP_PRIVATE, fileno(file), 0);

	for (long i = 0; i < size; i++)
		char temp = buf[i];

	int result = munmap(buf, size);

	fclose(file);

	return EXIT_SUCCESS;
}

--=-s4IM+r/u1SeYuWaqcKpT
Content-Disposition: attachment; filename=Makefile
Content-Type: text/x-makefile; name=Makefile; charset=UTF-8
Content-Transfer-Encoding: 7bit

all:
	gcc large_app_load_simul.cpp -o large_app_load_simul -lstdc++


--=-s4IM+r/u1SeYuWaqcKpT
Content-Disposition: attachment; filename=useonce-test.sh
Content-Type: application/x-shellscript; name=useonce-test.sh
Content-Transfer-Encoding: 7bit

#!/bin/bash

TIMEFORMAT=' %3lR'

function do_tests
{

echo "Base test:"

echo "Dropping caches..."
sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "2nd execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "3rd execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "4th execution:"
time ./large_app_load_simul /tmp/375M_file

echo "Reading a large file test:"

echo "Dropping caches..."
sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "2nd execution:"
time ./large_app_load_simul /tmp/375M_file
echo "Reading large file..."
cp /tmp/5G_file /dev/null
echo -n "3rd execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "4th execution:"
time ./large_app_load_simul /tmp/375M_file

echo "Copying (read+write) a large file test:"

echo "Dropping caches..."
sync; echo 1 >/proc/sys/vm/drop_caches

echo -n "1st execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "2nd execution:"
time ./large_app_load_simul /tmp/375M_file
echo "Copying large file..."
cp /tmp/5G_file /tmp/copy_of_5G_file
echo -n "3rd execution:"
time ./large_app_load_simul /tmp/375M_file
echo -n "4th execution:"
time ./large_app_load_simul /tmp/375M_file
rm /tmp/copy_of_5G_file

}

if [ $UID != 0 ]; then
	echo "Must be root."
	exit 0
fi

if [ ! -e "/tmp/5G_file" ]; then
	echo "Creating test files..."
	dd if=/dev/zero of=/tmp/375M_file bs=1M count=375
	dd if=/dev/zero of=/tmp/5G_file bs=1M count=5120
fi

echo "Tests with stock kernel (drop behind disabled):"
echo 0 >/proc/sys/vm/drop_behind

do_tests

echo "Tests with drop behind enabled:"
echo 1 >/proc/sys/vm/drop_behind

do_tests

exit 0


--=-s4IM+r/u1SeYuWaqcKpT--

