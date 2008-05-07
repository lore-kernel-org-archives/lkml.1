Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYEGKm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYEGKm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 06:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYEGKms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 06:42:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:40445 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753458AbYEGKmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 06:42:47 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/nfZZDiDvnAeZ8GoCPp7OeGqot5pBsOE9eXh0l/a
	8wDeXkKuGD98PB
Date: Wed, 7 May 2008 12:42:44 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, zippel@linux-m68k.org
Subject: [Patch] hfsplus oops on image without extends
Message-ID: <20080507104244.GD2340@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 12:40:22 up  1:56,  1 user,  load average: 0.18, 0.26, 0.24
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

the following patch fixes an oops with a corrupted hfs+ image.
see http://bugzilla.kernel.org/show_bug.cgi?id=10548 for details.

Problem is that we call hfs_btree_open() from hfsplus_fill_super() to set
HFSPLUS_SB(sb).[ext_tree|cat_tree]
Both trees are still NULL at this moment. If hfs_btree_open() fails for
any reason it calls iput() on the page, which
gets to hfsplus_releasepage() which tries to access HFSPLUS_SB(sb).*
which is still NULL and oopses while dereferencing it.


Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux-2.6/fs/hfsplus/inode.c.orig	2008-05-07 14:37:31.000000000 +0200
+++ linux-2.6/fs/hfsplus/inode.c	2008-05-07 14:38:05.000000000 +0200
@@ -65,6 +65,8 @@ static int hfsplus_releasepage(struct pa
 		BUG();
 		return 0;
 	}
+	it (!tree)
+		return 0;
 	if (tree->node_size >= PAGE_CACHE_SIZE) {
 		nidx = page->index >> (tree->node_size_shift - PAGE_CACHE_SHIFT);
 		spin_lock(&tree->hash_lock);
