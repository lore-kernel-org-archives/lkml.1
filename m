Return-Path: <linux-kernel-owner+w=401wt.eu-S1765144AbXINO2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765144AbXINO2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXINO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:28:27 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42235 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXINO20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:28:26 -0400
Date: Fri, 14 Sep 2007 10:28:08 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Cc: Neil Brown <neilb@suse.de>, trond.myklebust@fys.uio.no,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Correctly close old nfsd/lockd sockets.
Message-ID: <20070914142808.GD20606@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

Commit aaf68cfbf2241d24d46583423f6bff5c47e088b3 added a bias
to sk_inuse, so this test for an unused socket now fails.  So no
sockets get closed because they are old (they might get closed
if the client closed them).

This bug has existed since 2.6.21-rc1.

Thanks to Wolfgang Walter for finding and reporting the bug.

Cc: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 net/sunrpc/svcsock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

This looks appropriate for both 2.6.23 and 2.6.22.x.

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index e053f5a..0417283 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1593,7 +1593,8 @@ svc_age_temp_sockets(unsigned long closure)
 
 		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
 			continue;
-		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY, &svsk->sk_flags))
+		if (atomic_read(&svsk->sk_inuse) > 1
+		    || test_bit(SK_BUSY, &svsk->sk_flags))
 			continue;
 		atomic_inc(&svsk->sk_inuse);
 		list_move(le, &to_be_aged);
-- 
1.5.3.1.42.gfe5df

