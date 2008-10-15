Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbYJOOM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbYJOOM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbYJOOGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:23 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32965 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbYJOOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:10 -0400
Subject: [PATCH 06/21] fat: cleanup fat_parse_long() error handling
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp,
       darrenrjenkins@gmail.com
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:57 +0900
Message-ID: <a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
In-Reply-To: <3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Darren Jenkins" <darrenrjenkins@gmail.com>

Coverity CID 2332 & 2333 RESOURCE_LEAK

In fat_search_long() if fat_parse_long() returns a -ve value we return
without first freeing unicode.  This patch free's them on this error path.

The above was false positive on current tree, but this change is more
clean, so apply as cleanup.

[hirofumi@mail.parknet.co.jp: fix coding style]
Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/fat/dir.c~fat_fat_parse_long-cleanup fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_fat_parse_long-cleanup	2008-08-24 23:14:01.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-08-24 23:14:01.000000000 +0900
@@ -373,9 +373,10 @@ parse_record:
 		if (de->attr == ATTR_EXT) {
 			int status = fat_parse_long(inode, &cpos, &bh, &de,
 						    &unicode, &nr_slots);
-			if (status < 0)
-				return status;
-			else if (status == PARSE_INVALID)
+			if (status < 0) {
+				err = status;
+				goto end_of_dir;
+			} else if (status == PARSE_INVALID)
 				continue;
 			else if (status == PARSE_NOT_LONGNAME)
 				goto parse_record;
_
