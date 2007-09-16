Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXIPVSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXIPVSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXIPVSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:18:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:44222 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXIPVSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=N8ccMfSbxUZFL5p2GnZ2ZsD/TVK+Pztx7n7Tlnzby3EuqoE1uaC1idp5PXzck8mllXhD/C8r9MfK7QqUzJXg3ZuRNc1usjBUTiu/5HDSFW2J9bkPJz8nuOObOXbpXOHt7QosPZvW0HIpEWV1Rt/Ca+UoOT4rhNjm+b3MntDhCGA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Steve French <sfrench@samba.org>
Subject: [PATCH] cifs: Fix a small memory leak in directory creation code.
Date: Sun, 16 Sep 2007 23:15:03 +0200
User-Agent: KMail/1.9.7
Cc: Steve French <sfrench@us.ibm.com>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162315.03569.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There is a small memory leak in fs/cifs/inode.c::cifs_mkdir().
Storage for 'pInfo' is allocated with kzalloc(), but if the call  
to CIFSPOSIXCreate(...) happens to return 0 and pInfo->Type == -1, 
then we'll jump to the 'mkdir_get_info' label without freeing the 
storage allocated for 'pInfo'.
This patch adds a kfree() call to free the storage just before 
jumping to the label, thus getting rid of the leak.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6/fs/cifs/inode.c~	2007-09-16 23:01:52.000000000 +0200
+++ linux-2.6/fs/cifs/inode.c	2007-09-16 23:01:52.000000000 +0200
@@ -929,8 +929,10 @@ int cifs_mkdir(struct inode *inode, stru
 			d_drop(direntry);
 		} else {
 			int obj_type;
-			if (pInfo->Type == -1) /* no return info - go query */
+			if (pInfo->Type == -1) { /* no return info - go query */
+				kfree(pInfo);
 				goto mkdir_get_info;
+			}
 /*BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if need
 	to set uid/gid */
 			inc_nlink(inode);


