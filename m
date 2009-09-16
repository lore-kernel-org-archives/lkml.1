Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZIPWj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZIPWj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760345AbZIPWjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:39:54 -0400
Received: from kroah.org ([198.145.64.141]:48919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760333AbZIPWjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:15 2009
Message-Id: <20090916223715.315062589@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [patch 14/45] fix undefined reference to user_shm_unlock
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=fix-undefined-reference-to-user_shm_unlock.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

commit 2195d2818c37bdf263865f1e9effccdd9fc5f9d4 upstream.

My 353d5c30c666580347515da609dd74a2b8e9b828 "mm: fix hugetlb bug due to
user_shm_unlock call" broke the CONFIG_SYSVIPC !CONFIG_MMU build of both
2.6.31 and 2.6.30.6: "undefined reference to `user_shm_unlock'".

gcc didn't understand my comment! so couldn't figure out to optimize
away user_shm_unlock() from the error path in the hugetlb-less case, as
it does elsewhere.  Help it to do so, in a language it understands.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -410,7 +410,7 @@ static int newseg(struct ipc_namespace *
 	return error;
 
 no_id:
-	if (shp->mlock_user)	/* shmflg & SHM_HUGETLB case */
+	if (is_file_hugepages(file) && shp->mlock_user)
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:


