Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZKFWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZKFWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZKFWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:08:10 -0500
Received: from kroah.org ([198.145.64.141]:39809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbZKFWGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215953.120260379@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [24/30] NFSv4: Kill nfs4_renewd_prepare_shutdown()
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=nfsv4-kill-nfs4_renewd_prepare_shutdown.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 3050141bae57984dd660e6861632ccf9b8bca77e upstream.

The NFSv4 renew daemon is shared between all active super blocks that refer
to a particular NFS server, so it is wrong to be shutting it down in
nfs4_kill_super every time a super block is destroyed.

This patch therefore kills nfs4_renewd_prepare_shutdown altogether, and
leaves it up to nfs4_shutdown_client() to also shut down the renew daemon
by means of the existing call to nfs4_kill_renewd().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4renewd.c |    6 ------
 fs/nfs/super.c      |    1 -
 2 files changed, 7 deletions(-)

--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -125,12 +125,6 @@ nfs4_schedule_state_renewal(struct nfs_c
 }
 
 void
-nfs4_renewd_prepare_shutdown(struct nfs_server *server)
-{
-	cancel_delayed_work(&server->nfs_client->cl_renewd);
-}
-
-void
 nfs4_kill_renewd(struct nfs_client *clp)
 {
 	cancel_delayed_work_sync(&clp->cl_renewd);
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2398,7 +2398,6 @@ static void nfs4_kill_super(struct super
 	nfs_return_all_delegations(sb);
 	kill_anon_super(sb);
 
-	nfs4_renewd_prepare_shutdown(server);
 	nfs_free_server(server);
 }
 


