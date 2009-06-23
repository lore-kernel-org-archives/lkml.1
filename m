Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbZFWPcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbZFWPcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZFWP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:29:55 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:49574 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbZFWP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:29:50 -0400
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 09/10] cfq-iosched: Uses its own open-coded rcu_barrier.
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
Date: Tue, 23 Jun 2009 17:04:39 +0200
Message-ID: <20090623150439.22490.14657.stgit@localhost>
In-Reply-To: <20090623150330.22490.87327.stgit@localhost>
References: <20090623150330.22490.87327.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module cfq-iosched, has discovered the value of waiting for
call_rcu() completion, but its has its own open-coded implementation
of rcu_barrier(), which I don't think is 'strong' enough.

This patch only leaves a comment for the maintainers to consider.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 block/cfq-iosched.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 833ec18..c15555b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2657,6 +2657,12 @@ static void __exit cfq_exit(void)
 	/*
 	 * this also protects us from entering cfq_slab_kill() with
 	 * pending RCU callbacks
+	 *
+	 * hawk@comx.dk 2009-06-18: Maintainer please consider using
+	 *  rcu_barrier() instead of this open-coded wait for
+	 *  completion implementation.  I think it provides a better
+	 *  guarantee that all CPUs are finished, although
+	 *  elv_ioc_count_read() do consider all CPUs.
 	 */
 	if (elv_ioc_count_read(ioc_count))
 		wait_for_completion(&all_gone);

