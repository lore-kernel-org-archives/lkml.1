Return-Path: <linux-kernel-owner+w=401wt.eu-S1161678AbXEAKTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161678AbXEAKTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161684AbXEAKTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:19:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161678AbXEAKTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:19:36 -0400
Subject: GFS2] Fix bz 234168 (ignoring rgrp flags) [20/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:14:56 +0100
Message-Id: <1178014497.5462.169.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a43a49066d36612f3bb46653cdb265a89c235eff Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 2 Apr 2007 10:48:17 +0100
Subject: [PATCH] [GFS2] Fix bz 234168 (ignoring rgrp flags)

Ths following patch makes GFS2 use the rgrp flags properly. Although
there are also separate flags for both data and metadata as well, I've
not implemented these as there seems little use for them. On the
otherhand, the "noalloc" flag is generally useful for future changes we
might which to make, so this ensures that we interpret it correctly.

In addition I fixed the comment above the function which was incorrect.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2ce48d4..1727f50 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -698,8 +698,6 @@ struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
  * @al: the struct gfs2_alloc structure describing the reservation
  *
  * If there's room for the requested blocks to be allocated from the RG:
- *   Sets the $al_reserved_data field in @al.
- *   Sets the $al_reserved_meta field in @al.
  *   Sets the $al_rgd field in @al.
  *
  * Returns: 1 on success (it fits), 0 on failure (it doesn't fit)
@@ -710,6 +708,9 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	int ret = 0;
 
+	if (rgd->rd_rg.rg_flags & GFS2_RGF_NOALLOC)
+		return 0;
+
 	spin_lock(&sdp->sd_rindex_spin);
 	if (rgd->rd_free_clone >= al->al_requested) {
 		al->al_rgd = rgd;
-- 
1.5.1.2



