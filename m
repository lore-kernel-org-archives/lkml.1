Return-Path: <linux-kernel-owner+w=401wt.eu-S1763127AbYBFXEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763127AbYBFXEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbYBFXD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:03:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:61690 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762212AbYBFXD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Utgmr9lCBlkBjPmGELT+nidxM/YtGDm2i4BwygW6rPB0CI/ufOFcH+npHq6T5IJBoIJh+Rton6+E/y6iJCcIMXx1hfIF8pS1GCXr6Y4c7Oi6Z5O508imyRl2mHG+Q90VKzWeQGIVohSuZtRlJmiT5m5NzA1rQModhnEM8VCOXWY=
Message-ID: <6101e8c40802061503u2f29b4d4q9658fbb019c40384@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:03:52 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {15/17} - nfs-unmount-leak.patch - series for stable kernel #2
In-Reply-To: <6101e8c40802011734q30246d66jcd08d17f9a541af3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734q30246d66jcd08d17f9a541af3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue Dec 11 11:05:19 2007 -0500
Subject: NFSv2/v3: Fix a memory leak when using -onolock
Patch-mainline: 2.6.24
References: 336253



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



On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 13ef7b69b54aa8ae4ed264d0bf41339737f8543a
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
