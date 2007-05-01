Return-Path: <linux-kernel-owner+w=401wt.eu-S1031252AbXEAScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031252AbXEAScc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031243AbXEAScb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:32:31 -0400
Received: from smtp004.mail.ukl.yahoo.com ([217.12.11.35]:28474 "HELO
	smtp004.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031252AbXEASca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:32:30 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 14:32:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-YMail-OSG:From:Organization:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZMauBVgoSMUo9J60r4PvpjCmmiy/nmU5cHwSNO2c6P/+Rl3/+SXtXQhu7YEo4SaqHkkEpXyN2UNkKqPk/BZZR2kLYVtWLEWTCADxZjUBRNxV1oX5eqGfAqiPLepAqHblgzUw3yAqCbyS8RPSUjgo6g5IZu4NivgpzgbyEdJTr78=  ;
X-YMail-OSG: 1AlIuiYVM1n.tDZgofnv3_y1T2Et_EQRBl4otLXNNDY8dDRWMgqXd3gXK_yz7ggy0abW.r.fJQ--
From: Stephen Mollett <molletts@yahoo.com>
Organization: Organisation? What's that?
To: bfennema@falcon.csc.calpoly.edu
Subject: [PATCH 2.6.21] udf: Decrement correct link count in udf_rmdir
Date: Tue, 1 May 2007 19:23:14 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705011923.14950.molletts@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that a minor thinko occurred in udf_rmdir and the (already-cleared) 
link count on the directory that is being removed was being decremented 
instead of the link count on its parent directory. This gives rise to lots of 
kernel messages similar to:

UDF-fs warning (device loop1): udf_rmdir: empty directory has nlink != 2 (8)

when removing directory trees. No other ill effects have been observed but I 
guess it could theoretically result in the link count overflowing on a very 
long-lived, much modified directory.

Signed-off-by: Stephen Mollett <molletts@yahoo.com>
---

Patch applies cleanly to latest git snapshot and other recent 2.6 kernels.

Please CC: me as I'm not currently subscribed to linux-kernel.

First attempt at formally submitting a kernel patch - apologies if I've cocked 
something up - please be nice :-)


--- linux-2.6.21/fs/udf/namei.c.orig	2007-05-01 18:52:02.000000000 +0100
+++ linux-2.6.21/fs/udf/namei.c	2007-05-01 18:53:00.000000000 +0100
@@ -878,7 +878,7 @@ static int udf_rmdir(struct inode * dir,
 			inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
-	inode_dec_link_count(inode);
+	inode_dec_link_count(dir);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 
