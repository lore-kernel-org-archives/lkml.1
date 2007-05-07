Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXEGAfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXEGAfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXEGAfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:35:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXEGAfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:35:37 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:15 +1000
Message-Id: <1070507003515.24070@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 001 of 8] knfsd: Avoid use of unitialised variables on error path when nfs exports.
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We need to zero various parts of 'exp' before any 'goto out', otherwise
when we go to free the contents... we die.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./fs/nfsd/export.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-05-07 10:30:16.000000000 +1000
+++ ./fs/nfsd/export.c	2007-05-07 10:30:28.000000000 +1000
@@ -469,6 +469,13 @@ static int svc_export_parse(struct cache
 	nd.dentry = NULL;
 	exp.ex_path = NULL;
 
+	/* fs locations */
+	exp.ex_fslocs.locations = NULL;
+	exp.ex_fslocs.locations_count = 0;
+	exp.ex_fslocs.migrated = 0;
+
+	exp.ex_uuid = NULL;
+
 	if (mesg[mlen-1] != '\n')
 		return -EINVAL;
 	mesg[mlen-1] = 0;
@@ -509,13 +516,6 @@ static int svc_export_parse(struct cache
 	if (exp.h.expiry_time == 0)
 		goto out;
 
-	/* fs locations */
-	exp.ex_fslocs.locations = NULL;
-	exp.ex_fslocs.locations_count = 0;
-	exp.ex_fslocs.migrated = 0;
-
-	exp.ex_uuid = NULL;
-
 	/* flags */
 	err = get_int(&mesg, &an_int);
 	if (err == -ENOENT)
