Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZFQQEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZFQQEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZFQQD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:03:59 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:11337
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756271AbZFQQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:03:58 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Jeff Garzik <jeff@garzik.org>, open-osd <osd-dev@open-osd.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] exofs: Fix bio leak in error handling path (sync read)
Date: Wed, 17 Jun 2009 19:03:58 +0300
Message-Id: <1245254638-8595-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <4A391373.3050301@panasas.com>
References: <4A391373.3050301@panasas.com>
X-OriginalArrivalTime: 17 Jun 2009 16:04:01.0052 (UTC) FILETIME=[3A979DC0:01C9EF65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When failing a read request in the sync path, called from
write_begin, I forgot to free the allocated bio, fix it.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 77d0a29..bb5d6ed 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -295,6 +295,9 @@ static int read_exec(struct page_collect *pcol, bool is_sync)
 err:
 	if (!is_sync)
 		_unlock_pcol_pages(pcol, ret, READ);
+	else /* Pages unlocked by caller in sync mode only free bio */
+		pcol_free(pcol);
+
 	kfree(pcol_copy);
 	if (or)
 		osd_end_request(or);
-- 
1.6.2.1

