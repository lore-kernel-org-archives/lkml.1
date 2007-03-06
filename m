Return-Path: <linux-kernel-owner+w=401wt.eu-S965934AbXCFQnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965934AbXCFQnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965336AbXCFQmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:42:45 -0500
Received: from styx.suse.cz ([82.119.242.94]:53859 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965317AbXCFQmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:42:39 -0500
Date: Tue, 6 Mar 2007 17:47:45 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@osdl.org
Subject: [PATCH 4/6] UDF cleanup and fixes
Message-ID: <20070306164745.GG3661@duck.suse.cz>
References: <20070306164447.GC3661@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306164447.GC3661@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few assertions into udf_discard_prealloc() to check that the file
is sane (mostly helps debugging further patches ;).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-3-udf_buffer_handling/fs/udf/truncate.c linux-2.6.20-4-udf_discard_prealloc_cleanup/fs/udf/truncate.c
--- linux-2.6.20-3-udf_buffer_handling/fs/udf/truncate.c	2007-03-06 15:02:33.000000000 +0100
+++ linux-2.6.20-4-udf_discard_prealloc_cleanup/fs/udf/truncate.c	2007-03-06 15:03:00.000000000 +0100
@@ -88,8 +88,9 @@ void udf_discard_prealloc(struct inode *
 	{
 		etype = netype;
 		lbcount += elen;
-		if (lbcount > inode->i_size && lbcount - inode->i_size < inode->i_sb->s_blocksize)
+		if (lbcount > inode->i_size && lbcount - elen < inode->i_size)
 		{
+			WARN_ON(lbcount - inode->i_size >= inode->i_sb->s_blocksize);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
 			extent_trunc(inode, &epos, eloc, etype, elen, nelen);
@@ -119,6 +120,7 @@ void udf_discard_prealloc(struct inode *
 	}
 	UDF_I_LENEXTENTS(inode) = lbcount;
 
+	WARN_ON(lbcount != inode->i_size);
 	brelse(epos.bh);
 }
 
