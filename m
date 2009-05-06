Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbZEFWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbZEFWRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761508AbZEFVzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:19 -0400
Received: from kroah.org ([198.145.64.141]:57430 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761583AbZEFVzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:02 2009
Message-Id: <20090506214802.691243407@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mel Gorman <mel@csn.ul.ie>
Subject: [patch 53/58] Ignore madvise(MADV_WILLNEED) for hugetlbfs-backed regions
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=ignore-madvise-for-hugetlbfs-backed-regions.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit a425a638c858fd10370b573bde81df3ba500e271 upstream.

madvise(MADV_WILLNEED) forces page cache readahead on a range of memory
backed by a file.  The assumption is made that the page required is
order-0 and "normal" page cache.

On hugetlbfs, this assumption is not true and order-0 pages are
allocated and inserted into the hugetlbfs page cache.  This leaks
hugetlbfs page reservations and can cause BUGs to trigger related to
corrupted page tables.

This patch causes MADV_WILLNEED to be ignored for hugetlbfs-backed
regions.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/madvise.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -112,6 +112,14 @@ static long madvise_willneed(struct vm_a
 	if (!file)
 		return -EBADF;
 
+	/*
+	 * Page cache readahead assumes page cache pages are order-0 which
+	 * is not the case for hugetlbfs. Do not give a bad return value
+	 * but ignore the advice.
+	 */
+	if (vma->vm_flags & VM_HUGETLB)
+		return 0;
+
 	if (file->f_mapping->a_ops->get_xip_mem) {
 		/* no bad return value, but ignore advice */
 		return 0;


