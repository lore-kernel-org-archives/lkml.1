Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZLNVsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZLNVsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbZLNVsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:48:08 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:47317 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297AbZLNVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:48:05 -0500
Date: Mon, 14 Dec 2009 21:45:19 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Cc: phillip@lougher.demon.co.uk, mingo@elte.hu,
       albin.tonnerre@free-electrons.com
Subject: [PATCH 2/3] bzip2: Add missing checks for malloc returning NULL
Message-ID: <4b26b1ef.ln20bM9Mn4gzB21L%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 lib/decompress_bunzip2.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 600f473..a6b836b 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -637,6 +637,8 @@ static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, int len,
 
 	/* Allocate bunzip_data.  Most fields initialize to zero. */
 	bd = *bdp = malloc(i);
+	if (!bd)
+		return RETVAL_OUT_OF_MEMORY;
 	memset(bd, 0, sizeof(struct bunzip_data));
 	/* Setup input buffer */
 	bd->inbuf = inbuf;
@@ -664,6 +666,8 @@ static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, int len,
 	bd->dbufSize = 100000*(i-BZh0);
 
 	bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
+	if (!bd->dbuf)
+		return RETVAL_OUT_OF_MEMORY;
 	return RETVAL_OK;
 }
 
@@ -686,7 +690,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 
 	if (!outbuf) {
 		error("Could not allocate output bufer");
-		return -1;
+		return RETVAL_OUT_OF_MEMORY;
 	}
 	if (buf)
 		inbuf = buf;
@@ -694,6 +698,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 		inbuf = malloc(BZIP2_IOBUF_SIZE);
 	if (!inbuf) {
 		error("Could not allocate input bufer");
+		i = RETVAL_OUT_OF_MEMORY;
 		goto exit_0;
 	}
 	i = start_bunzip(&bd, inbuf, len, fill);
@@ -720,11 +725,14 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 	} else if (i == RETVAL_UNEXPECTED_OUTPUT_EOF) {
 		error("Compressed file ends unexpectedly");
 	}
+	if (!bd)
+		goto exit_1;
 	if (bd->dbuf)
 		large_free(bd->dbuf);
 	if (pos)
 		*pos = bd->inbufPos;
 	free(bd);
+exit_1:
 	if (!buf)
 		free(inbuf);
 exit_0:
-- 
1.6.3.3

