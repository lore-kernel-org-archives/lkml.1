Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYJOOFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYJOOFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYJOOEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:49 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45082 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYJOOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:47 -0400
Subject: [PATCH 17/21] fat: Fix _fat_bmap() race
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:00 +0900
Message-ID: <9562d38c3e848f5f6e81722369.ps@mail.parknet.co.jp>
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
	<c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
	<5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
	<6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
	<cd30496c3e848f5f6e81522369.ps@mail.parknet.co.jp>
	<056ecdb93e848f5f6e81622369.ps@mail.parknet.co.jp>
In-Reply-To: <056ecdb93e848f5f6e81622369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fat_get_cluster() assumes the requested blocknr isn't truncated during
read. _fat_bmap() doesn't follow this rule.

This protects it by ->i_mutex.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat_fat_bmap-fix fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_fat_bmap-fix	2008-09-14 05:25:34.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-09-14 06:28:26.000000000 +0900
@@ -199,7 +199,14 @@ static ssize_t fat_direct_IO(int rw, str
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 {
-	return generic_block_bmap(mapping, block, fat_get_block);
+	sector_t blocknr;
+
+	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
+	mutex_lock(&mapping->host->i_mutex);
+	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	mutex_unlock(&mapping->host->i_mutex);
+
+	return blocknr;
 }
 
 static const struct address_space_operations fat_aops = {
_
