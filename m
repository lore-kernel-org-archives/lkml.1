Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYGAPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYGAPW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbYGAPWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbYGAPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:10 -0400
Date: Tue, 1 Jul 2008 08:19:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eli Cohen <eli@mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 3/9] IB/mthca: Clear ICM pages before handing to FW
Message-ID: <20080701151905.GD3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-mthca-clear-icm-pages-before-handing-to-fw.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Eli Cohen <eli@mellanox.co.il>

commit 87afd448b186c885d67a08b7417cd46253b6a9d6 upstream

Current memfree FW has a bug which in some cases, assumes that ICM
pages passed to it are cleared.  This patch uses __GFP_ZERO to
allocate all ICM pages passed to the FW.  Once firmware with a fix is
released, we can make the workaround conditional on firmware version.

This fixes the bug reported by Arthur Kepner <akepner@sgi.com> here:
http://lists.openfabrics.org/pipermail/general/2008-May/050026.html

[ Rewritten to be a one-liner using __GFP_ZERO instead of vmap()ing
  ICM memory and memset()ing it to 0. - Roland ]

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/mthca/mthca_memfree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -109,7 +109,11 @@ static int mthca_alloc_icm_pages(struct 
 {
 	struct page *page;
 
-	page = alloc_pages(gfp_mask, order);
+	/*
+	 * Use __GFP_ZERO because buggy firmware assumes ICM pages are
+	 * cleared, and subtle failures are seen if they aren't.
+	 */
+	page = alloc_pages(gfp_mask | __GFP_ZERO, order);
 	if (!page)
 		return -ENOMEM;
 

-- 
