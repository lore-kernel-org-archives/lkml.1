Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXJWVIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXJWVIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXJWVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:08:26 -0400
Received: from mx2.netapp.com ([216.240.18.37]:4567 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXJWVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:08:25 -0400
X-IronPort-AV: E=Sophos;i="4.21,320,1188802800"; 
   d="scan'208";a="116263951"
Subject: [PATCH]NFS: Fix for bug in handling of errors for O_DIRECT writes
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, Neil Brown <neilb@suse.de>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Sieve: CMU Sieve 2.2
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
References: <20071023123636.6732.patches@notabene>
X-UiO-MailScanner: No virus found
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-4.5, required=12.0,
	autolearn=disabled, AWL=-0.455,RCVD_IN_DNSWL_MED=-4)
X-UiO-Scanned: A2C978816B92681D76A80A48DE4EBC258CC3E079
X-UiO-SPAM-Test: remote_host: 195.135.220.15 spam_score: -44 maxlevel 60
	minaction 1 bait 0 mail/h: 1 total 107 max/h 4 blacklist 0 greylist 0
	ratelimit 0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 23 Oct 2007 17:09:13 -0400
Message-Id: <1193173753.20475.54.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 23 Oct 2007 21:08:17.0093 (UTC) FILETIME=[D4F32750:01C815B8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

commit eda3cef8dd2b838 ensured that if a WRITE returns an error, then
data->res.verf->committed is not tested (as it is not initialised).

commit 60fa3f769f inadvertently reverted this while fixing other problems.

So move the test so that we never examine ->committed in an error
case, and fix a speeling error while we are there.

Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
Note: only compile tested - I haven't tried triggering the bug yet.

NeilBrown

### Diffstat output
 ./fs/nfs/direct.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff .prev/fs/nfs/direct.c ./fs/nfs/direct.c
--- .prev/fs/nfs/direct.c	2007-10-23 12:31:29.000000000 +1000
+++ ./fs/nfs/direct.c	2007-10-23 12:32:07.000000000 +1000
@@ -549,13 +549,13 @@ static void nfs_direct_write_result(stru
 
 	spin_lock(&dreq->lock);
 
-	if (unlikely(dreq->error != 0))
-		goto out_unlock;
 	if (unlikely(status < 0)) {
-		/* An error has occured, so we should not commit */
+		/* An error has occurred, so we should not commit */
 		dreq->flags = 0;
 		dreq->error = status;
 	}
+	if (unlikely(dreq->error != 0))
+		goto out_unlock;
 
 	dreq->count += data->res.count;
 
