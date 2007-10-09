Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbXJIPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbXJIPE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXJIPEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:04:21 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47423 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbXJIPEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:04:20 -0400
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="scan'208";a="112251673"
Subject: NLM: Fix a memory leak in nlmsvc_testlock
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       Roel Kluin <12o3l@tiscali.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 09 Oct 2007 11:04:57 -0400
Message-Id: <1191942297.8739.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 09 Oct 2007 15:04:07.0523 (UTC) FILETIME=[A3CEDB30:01C80A85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent fix for a circular lock dependency unfortunately introduced a
potential memory leak in the event where the call to nlmsvc_lookup_host
fails for some reason.

Thanks to Roel Kluin for spotting this.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/lockd/svclock.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index d098c7a..d120ec3 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -485,8 +485,10 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 			return nlm_granted;
 		/* Create host handle for callback */
 		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
-		if (host == NULL)
+		if (host == NULL) {
+			kfree(conf);
 			return nlm_lck_denied_nolocks;
+		}
 		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
 		if (block == NULL) {
 			kfree(conf);
