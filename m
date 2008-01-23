Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYAWGVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYAWGVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 01:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYAWGV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 01:21:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:16676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYAWGV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 01:21:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,236,1199692800"; 
   d="scan'208";a="506810443"
Subject: [RFC] some page can't be migrated
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter <clameter@sgi.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 14:22:37 +0800
Message-Id: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anonymous page might have fs-private metadata, the page is truncated. As
the page hasn't mapping, page migration refuse to migrate the page. It
appears the page is only freed in page reclaim and if zone watermark is
low, the page is never freed, as a result migration always fail. I
thought we could free the metadata so such page can be freed in
migration and make migration more reliable?

Thanks,
Shaohua

diff --git a/mm/migrate.c b/mm/migrate.c
index 6a207e8..6bc38f7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -633,6 +633,17 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 			goto unlock;
 		wait_on_page_writeback(page);
 	}
+
+	/*
+	 * See truncate_complete_page(). Anonymous page might have
+	 * fs-private metadata, the page is truncated. Such page can't be
+	 * migrated. Try to free metadata, so the page can be freed.
+	 */
+	if (!page->mapping && !PageAnon(page) && PagePrivate(page)) {
+		try_to_release_page(page, GFP_KERNEL);
+		goto unlock;
+	}
+
 	/*
 	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.


