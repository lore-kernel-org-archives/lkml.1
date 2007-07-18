Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXGRP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXGRP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXGRP2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:28:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbXGRP2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:28:51 -0400
Date: Wed, 18 Jul 2007 11:28:43 -0400
From: Jeff Layton <jlayton@redhat.com>
To: nfsv4@linux-nfs.org, nfs@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NFSv4: handle lack of clientaddr in option string
 gracefully
Message-Id: <20070718112843.08644184.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a NFSv4 mount is attempted  with string based options, and the
option string doesn't contain a clientaddr= option, the kernel will
currently oops. Check for this situation and return a proper error.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a2b1af8..ff06b95 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1683,6 +1683,9 @@ static int nfs4_validate_mount_data(struct nfs4_mount_data **options,
 
 		dprintk("MNTPATH: %s\n", *mntpath);
 
+		if (args.client_address == NULL)
+			goto out_no_client_address;
+
 		*ip_addr = args.client_address;
 
 		break;
@@ -1703,6 +1706,10 @@ out_inval_auth:
 out_no_address:
 	dfprintk(MOUNT, "NFS4: mount program didn't pass remote address\n");
 	return -EINVAL;
+
+out_no_client_address:
+	dfprintk(MOUNT, "NFS4: mount program didn't pass callback address\n");
+	return -EINVAL;
 }
 
 /*
