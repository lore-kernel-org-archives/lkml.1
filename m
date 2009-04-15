Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZDOENS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZDOENS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZDOEND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:13:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46183 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZDOENB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:13:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: meminfo Committed_AS underflows
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Mel Gorman <mel@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090415105033.AC29.A69D9226@jp.fujitsu.com>
References: <1239737619.32604.118.camel@nimitz> <20090415105033.AC29.A69D9226@jp.fujitsu.com>
Message-Id: <20090415131009.AC40.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 13:12:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix stupid mistake.

Changelog:
	since v1
		- change the type of commited value from ulong to long


=========================
Subject: [PATCH v2] fix Commited_AS underflow

Dave Hansen reported committed_AS field can underfolow.

>         # while true; do cat /proc/meminfo  | grep _AS; sleep 1; done | uniq -c
>               1 Committed_AS: 18446744073709323392 kB
>              11 Committed_AS: 18446744073709455488 kB
>               6 Committed_AS:    35136 kB
>               5 Committed_AS: 18446744073709454400 kB
>               7 Committed_AS:    35904 kB
>               3 Committed_AS: 18446744073709453248 kB
>               2 Committed_AS:    34752 kB
>               9 Committed_AS: 18446744073709453248 kB
>               8 Committed_AS:    34752 kB
>               3 Committed_AS: 18446744073709320960 kB
>               7 Committed_AS: 18446744073709454080 kB
>               3 Committed_AS: 18446744073709320960 kB
>               5 Committed_AS: 18446744073709454080 kB
>               6 Committed_AS: 18446744073709320960 kB

Because NR_CPU can be greater than 1000. and meminfo_proc_show()
doesn't have underflow check.

this patch have two change.

1. Change NR_CPU to nr_online_cpus()
   vm_acct_memory() isn't fast-path. then cpumask_weight() calculation
   isn't so expensive and the parameter for scalability issue should
   consider number of _physical_ cpus. not theoretical maximum number.
2. Add under-flow check to meminfo_proc_show().
   Almost field in /proc/meminfo have underflow check. but Committed_AS
   is significant exeption.
   it should do.

Reported-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/meminfo.c |    4 +++-
 mm/swap.c         |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: b/fs/proc/meminfo.c
===================================================================
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -22,7 +22,7 @@ void __attribute__((weak)) arch_report_m
 static int meminfo_proc_show(struct seq_file *m, void *v)
 {
 	struct sysinfo i;
-	unsigned long committed;
+	long committed;
 	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
@@ -36,6 +36,8 @@ static int meminfo_proc_show(struct seq_
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = atomic_long_read(&vm_committed_space);
+	if (committed < 0)
+		committed = 0;
 	allowed = ((totalram_pages - hugetlb_total_pages())
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -519,7 +519,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
  * We tolerate a little inaccuracy to avoid ping-ponging the counter between
  * CPUs
  */
-#define ACCT_THRESHOLD	max(16, NR_CPUS * 2)
+#define ACCT_THRESHOLD	max_t(long, 16, num_online_cpus() * 2)
 
 static DEFINE_PER_CPU(long, committed_space);
 


