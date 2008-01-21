Return-Path: <linux-kernel-owner+w=401wt.eu-S1764450AbYAUKTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764450AbYAUKTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbYAUKDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760104AbYAUKDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:06 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 45/58] [GFS2] Fix log block mapper
Date: Mon, 21 Jan 2008 09:22:03 +0000
Message-Id: <12009074192015-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907417194-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
 <12009074103982-git-send-email-swhiteho@redhat.com>
 <12009074121930-git-send-email-swhiteho@redhat.com>
 <12009074142128-git-send-email-swhiteho@redhat.com>
 <12009074163163-git-send-email-swhiteho@redhat.com>
 <1200907417194-git-send-email-swhiteho@redhat.com>
Message-Id: <50ab1e5a407b4e8b1dd9b26e5841965300c17af0.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

A missing offset in the calculation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 0833e27..40c51bf 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -336,7 +336,7 @@ static u64 log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
 
 	list_for_each_entry(je, &sdp->sd_jdesc->extent_list, extent_list) {
 		if (lbn >= je->lblock && lbn < je->lblock + je->blocks)
-			return je->dblock + lbn;
+			return je->dblock + lbn - je->lblock;
 	}
 
 	return -1;
-- 
1.5.1.2

