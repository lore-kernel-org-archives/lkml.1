Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYHMIl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYHMIl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYHMIj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:26 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46374 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYHMIjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:24 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: fix error return in failure mode
Date: Wed, 13 Aug 2008 13:17:35 +0300
Message-Id: <1218622675-28853-7-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0222 (UTC) FILETIME=[0A370D60:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

UBIFS recovery testing debug facility simulates media failures.
When simulating an IO error, the error code returned must be
-EIO but it was not always if the user switched off the
debug recovery testing option at the same time.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/debug.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 4e3aaeb..0adfb29 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2208,16 +2208,17 @@ int dbg_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 int dbg_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
 		  int offset, int len, int dtype)
 {
-	int err;
+	int err, failing;
 
 	if (in_failure_mode(desc))
 		return -EIO;
-	if (do_fail(desc, lnum, 1))
+	failing = do_fail(desc, lnum, 1);
+	if (failing)
 		cut_data(buf, len);
 	err = ubi_leb_write(desc, lnum, buf, offset, len, dtype);
 	if (err)
 		return err;
-	if (in_failure_mode(desc))
+	if (failing)
 		return -EIO;
 	return 0;
 }
-- 
1.5.4.1

