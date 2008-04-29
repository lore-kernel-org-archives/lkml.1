Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbYD2LQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbYD2LQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbYD2LNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29516 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYD2LN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:28 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/12] net: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:13 +0400
Message-Id: <1209467602-20001-3-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.
Additionally, there is no need to assign NULL to PDE->data after creation,
/proc generic has already done this for us.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
---
 net/core/neighbour.c |    5 ++---
 net/core/pktgen.c    |   14 +++++---------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 75075c3..f4f9a63 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1430,11 +1430,10 @@ void neigh_table_init_no_netlink(struct neigh_table *tbl)
 		panic("cannot create neighbour cache statistics");
 
 #ifdef CONFIG_PROC_FS
-	tbl->pde = proc_create(tbl->id, 0, init_net.proc_net_stat,
-			       &neigh_stat_seq_fops);
+	tbl->pde = proc_create_data(tbl->id, 0, init_net.proc_net_stat,
+				    &neigh_stat_seq_fops, tbl);
 	if (!tbl->pde)
 		panic("cannot create neighbour proc dir entry");
-	tbl->pde->data = tbl;
 #endif
 
 	tbl->hash_mask = 1;
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a803b44..48a48c8 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3570,15 +3570,14 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 	if (err)
 		goto out1;
 
-	pkt_dev->entry = proc_create(ifname, 0600,
-				     pg_proc_dir, &pktgen_if_fops);
+	pkt_dev->entry = proc_create_data(ifname, 0600, pg_proc_dir,
+					  &pktgen_if_fops, pkt_dev);
 	if (!pkt_dev->entry) {
 		printk(KERN_ERR "pktgen: cannot create %s/%s procfs entry.\n",
 		       PG_PROC_DIR, ifname);
 		err = -EINVAL;
 		goto out2;
 	}
-	pkt_dev->entry->data = pkt_dev;
 #ifdef CONFIG_XFRM
 	pkt_dev->ipsmode = XFRM_MODE_TRANSPORT;
 	pkt_dev->ipsproto = IPPROTO_ESP;
@@ -3628,7 +3627,8 @@ static int __init pktgen_create_thread(int cpu)
 	kthread_bind(p, cpu);
 	t->tsk = p;
 
-	pe = proc_create(t->tsk->comm, 0600, pg_proc_dir, &pktgen_thread_fops);
+	pe = proc_create_data(t->tsk->comm, 0600, pg_proc_dir,
+			      &pktgen_thread_fops, t);
 	if (!pe) {
 		printk(KERN_ERR "pktgen: cannot create %s/%s procfs entry.\n",
 		       PG_PROC_DIR, t->tsk->comm);
@@ -3638,8 +3638,6 @@ static int __init pktgen_create_thread(int cpu)
 		return -EINVAL;
 	}
 
-	pe->data = t;
-
 	wake_up_process(p);
 
 	return 0;
@@ -3716,8 +3714,6 @@ static int __init pg_init(void)
 		return -EINVAL;
 	}
 
-	pe->data = NULL;
-
 	/* Register us to receive netdevice events */
 	register_netdevice_notifier(&pktgen_notifier_block);
 
-- 
1.5.3.rc5

