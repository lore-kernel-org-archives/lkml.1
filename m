Return-Path: <linux-kernel-owner+w=401wt.eu-S935487AbYBVVwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487AbYBVVwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762456AbYBVVn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:60566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934AbYBVVnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:55 -0500
Date: Fri, 22 Feb 2008 13:40:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Brown <neilb@suse.de>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 17/23] NFSv2/v3: Fix a memory leak when using -onolock
Message-ID: <20080222214047.GR8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsv2-v3-fix-a-memory-leak-when-using-onolock.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>


mainline: 5cef338b30c110daf547fb13d99f0c77f2a79fbc

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/nfs/client.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
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
@@ -781,6 +778,9 @@ void nfs_free_server(struct nfs_server *
 
 	if (server->destroy != NULL)
 		server->destroy(server);
+
+	if (!IS_ERR(server->client_acl))
+		rpc_shutdown_client(server->client_acl);
 	if (!IS_ERR(server->client))
 		rpc_shutdown_client(server->client);
 

-- 
