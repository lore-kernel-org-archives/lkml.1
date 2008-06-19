Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYFSSQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYFSSQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYFSSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:15:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYFSSP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:15:58 -0400
Subject: [PATCH] Hugetlb: stop race when reading proc meminfo
From: Eric Paris <eparis@redhat.com>
To: wli@holomorphy.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 19 Jun 2008 14:15:42 -0400
Message-Id: <1213899342.16752.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minor nit that hugetlb_report_{,node_}meminfo() does not lock the
reading of nr_huge_pages, free_huge_pages, and friends so this is not an
atomic set of information put into the buffer.  If /proc/meminfo is read
while the number of hugetlb pages is in flux it is possible to get
incorrect output such as:

HugePages_Total:     7
HugePages_Free:      8
HugePages_Rsvd:      0
Hugepagesize:     4096 kB

(test available at https://bugzilla.redhat.com/attachment.cgi?id=309864)

With the patch we beat on a number of boxes for hours with the above
test and saw no inconsistencies in the meminfo output.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 mm/hugetlb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ab17127..fe074d1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -687,7 +687,9 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 
 int hugetlb_report_meminfo(char *buf)
 {
-	return sprintf(buf,
+	int ret;
+	spin_lock(&hugetlb_lock);
+	ret = sprintf(buf,
 			"HugePages_Total: %5lu\n"
 			"HugePages_Free:  %5lu\n"
 			"HugePages_Rsvd:  %5lu\n"
@@ -698,17 +700,23 @@ int hugetlb_report_meminfo(char *buf)
 			resv_huge_pages,
 			surplus_huge_pages,
 			HPAGE_SIZE/1024);
+	spin_unlock(&hugetlb_lock);
+	return ret;
 }
 
 int hugetlb_report_node_meminfo(int nid, char *buf)
 {
-	return sprintf(buf,
+	int ret;
+	spin_lock(&hugetlb_lock);
+	ret = sprintf(buf,
 		"Node %d HugePages_Total: %5u\n"
 		"Node %d HugePages_Free:  %5u\n"
 		"Node %d HugePages_Surp:  %5u\n",
 		nid, nr_huge_pages_node[nid],
 		nid, free_huge_pages_node[nid],
 		nid, surplus_huge_pages_node[nid]);
+	spin_unlock(&hugetlb_lock);
+	return ret;
 }
 
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */


