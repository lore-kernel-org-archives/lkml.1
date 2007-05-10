Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbXEJMdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbXEJMdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXEJMd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:33:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXEJMdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:33:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070510115927.GB16409@srv1-m700-lanp.koti>
References: <20070510115927.GB16409@srv1-m700-lanp.koti>
To: mikukkon@iki.fi
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bug in fs/afs/write.c function afs_write_back_from_locked_page()
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 May 2007 13:33:18 +0100
Message-ID: <10764.1178800398@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


How about the attached instead?

David
---
AFS: Fix interminable loop in afs_write_back_from_locked_page()

From: Mika Kukkonen <mikukkon@miku.homelinux.net>

Following bug was uncovered by compiling with '-W' flag:

  CC [M]  fs/afs/write.o
fs/afs/write.c: In function ‘afs_write_back_from_locked_page’:
fs/afs/write.c:398: warning: comparison of unsigned expression >= 0 is always true

Loop variable 'n' is unsigned, so wraps around happily as far as I can
see. Trival fix attached (compile tested only).

Signed-Off-By: Mika Kukkonen <mikukkon@iki.fi>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/write.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 67ae4db..c26d5e8 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -395,8 +395,10 @@ static int afs_write_back_from_locked_page(struct afs_writeback *wb,
 		if (n == 0)
 			goto no_more;
 		if (pages[0]->index != start) {
-			for (n--; n >= 0; n--)
-				put_page(pages[n]);
+			do {
+				put_page(pages[--n]);
+			} while (n > 0);
+			put_page(pages[0]);
 			goto no_more;
 		}
 
