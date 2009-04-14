Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZDNHgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZDNHgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDNHgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:36:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:22249 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZDNHgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tdOAc7mBsfyfEpVTLpMb5gXE1vPTI9QmsIuh1P8OnB0MNUImjyfWWDZ/3xOlO/LppG
         +fpGmILEi/WQICeg0d8fS2GEESRXFViF8OhVnp3iGzbArRBG6y1h+flUZXtthW/DpPzM
         9CbYf3X6hbF/i8iIYa3u+3xP8wEc/nVV8Zk7Y=
Date: Tue, 14 Apr 2009 16:36:31 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext2: fix missing mutex_unlock in error path
Message-ID: <20090414073631.GA4145@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing mutex_unlock in error path in ext2_quota_write()

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f983225..5c4afe6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1395,8 +1395,10 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
 	inode->i_version++;
