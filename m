Return-Path: <linux-kernel-owner+w=401wt.eu-S1031464AbXDZTNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031464AbXDZTNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031462AbXDZTNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:13:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031459AbXDZTNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:13:42 -0400
Date: Thu, 26 Apr 2007 15:13:37 -0400
From: Jeff Layton <jlayton@redhat.com>
To: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: ffilz@us.ibm.com
Subject: [PATCH] NFS: supress warnings about NFS4ERR_OLD_STATEID in
	nfs4_handle_exception
Message-ID: <20070426191336.GB31081@dantu.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I recently posted this patch to the nfs mailing list, but got no comment.
Reposting with an actual "[PATCH]" subject...

In certain situations, a NFSv4 client can end up with a set of racing calls
that cause the server to return a NFS4ERR_OLD_STATEID error. When this occurs,
the only real recourse that the client has is to retry the call. In the
current code, when this occurs, it triggers a useless printk (in
nfs4_map_errors):

    nfs4_map_errors could not handle NFSv4 error 10024

Trond recently mentioned that we really don't need to worry users with that
info. The following patch is based on a suggestion by Frank Filz and supresses
this error. Changing the return code here to 0 should be safe since all callers
of nfs4_handle_exception are expected to retry the call in this situation
anyway.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Frank Filz <ffilz@us.ibm.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f52cf5c..b456783 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2774,6 +2774,7 @@ int nfs4_handle_exception(const struct nfs_server *server, int errorcode, struct
 				break;
 		case -NFS4ERR_OLD_STATEID:
 			exception->retry = 1;
+			ret = 0;
 	}
 	/* We failed to handle the error */
 	return nfs4_map_errors(ret);
