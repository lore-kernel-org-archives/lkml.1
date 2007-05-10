Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbXEJPXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbXEJPXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbXEJPXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:23:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbXEJPXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:23:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] AFS: Fix interminable loop in
	afs_write_back_from_locked_page()
To: akpm@osdl.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 10 May 2007 15:33:34 +0100
Message-ID: <20070510143334.19485.26042.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following bug was uncovered by compiling with '-W' flag:

  CC [M]  fs/afs/write.o
fs/afs/write.c: In function ‘afs_write_back_from_locked_page’:
fs/afs/write.c:398: warning: comparison of unsigned expression >= 0 is always true

Loop variable 'n' is unsigned, so wraps around happily as far as I can
see. Trival fix attached (compile tested only).

Signed-Off-By: Mika Kukkonen <mikukkon@iki.fi>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/write.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 67ae4db..28f3751 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -395,8 +395,9 @@ static int afs_write_back_from_locked_page(struct afs_writeback *wb,
 		if (n == 0)
 			goto no_more;
 		if (pages[0]->index != start) {
-			for (n--; n >= 0; n--)
-				put_page(pages[n]);
+			do {
+				put_page(pages[--n]);
+			} while (n > 0);
 			goto no_more;
 		}
 

