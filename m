Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYLKHAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYLKHAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 02:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYLKHAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 02:00:23 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:38209 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYLKHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 02:00:22 -0500
X-Greylist: delayed 1601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 02:00:22 EST
X-AuditID: 0ac90647-aacf5ba000000f8c-90-4940b4439eab
Message-ID: <4940B426.6040509@hitachi.com>
Date: Thu, 11 Dec 2008 15:33:10 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH] coredump_filter: enable to change the default filter
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new kernel parameter `coredump_filter'.
Setting a value to this parameter causes the default bitmask
of coredump_filter to be changed.

It is useful for users to change coredump_filter settings for
the whole system at boot time.  Without this parameter, users
have to change coredump_filter settings for each /proc/<pid>/
in an initializing script.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
CC: Roland McGrath <roland@redhat.com>
CC: Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 kernel/fork.c                       |   15 +++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6.28-rc8/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.28-rc8.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.28-rc8/Documentation/kernel-parameters.txt
@@ -547,6 +547,11 @@ and is between 256 and 4096 characters. 
 			not work reliably with all consoles, but is known
 			to work with serial and VGA consoles.
 
+	coredump_filter=
+			[KNL] Change the default value for
+			/proc/<pid>/coredump_filter.
+			See also Documentation/filesystems/proc.txt.
+
 	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
Index: linux-2.6.28-rc8/kernel/fork.c
===================================================================
--- linux-2.6.28-rc8.orig/kernel/fork.c
+++ linux-2.6.28-rc8/kernel/fork.c
@@ -397,6 +397,18 @@ __cacheline_aligned_in_smp DEFINE_SPINLO
 #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
 
+static unsigned long default_dump_filter = MMF_DUMP_FILTER_DEFAULT;
+
+static int __init coredump_filter_setup(char *s)
+{
+	default_dump_filter =
+		(simple_strtoul(s, NULL, 0) << MMF_DUMP_FILTER_SHIFT) &
+		MMF_DUMP_FILTER_MASK;
+	return 1;
+}
+
+__setup("coredump_filter=", coredump_filter_setup);
+
 #include <linux/init_task.h>
 
 static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
@@ -405,8 +417,7 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
-	mm->flags = (current->mm) ? current->mm->flags
-				  : MMF_DUMP_FILTER_DEFAULT;
+	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);



