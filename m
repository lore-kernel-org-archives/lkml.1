Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbYF3Q75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbYF3Q75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYF3Q7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:59:49 -0400
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:60203 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYF3Q7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:59:49 -0400
From: Benny Halevy <bhalevy@panasas.com>
To: Christine Caulfield <ccaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] dlm: fix uninitialized variable for search_rsb_list callers
Date: Mon, 30 Jun 2008 19:59:14 +0300
Message-Id: <1214845154-4978-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.5.6.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.3.0 correctly emits the following warning.
search_rsb_list does not *r_ret if no dlm_rsb is found
and _search_rsb may pass the uninitialized value upstream
on the error path when both calls to search_rsb_list
return non-zero error.

The fix sets *r_ret to NULL on search_rsb_list's not-found path.

/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/fs/dlm/lock.c: In function ‘_search_rsb’:
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/fs/dlm/lock.c:378: warning: ‘r’ may be used uninitialized in this function

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 fs/dlm/lock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 2d3d102..79c1d65 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -363,6 +363,7 @@ static int search_rsb_list(struct list_head *head, char *name, int len,
 		if (len == r->res_length && !memcmp(name, r->res_name, len))
 			goto found;
 	}
+	*r_ret = NULL;
 	return -EBADR;
 
  found:
-- 
1.5.6.GIT

