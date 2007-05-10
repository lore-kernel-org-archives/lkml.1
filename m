Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbXEJMFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbXEJMFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbXEJMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:05:30 -0400
Received: from smtp.boksi.fi ([195.10.143.42]:2562 "EHLO smtp1.boksi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbXEJMF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:05:29 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 08:05:29 EDT
Date: Thu, 10 May 2007 14:59:27 +0300
From: Mika Kukkonen <mikukkon@miku.homelinux.net>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Bug in fs/afs/write.c function
	afs_write_back_from_locked_page()
Message-ID: <20070510115927.GB16409@srv1-m700-lanp.koti>
Reply-To: mikukkon@iki.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following bug was uncovered by compiling with '-W' flag:

  CC [M]  fs/afs/write.o
fs/afs/write.c: In function ‘afs_write_back_from_locked_page’:
fs/afs/write.c:398: warning: comparison of unsigned expression >= 0 is always true

Loop variable 'n' is unsigned, so wraps around happily as far as I can
see. Trival fix attached (compile tested only).

Signed-Off-By: Mika Kukkonen <mikukkon@iki.fi>

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 83ff292..4bca263 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -395,8 +395,9 @@ static int afs_write_back_from_locked_page(struct afs_writeback *wb,
 		if (n == 0)
 			goto no_more;
 		if (pages[0]->index != start) {
-			for (n--; n >= 0; n--)
+			for (n--; n > 0; n--)
 				put_page(pages[n]);
+			put_page(pages[0]);
 			goto no_more;
 		}

