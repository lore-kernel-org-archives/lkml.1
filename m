Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbYBWAfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbYBWAfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763549AbYBWAd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:33:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763118AbYBWAdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:33:24 -0500
Date: Fri, 22 Feb 2008 16:29:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, wli@holomorphy.com, agl@us.ibm.com,
       nacc@us.ibm.com, david@gibson.dropbear.id.au
Subject: [patch 05/38] hugetlb: add locking for overcommit sysctl
Message-ID: <20080223002947.GF7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hugetlb-add-locking-for-overcommit-sysctl.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 

From: Nishanth Aravamudan <nacc@us.ibm.com>

patch a3d0c6aa1bb342b9b2c7b123b52ac2f48a4d4d0a in mainline.

When I replaced hugetlb_dynamic_pool with nr_overcommit_hugepages I used
proc_doulongvec_minmax() directly.  However, hugetlb.c's locking rules
require that all counter modifications occur under the hugetlb_lock.  Add a
callback into the hugetlb code similar to the one for nr_hugepages.  Grab
the lock around the manipulation of nr_overcommit_hugepages in
proc_doulongvec_minmax().

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/linux/hugetlb.h |    1 +
 kernel/sysctl.c         |    2 +-
 mm/hugetlb.c            |   10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -17,6 +17,7 @@ static inline int is_vm_hugetlb_page(str
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
+int hugetlb_overcommit_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -910,7 +910,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &nr_overcommit_huge_pages,
 		.maxlen		= sizeof(nr_overcommit_huge_pages),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &hugetlb_overcommit_handler,
 	},
 #endif
 	{
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -605,6 +605,16 @@ int hugetlb_treat_movable_handler(struct
 	return 0;
 }
 
+int hugetlb_overcommit_handler(struct ctl_table *table, int write,
+			struct file *file, void __user *buffer,
+			size_t *length, loff_t *ppos)
+{
+	spin_lock(&hugetlb_lock);
+	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+	spin_unlock(&hugetlb_lock);
+	return 0;
+}
+
 #endif /* CONFIG_SYSCTL */
 
 int hugetlb_report_meminfo(char *buf)

-- 
