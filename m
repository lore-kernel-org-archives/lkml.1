Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbYJOOFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbYJOOFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJOOEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:47 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45071 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYJOOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:46 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 10:04:46 EDT
Subject: [PATCH 12/21] fat: Kill d_invalidate() in vfat_lookup()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:59 +0900
Message-ID: <c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
	<db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
	<6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
In-Reply-To: <6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


d_invalidate() for positive dentry doesn't work in some cases
(vfsmount, nfsd, and maybe others). shrink_dcache_parent() by
d_invalidate() is pointless for vfat usage at all.

So, this kills it, and intead of it uses d_move().

To save old behavior, this returns alias simply for directory (don't
change pwd, etc..). the directory lookup shouldn't be important for
performance.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_vfat.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/fat/namei_vfat.c~vfat-dcache-d_invalidate-fix fs/fat/namei_vfat.c
--- linux-2.6/fs/fat/namei_vfat.c~vfat-dcache-d_invalidate-fix	2008-08-27 19:18:24.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/namei_vfat.c	2008-08-27 19:18:24.000000000 +0900
@@ -745,13 +745,12 @@ static struct dentry *vfat_lookup(struct
 		 *
 		 * Switch to new one for reason of locality if possible.
 		 */
-		if (d_invalidate(alias) == 0)
-			dput(alias);
-		else {
-			iput(inode);
-			unlock_super(sb);
-			return alias;
-		}
+		BUG_ON(d_unhashed(alias));
+		if (!S_ISDIR(inode->i_mode))
+			d_move(alias, dentry);
+		iput(inode);
+		unlock_super(sb);
+		return alias;
 	}
 out:
 	unlock_super(sb);
_
