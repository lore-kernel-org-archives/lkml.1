Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYHSWNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYHSWNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYHSWMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:12:46 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60898 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYHSWMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:12:44 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, Trond.Myklebust@netapp.com,
       NAKANO Hiroaki <nakano.hiroaki@oss.ntt.co.jp>,
       =?utf-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?= 
	<fernando@oss.ntt.co.jp>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 1/2] locks: allow lockd to process blocked locks during grace period
Date: Tue, 19 Aug 2008 18:12:42 -0400
Message-Id: <1219183963-17476-1-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080819221209.GF8331@fieldses.org>
References: <20080819221209.GF8331@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check here is currently harmless but unnecessary, since, as the
comment notes, there aren't any blocked-lock callbacks to process
during the grace period anyway.

And eventually we want to allow multiple grace periods that come and go
for different filesystems over the course of the lifetime of lockd, at
which point this check is just going to get in the way.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/lockd/svc.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 1553fec..bdc607b 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -158,15 +158,9 @@ lockd(void *vrqstp)
 			continue;
 		}
 
-		/*
-		 * Retry any blocked locks that have been notified by
-		 * the VFS. Don't do this during grace period.
-		 * (Theoretically, there shouldn't even be blocked locks
-		 * during grace period).
-		 */
-		if (!nlmsvc_grace_period) {
-			timeout = nlmsvc_retry_blocked();
-		} else if (time_before(grace_period_expire, jiffies))
+		timeout = nlmsvc_retry_blocked();
+
+		if (time_before(grace_period_expire, jiffies))
 			clear_grace_period();
 
 		/*
-- 
1.5.5.rc1

