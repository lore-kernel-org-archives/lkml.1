Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYIHNfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYIHNfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIHNfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:35:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:43899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751713AbYIHNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:35:09 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18sYOlH8TgsbCLV24sX2wanHxoqyGNHAGNjYtb4Wi
	whZulqcrjAEUP/
Date: Mon, 8 Sep 2008 15:35:05 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, akpm@linux-foundation.org
Subject: [Patch] hfs: fix namelength memory corruption
Message-ID: <20080908133505.GA3031@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc5-00099-gd26acd9 (x86_64)
X-Uptime: 15:23:17 up 2 days,  3:35,  1 user,  load average: 1.52, 1.01,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

this is basically the same as
hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch.
We use the length parameter for a memcopy without checking it and
thereby corruption memory. 

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux/fs/hfs/catalog.c.orig	2008-09-08 15:20:15.000000000 +0200
+++ linux/fs/hfs/catalog.c	2008-09-08 15:21:02.000000000 +0200
@@ -190,6 +190,10 @@ int hfs_cat_find_brec(struct super_block
 
 	fd->search_key->cat.ParID = rec.thread.ParID;
 	len = fd->search_key->cat.CName.len = rec.thread.CName.len;
+	if (len > HFS_NAMELEN) {
+		printk(KERN_ERR "hfs: bad catalog namelength\n");
+		return -EIO;
+	}
 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
 	return hfs_brec_find(fd);
 }
