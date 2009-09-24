Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZIXPw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZIXPw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZIXPw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:52:26 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:37004 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbZIXPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:52:25 -0400
X-Trace: 266089073/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.36.147/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.36.147
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAEMyu0pPRSST/2dsb2JhbACBUtYChBsFgks
X-IronPort-AV: E=Sophos;i="4.44,446,1249254000"; 
   d="scan'208";a="266089073"
Date: Thu, 24 Sep 2009 16:52:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] ksm: change default values to better fit into mainline
 kernel
In-Reply-To: <1253736347-3779-1-git-send-email-ieidus@redhat.com>
Message-ID: <Pine.LNX.4.64.0909241644110.16561@sister.anvils>
References: <1253736347-3779-1-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Izik Eidus wrote:
> Now that ksm is in mainline it is better to change the default values
> to better fit to most of the users.
> 
> This patch change the ksm default values to be:
> ksm_thread_pages_to_scan = 100 (instead of 200)
> ksm_thread_sleep_millisecs = 20 (like before)
> ksm_run = KSM_RUN_STOP (instead of KSM_RUN_MERGE - meaning ksm is
>                         disabled by default)
> ksm_max_kernel_pages = nr_free_buffer_pages / 4 (instead of 2046)
> 
> The important aspect of this patch is: it disable ksm by default, and set
> the number of the kernel_pages that can be allocated to be a reasonable
> number.
> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>

You rather caught me by surprise with this one, Izik: I was thinking
more rc7 than rc1 for switching it off; but no problem, you're probably
right to get people into the habit of understanding it's off even when
they choose CONFIG_KSM=y.

There's several reasons why I couldn't Ack your patch, but I see Andrew
is already sending it on to Linus, so here's another to go on top of it:


[PATCH] ksm: more on default values

Adjust the max_kernel_pages default to a quarter of totalram_pages,
instead of nr_free_buffer_pages() / 4: the KSM pages themselves come
from highmem, and even on a 16GB PAE machine, 4GB of KSM pages would
only be pinning 32MB of lowmem with their rmap_items, so no need for
the more obscure calculation (nor for its own special init function).

There is no way for the user to switch KSM on if CONFIG_SYSFS
is not enabled, so in that case default run to KSM_RUN_MERGE.

Update KSM Documentation and Kconfig to reflect the new defaults.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 Documentation/vm/ksm.txt |   13 +++++++------
 mm/Kconfig               |    4 +++-
 mm/ksm.c                 |   10 ++++------
 3 files changed, 14 insertions(+), 13 deletions(-)

--- 2.6.31-git+izik/Documentation/vm/ksm.txt	2009-09-23 16:05:43.000000000 +0100
+++ linux/Documentation/vm/ksm.txt	2009-09-24 16:07:16.000000000 +0100
@@ -52,15 +52,15 @@ The KSM daemon is controlled by sysfs fi
 readable by all but writable only by root:
 
 max_kernel_pages - set to maximum number of kernel pages that KSM may use
-                   e.g. "echo 2000 > /sys/kernel/mm/ksm/max_kernel_pages"
+                   e.g. "echo 100000 > /sys/kernel/mm/ksm/max_kernel_pages"
                    Value 0 imposes no limit on the kernel pages KSM may use;
                    but note that any process using MADV_MERGEABLE can cause
                    KSM to allocate these pages, unswappable until it exits.
-                   Default: 2000 (chosen for demonstration purposes)
+                   Default: quarter of memory (chosen to not pin too much)
 
 pages_to_scan    - how many present pages to scan before ksmd goes to sleep
-                   e.g. "echo 200 > /sys/kernel/mm/ksm/pages_to_scan"
-                   Default: 200 (chosen for demonstration purposes)
+                   e.g. "echo 100 > /sys/kernel/mm/ksm/pages_to_scan"
+                   Default: 100 (chosen for demonstration purposes)
 
 sleep_millisecs  - how many milliseconds ksmd should sleep before next scan
                    e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
@@ -70,7 +70,8 @@ run              - set 0 to stop ksmd fr
                    set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
                    set 2 to stop ksmd and unmerge all pages currently merged,
                          but leave mergeable areas registered for next run
-                   Default: 1 (for immediate use by apps which register)
+                   Default: 0 (must be changed to 1 to activate KSM,
+                               except if CONFIG_SYSFS is disabled)
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
 
@@ -86,4 +87,4 @@ pages_volatile embraces several differen
 proportion there would also indicate poor use of madvise MADV_MERGEABLE.
 
 Izik Eidus,
-Hugh Dickins, 30 July 2009
+Hugh Dickins, 24 Sept 2009
--- 2.6.31-git+izik/mm/Kconfig	2009-09-23 16:05:56.000000000 +0100
+++ linux/mm/Kconfig	2009-09-24 16:07:16.000000000 +0100
@@ -224,7 +224,9 @@ config KSM
 	  the many instances by a single resident page with that content, so
 	  saving memory until one or another app needs to modify the content.
 	  Recommended for use with KVM, or with other duplicative applications.
-	  See Documentation/vm/ksm.txt for more information.
+	  See Documentation/vm/ksm.txt for more information: KSM is inactive
+	  until a program has madvised that an area is MADV_MERGEABLE, and
+	  root has set /sys/kernel/mm/ksm/run to 1 (if CONFIG_SYSFS is set).
 
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
--- 2.6.31-git+izik/mm/ksm.c	2009-09-24 16:15:26.000000000 +0100
+++ linux/mm/ksm.c	2009-09-24 16:07:16.000000000 +0100
@@ -184,11 +184,6 @@ static DEFINE_SPINLOCK(ksm_mmlist_lock);
 		sizeof(struct __struct), __alignof__(struct __struct),\
 		(__flags), NULL)
 
-static void __init ksm_init_max_kernel_pages(void)
-{
-	ksm_max_kernel_pages = nr_free_buffer_pages() / 4;
-}
-
 static int __init ksm_slab_init(void)
 {
 	rmap_item_cache = KSM_KMEM_CACHE(rmap_item, 0);
@@ -1673,7 +1668,7 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
-	ksm_init_max_kernel_pages();
+	ksm_max_kernel_pages = totalram_pages / 4;
 
 	err = ksm_slab_init();
 	if (err)
@@ -1697,6 +1692,9 @@ static int __init ksm_init(void)
 		kthread_stop(ksm_thread);
 		goto out_free2;
 	}
+#else
+	ksm_run = KSM_RUN_MERGE;	/* no way for user to start it */
+
 #endif /* CONFIG_SYSFS */
 
 	return 0;
