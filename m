Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYHMIpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYHMIpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYHMIjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:39 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37172 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbYHMIjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:37 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: ensure UBIFS switches to read-only on error
Date: Wed, 13 Aug 2008 13:17:36 +0300
Message-Id: <1218622675-28853-8-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0253 (UTC) FILETIME=[0A3BC850:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

UBI transparently handles write errors by automatically copying
and remapping the affected eraseblock. If UBI is unable to do
that, for example its pool of eraseblocks reserved for bad block
handling is empty, then the error is propagated to UBIFS. UBIFS
must protect the media from falling into an inconsistent state
by immediately switching to read-only mode. In the case of log
updates, this was not being done.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/log.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index 36857b9..e14829e 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -317,6 +317,8 @@ int ubifs_add_bud_to_log(struct ubifs_info *c, int jhead, int lnum, int offs)
 	return 0;
 
 out_unlock:
+	if (err != -EAGAIN)
+		ubifs_ro_mode(c, err);
 	mutex_unlock(&c->log_mutex);
 	kfree(ref);
 	kfree(bud);
-- 
1.5.4.1

