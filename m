Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbXKGOwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbXKGOwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbXKGOv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:51:57 -0500
Received: from lixom.net ([66.141.50.11]:48159 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbXKGOv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:51:57 -0500
Date: Wed, 7 Nov 2007 09:01:20 -0600
From: Olof Johansson <olof@lixom.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: silence warning for 64KB PAGE_SIZE builds
Message-ID: <20071107150120.GA2677@lixom.net>
References: <20071107051540.GB24266@lixom.net> <87prymqfwa.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prymqfwa.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Annoying gcc warning:

fs/fat/inode.c: In function 'fat_fill_super':
fs/fat/inode.c:1222: warning: comparison is always false due to limited range of data type

Change it to compare with 4K instead of PAGE_CACHE_SIZE, as suggested
by OGAWA-san.


Signed-off-by: Olof Johansson <olof@lixom.net>

---

On Wed, Nov 07, 2007 at 11:39:01PM +0900, OGAWA Hirofumi wrote:
> Olof Johansson <olof@lixom.net> writes:
> 
> > logical_sector_size can never be more than 16 bits worth, but switching
> > it to an int silences gcc. It's a sanity check that can never fail with
> > 64KB PAGE_SIZE but it seems like it'd still be useful for other page
> > sizes, so it's worth keeping:
[...]
> 
> Please use 4096 instead of allowing it, at least for now.

Sure. New patch.


Thanks,

-Olof

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 920a576..61e2874 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1219,7 +1219,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
 	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
-	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
+	    || (logical_sector_size > 4096)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus logical sector size %u\n",
 			       logical_sector_size);
