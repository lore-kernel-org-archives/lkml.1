Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZJTVHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZJTVHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbZJTVHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:07:47 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63562 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZJTVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Frxe4oTiqu00f3HUh+GE+v1zyLQdd4xR4M0hfpLOhPpcNO49E092p2gfPJUyM2yMyw
         Zths3KmUKKCWkb68FA7XElvMh8awpMYH4DyD1HyCU0j5ZvDFR5grA17XIYAQnntn8OVG
         G51iLZT9dx8160E+9x8AGII2DlNb7uwVdXfsE=
Message-ID: <4ADE28FF.6090503@gmail.com>
Date: Tue, 20 Oct 2009 23:17:51 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] befs: redundant test on unsigned in befs_get_block()?
References: <4AD88DE1.1080900@gmail.com> <20091016142518.998c41a2.akpm@linux-foundation.org>
In-Reply-To: <20091016142518.998c41a2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block is unsigned, check whether it is not too large.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> As far as the VFS is concerned, `block' is indeed unsigned and may well
> be in the range 2G-4G with a 32-bit sector_t.  Perhaps not possible on
> befs but still legal to the VFS.
> 
> So the test is wrong from that POV.
> 
> However it is possible that befs is defending itself here.  Perhaps code
> internal to befs will explode if passed a "negative" block number.  Due
> to coding errors within the fs implementation.
> 
> So really, we'd need to check all code paths called by
> befs_get_block() and check that they are signednessly clean.

This appears to be already noted by Jesper Juhl in 2004, however it
was never fixed: http://search.luky.org/linux-kernel.2004/msg01392.html

It's getting late here, but what do you think about this:
befs_get_block() calls befs_fblock2brun() and there occurs a 


pos = fblock << BEFS_SB(sb)->block_shift;

and in effect:
if (pos >= data->max_double_indirect_range)
	error out.

So if I'm not mistaken, this should provide protection:

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 33baf27..eeb4625 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -128,9 +128,9 @@ befs_get_block(struct inode *inode, sector_t block,
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   inode->i_ino, block);
 
-	if (block < 0) {
-		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
+	if (block >= ds->max_double_indirect_range >>
+			BEFS_SB(sb)->block_shift) {
+		befs_error(sb, "befs_get_block() was asked for a too large block: block %ld in inode %lu",
 			   block, inode->i_ino);
 		return -EIO;
 	}
