Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab0BESQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:16:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601Ab0BESQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:16:40 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] cifs: fix length calculation for converted unicode readdir names
Date: Fri,  5 Feb 2010 13:14:00 -0500
Message-Id: <1265393640-7296-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cifs_from_ucs2 returns the length of the converted name, including the
length of the NULL terminator. We don't want to include the NULL
terminator in the dentry name length however since that'll throw off the
hash calculation for the dentry cache.

I believe that this is the root cause of several problems that have
cropped up recently that seem to be papered over with the "noserverino"
mount option. More confirmation of that would be good, but this is
clearly a bug and it fixes at least one reproducible problem that
was reported.

This patch fixes at least this reproducer in this kernel.org bug:

    http://bugzilla.kernel.org/show_bug.cgi?id=15088#c12

Reported-by: Bjorn Tore Sund <bjorn.sund@it.uib.no>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: stable@kernel.org
---
 fs/cifs/readdir.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index f84062f..f5618f8 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -666,6 +666,7 @@ static int cifs_get_name_from_search_buf(struct qstr *pqst,
 					   min(len, max_len), nlt,
 					   cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		pqst->len -= nls_nullsize(nlt);
 	} else {
 		pqst->name = filename;
 		pqst->len = len;
-- 
1.6.6

