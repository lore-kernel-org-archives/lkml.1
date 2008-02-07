Return-Path: <linux-kernel-owner+w=401wt.eu-S933748AbYBGUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbYBGUJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbYBGUDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbYBGUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=K5DHJ3+So0YfA32GuKWtpaW9TSStREulBJ4pnyu+A7bpzsR9V6GucM58odGF4CMox9S43yFKyLbBoCqnqofZInLhlj63nckllij18SIRxWAv2QMCuRyu6dlLCrJOZWdOX1xpnwBYdCFA5sQsWXHctuCuaoqLZaot6P2atXoZfWc=
Message-ID: <6101e8c40802071203o1b32c2c2md53859623228463@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:52 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {13/14} - NFSv2/v3: Fix a memory leak when using -onolock - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: nfs-unmount-leak.patch

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue Dec 11 11:05:19 2007 -0500
Subject: NFSv2/v3: Fix a memory leak when using -onolock
Patch-mainline: 2.6.24
References: 336253

mainline: 13ef7b69b54aa8ae4ed264d0bf41339737f8543a

    Neil Brown said:
    > Hi Trond,
    >
    > We found that a machine which made moderately heavy use of
    > 'automount' was leaking some nfs data structures - particularly the
    > 4K allocated by rpc_alloc_iostats.
    > It turns out that this only happens with filesystems with -onolock
    > set.

    > The problem is that if NFS_MOUNT_NONLM is set, nfs_start_lockd doesn't
    > set server->destroy, so when the filesystem is unmounted, the
    > ->client_acl is not shutdown, and so several resources are still
    > held.  Multiple mount/umount cycles will slowly eat away memory
    > several pages at a time.

    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Neil Brown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

---
 fs/nfs/client.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-SL103_BRANCH.orig/fs/nfs/client.c
+++ linux-2.6.22-SL103_BRANCH/fs/nfs/client.c
@@ -433,9 +433,6 @@ static int nfs_create_rpc_client(struct
  */
 static void nfs_destroy_server(struct nfs_server *server)
 {
-	if (!IS_ERR(server->client_acl))
-		rpc_shutdown_client(server->client_acl);
-
 	if (!(server->flags & NFS_MOUNT_NONLM))
 		lockd_down();	/* release rpc.lockd */
 }
@@ -771,6 +768,9 @@ void nfs_free_server(struct nfs_server *

 	if (server->destroy != NULL)
 		server->destroy(server);
+
+	if (!IS_ERR(server->client_acl))
+		rpc_shutdown_client(server->client_acl);
 	if (!IS_ERR(server->client))
 		rpc_shutdown_client(server->client);



-- 
Thanks,
Oliver
