Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZBGCzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZBGCzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZBGCzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:55:31 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:45495 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZBGCzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:55:31 -0500
X-IronPort-AV: E=Sophos;i="4.37,394,1231113600"; 
   d="scan'208";a="244685432"
Content-class: urn:content-classes:message
Subject: [PATCH] Propagate CRAMFS uncompression errors
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Fri, 6 Feb 2009 21:55:29 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Propagate CRAMFS uncompression errors
Thread-Index: AcmIzt61VZD+2tppT7iOs7LHTkB5jwAAHydA
From: "David VomLehn (dvomlehn)" <dvomlehn@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Feb 2009 02:55:30.0156 (UTC) FILETIME=[89664AC0:01C988CF]
Authentication-Results: sj-dkim-8; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cramfs_uncompress_block detects an error uncompressing it will
return a zero value. This patch checks the return value and propagates
the error back up to the block layer.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 fs/cramfs/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a07338d..6ff8a5e 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -493,7 +493,15 @@ static int cramfs_readpage(struct file *file,
struct page * page)
 	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE -
bytes_filled);
 	kunmap(page);
 	flush_dcache_page(page);
-	SetPageUptodate(page);
+
+	if (bytes_filled == 0) {
+		ClearPageUptodate(page);
+		SetPageError(page);
+	}
+
+	else
+		SetPageUptodate(page);
+
 	unlock_page(page);
 	return 0;
 }
