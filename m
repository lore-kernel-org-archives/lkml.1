Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbZFWPbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbZFWPbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZFWP3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:29:50 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:49564 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbZFWP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:29:47 -0400
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 05/10] nfs: Use rcu_barrier() on module unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, axboe@kernel.dk,
       "Patrick McHardy" <kaber@trash.net>, christine.caulfield@googlemail.com,
       Trond.Myklebust@netapp.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, yoshfuji@linux-ipv6.org,
       shemminger@linux-foundation.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-ext4@vger.kernel.org,
       tytso@mit.edu, adilger@sun.com, netfilter-devel@vger.kernel.org
Date: Tue, 23 Jun 2009 17:04:19 +0200
Message-ID: <20090623150419.22490.94087.stgit@localhost>
In-Reply-To: <20090623150330.22490.87327.stgit@localhost>
References: <20090623150330.22490.87327.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exit path unregister and destroys a lot of stuff, but I have not
verified that nfs_free_delegation() cannot start new call_rcu() callbacks.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 fs/nfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 64f8719..40bf2b7 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1518,6 +1518,7 @@ static void __exit exit_nfs_fs(void)
 	unregister_nfs_fs();
 	nfs_fs_proc_exit();
 	nfsiod_stop();
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
 /* Not quite true; I just maintain it */

