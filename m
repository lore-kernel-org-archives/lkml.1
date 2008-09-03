Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYICRP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYICRP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYICRPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:15:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:43273 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751255AbYICRPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:15:12 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18gr8cQA+Qg5wknliVYXhNuXwWJRo2aVKywf6Cdn+
	IDBDtXe4ZRMqRj
Date: Wed, 3 Sep 2008 19:14:38 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] Fix another bug in hfsplus when reading a corrupted
	image
Message-ID: <20080903171437.GA23969@alice>
References: <20080826125909.GA21266@alice> <Pine.LNX.4.64.0808290409220.2507@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808290409220.2507@localhost.localdomain>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc4 (x86_64)
X-Uptime: 19:11:39 up  8:51,  1 user,  load average: 0.74, 0.88, 0.78
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: -0.07000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roman Zippel (zippel@linux-m68k.org) wrote:
> Hi,
> 
> On Tue, 26 Aug 2008, Eric Sesterhenn wrote:
> 
> > Problem is that there is no ext_tree, causing the NULL-pointer
> > dereference in hfsplus_init(). This fixes the issue by checking the ext_tree in
> > hfsplus_get_block() and aborting early enoug.
> 
> The problem is worse, a corrupted extent for the extent file itself may 
> try to get an impossible extent, causing a deadlock if I see it correctly.
> A better fix would be to check the inode number after the first_blocks 
> checks and fail if it's the extent file, as according to the spec the 
> extent file should have no extent for itself.

I guess you had something in mind like this, which also fixes the issue
for me.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>


--- linux/fs/hfsplus/extents.orig	2008-08-26 14:51:08.000000000 +0200
+++ linux/fs/hfsplus/extents.c	2008-09-03 17:58:35.000000000 +0200
@@ -199,6 +199,9 @@ int hfsplus_get_block(struct inode *inod
 		goto done;
 	}
 
+	if (inode->i_ino == HFSPLUS_EXT_CNID)
+		return -EIO;
+
 	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	res = hfsplus_ext_read_extent(inode, ablock);
 	if (!res) {
