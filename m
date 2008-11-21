Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYKUPrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYKUPrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYKUPoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:16 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58963 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYKUPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:11 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: allow for gaps when dirtying the LPT
Date: Fri, 21 Nov 2008 19:19:27 +0200
Message-Id: <1227287970-14684-6-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 21 Nov 2008 15:44:06.0038 (UTC) FILETIME=[FC62F360:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

The LPT may have gaps in it because initially empty LEBs
are not added by mkfs.ubifs - because it does not know how
many there are.  Then UBIFS allocates empty LEBs in the
reverse order that they are discovered i.e. they are
added to, and removed from, the front of a list.  That
creates a gap in the middle of the LPT.

The function dirtying the LPT tree (for the purpose of
small model garbage collection) assumed that a gap could
only occur at the very end of the LPT and stopped dirtying
prematurely, which in turn resulted in the LPT running
out of space - something that is designed to be impossible.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/lpt_commit.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index eed5a00..a41434b 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -571,8 +571,6 @@ static struct ubifs_pnode *next_pnode(struct ubifs_info *c,
 		/* We assume here that LEB zero is never an LPT LEB */
 		if (nnode->nbranch[iip].lnum)
 			return ubifs_get_pnode(c, nnode, iip);
-		else
-			return NULL;
 	}
 
 	/* Go up while can't go right */
-- 
1.5.4.3

