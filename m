Return-Path: <linux-kernel-owner+w=401wt.eu-S1765847AbYAUKXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765847AbYAUKXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760298AbYAUKDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759773AbYAUKDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:25 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 56/58] [GFS2] Fix page_mkwrite truncation race path
Date: Mon, 21 Jan 2008 09:22:14 +0000
Message-Id: <1200907438887-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074362909-git-send-email-swhiteho@redhat.com>
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
 <12009074192015-git-send-email-swhiteho@redhat.com>
 <12009074213460-git-send-email-swhiteho@redhat.com>
 <12009074221447-git-send-email-swhiteho@redhat.com>
 <12009074243427-git-send-email-swhiteho@redhat.com>
 <12009074263736-git-send-email-swhiteho@redhat.com>
 <12009074271575-git-send-email-swhiteho@redhat.com>
 <12009074291130-git-send-email-swhiteho@redhat.com>
 <12009074312371-git-send-email-swhiteho@redhat.com>
 <12009074321081-git-send-email-swhiteho@redhat.com>
 <12009074341030-git-send-email-swhiteho@redhat.com>
 <12009074362909-git-send-email-swhiteho@redhat.com>
Message-Id: <3fa0be40338b94030dcf4794198c65cc99e260fa.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There was a bug in the truncation/invalidation race path for
->page_mkwrite for gfs2. It ought to return 0 so that the effect is the
same as if the page was truncated at any of the other points at which
the page_lock is dropped. This will result in the restart of the whole
page fault path. If it was due to a real truncation (as opposed to an
invalidate because we let a glock go) then the ->fault path will pick
that up when it gets called again.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index d7f4726..f4842f2 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -394,6 +394,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	last_index = ip->i_inode.i_size >> PAGE_CACHE_SHIFT;
 	if (page->index > last_index)
 		goto out_unlock_page;
+	ret = 0;
 	if (!PageUptodate(page) || page->mapping != ip->i_inode.i_mapping)
 		goto out_unlock_page;
 	if (gfs2_is_stuffed(ip)) {
-- 
1.5.1.2

