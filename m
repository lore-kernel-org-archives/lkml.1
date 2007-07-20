Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXGTJhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXGTJhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbXGTJhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:37:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:16318 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbXGTJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=mDz1lQRccxcm80Ql5FrEqeLx5J7/Gqzr+4VV3m4nbf54kF7PrBIKwGl/NLwHd4kssn6kD4XSEAK2a7l1Ijr8F/hEO8XeXQhUYgbk+WH0dqGX06y5nXQK8tyPO5zxxgy1fhruJ7NwfFKzDGjsnYoNPOf7bmN8c0q+yAwyIE+v6YY=
From: Denis Cheng <crquan@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH] fs/fuse/dev.c: use zero_user_page instead
Date: Fri, 20 Jul 2007 17:37:50 +0800
Message-Id: <11849242706-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
I'm not very sure zero_user_page is correctly used here,
so please feel free to give comments.

and why here it uses KM_USER1 not KM_USER0, What are the differences?

 fs/fuse/dev.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3ad22be..e55b5e8 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -533,11 +533,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 static int fuse_copy_page(struct fuse_copy_state *cs, struct page *page,
 			  unsigned offset, unsigned count, int zeroing)
 {
-	if (page && zeroing && count < PAGE_SIZE) {
-		void *mapaddr = kmap_atomic(page, KM_USER1);
-		memset(mapaddr, 0, PAGE_SIZE);
-		kunmap_atomic(mapaddr, KM_USER1);
-	}
+	if (page && zeroing && count < PAGE_SIZE)
+		zero_user_page(page, 0, PAGE_SIZE, KM_USER1);
+
 	while (count) {
 		int err;
 		if (!cs->len && (err = fuse_copy_fill(cs)))
-- 
1.5.2.2

