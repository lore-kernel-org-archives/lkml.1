Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZLOW63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZLOW63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932599AbZLOW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:58:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:37579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704AbZLOW6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:58:19 -0500
Date: Tue, 15 Dec 2009 22:57:53 GMT
From: tip-bot for Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, phillip@lougher.demon.co.uk,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <4b26b1ef.ln20bM9Mn4gzB21L%phillip@lougher.demon.co.uk>
References: <4b26b1ef.ln20bM9Mn4gzB21L%phillip@lougher.demon.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] bzip2: Add missing checks for malloc returning NULL
Message-ID: <tip-d4529862cae4de19fda8d4bbcbddc60f3e48a4cf@git.kernel.org>
Git-Commit-ID: d4529862cae4de19fda8d4bbcbddc60f3e48a4cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4529862cae4de19fda8d4bbcbddc60f3e48a4cf
Gitweb:     http://git.kernel.org/tip/d4529862cae4de19fda8d4bbcbddc60f3e48a4cf
Author:     Phillip Lougher <phillip@lougher.demon.co.uk>
AuthorDate: Mon, 14 Dec 2009 21:45:19 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 15 Dec 2009 14:04:19 -0800

bzip2: Add missing checks for malloc returning NULL

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
LKML-Reference: <4b26b1ef.ln20bM9Mn4gzB21L%phillip@lougher.demon.co.uk>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 lib/decompress_bunzip2.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 7607420..a4e971d 100644
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
