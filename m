Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZIXNhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZIXNhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIXNhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:37:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41100 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZIXNhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:37:01 -0400
Date: Thu, 24 Sep 2009 14:37:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond.Myklebust@netapp.com
Cc: linux-kernel@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH] nfs[23] tcp breakage in mount with binary options
Message-ID: <20090924133703.GN14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forget to set nfs_server.protocol in tcp case when old-style binary
options are passed to mount.  The thing remains zero and never validated
afterwards.  As the result, we hit BUG in fs/nfs/client.c:588.

Breakage has been introduced in NFS: Add nfs_alloc_parsed_mount_data
merged yesterday...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 810770f..29786d3 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1711,6 +1711,8 @@ static int nfs_validate_mount_data(void *options,
 
 		if (!(data->flags & NFS_MOUNT_TCP))
 			args->nfs_server.protocol = XPRT_TRANSPORT_UDP;
+		else
+			args->nfs_server.protocol = XPRT_TRANSPORT_TCP;
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrdup(data->hostname, GFP_KERNEL);
 		args->namlen		= data->namlen;
