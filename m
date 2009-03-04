Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZCDJXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZCDJXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZCDJX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:23:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZCDJXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:23:24 -0500
Message-ID: <49AE484C.8020801@cn.fujitsu.com>
Date: Wed, 04 Mar 2009 17:22:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] rcu: introduce kfree_rcu V2
References: <49AD342D.6030609@cn.fujitsu.com> <20090303140955.GD23822@elte.hu>
In-Reply-To: <20090303140955.GD23822@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Nice idea. The patches dont actually remove the RCU helpers 
> anywhere. Might be useful to include a few example conversions 
> of this facility as well, so that the total impact can be seen.
> 
> 

This is one of patches I test kfree_rcu().
And it could be an example conversions of this facility.

---
 arch/ia64/sn/kernel/irq.c           |   14 +-----------
 block/genhd.c                       |   10 --------
 ipc/sem.c                           |   10 +-------
 kernel/audit_tree.c                 |    8 ------
 kernel/cgroup.c                     |    9 -------
 kernel/smp.c                        |   11 ---------
 mm/vmalloc.c                        |   18 +--------------
 net/can/af_can.c                    |   14 +-----------
 net/core/gen_estimator.c            |    9 -------
 net/core/net_namespace.c            |   10 --------
 net/ipv4/fib_trie.c                 |    7 ------
 net/ipv6/addrconf.c                 |   10 --------
 net/netfilter/nf_conntrack_extend.c |    8 ------
 net/netlabel/netlabel_unlabeled.c   |   42 +-----------------------------------
 security/device_cgroup.c            |   10 --------
 security/keys/keyring.c             |   15 ------------
 security/keys/user_defined.c        |   18 +--------------
 security/selinux/netif.c            |   18 ---------------
 security/selinux/netnode.c          |   20 +----------------
 security/selinux/netport.c          |   20 +----------------
 20 files changed, 28 insertions(+), 253 deletions(-)

diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 66fd705..f955177 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -135,8 +135,6 @@ static void sn_end_irq(unsigned int irq)
 		force_interrupt(irq);
 }
 
-static void sn_irq_info_free(struct rcu_head *head);
-
 struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
 				       nasid_t nasid, int slice)
 {
@@ -200,7 +198,7 @@ struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
 	spin_lock(&sn_irq_info_lock);
 	list_replace_rcu(&sn_irq_info->list, &new_irq_info->list);
 	spin_unlock(&sn_irq_info_lock);
-	call_rcu(&sn_irq_info->rcu, sn_irq_info_free);
+	kfree_rcu(sn_irq_info, rcu);
 
 
 finish_up:
@@ -360,14 +358,6 @@ static void unregister_intr_pda(struct sn_irq_info *sn_irq_info)
 	rcu_read_unlock();
 }
 
-static void sn_irq_info_free(struct rcu_head *head)
-{
-	struct sn_irq_info *sn_irq_info;
-
-	sn_irq_info = container_of(head, struct sn_irq_info, rcu);
-	kfree(sn_irq_info);
-}
-
 void sn_irq_fixup(struct pci_dev *pci_dev, struct sn_irq_info *sn_irq_info)
 {
 	nasid_t nasid = sn_irq_info->irq_nasid;
@@ -423,7 +413,7 @@ void sn_irq_unfixup(struct pci_dev *pci_dev)
 	spin_unlock(&sn_irq_info_lock);
 	if (list_empty(sn_irq_lh[sn_irq_info->irq_irq]))
 		free_irq_vector(sn_irq_info->irq_irq);
-	call_rcu(&sn_irq_info->rcu, sn_irq_info_free);
+	kfree_rcu(sn_irq_info, rcu);
 	pci_dev_put(pci_dev);
 
 }
diff --git a/block/genhd.c b/block/genhd.c
index 397960c..8d0da23 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -875,14 +875,6 @@ static struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
-{
-	struct disk_part_tbl *ptbl =
-		container_of(head, struct disk_part_tbl, rcu_head);
-
-	kfree(ptbl);
-}
-
 /**
  * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
  * @disk: disk to replace part_tbl for
@@ -903,7 +895,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 
 	if (old_ptbl) {
 		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
-		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
+		kfree_rcu(old_ptbl, rcu_head);
 	}
 }
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 16a2189..7c2f733 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -504,12 +504,6 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	return semzcnt;
 }
 
-static void free_un(struct rcu_head *head)
-{
-	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
-	kfree(un);
-}
-
 /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
@@ -528,7 +522,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1354,7 +1348,7 @@ void exit_sem(struct task_struct *tsk)
 		update_queue(sma);
 		sem_unlock(sma);
 
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 8ad9545..e68a2e7 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -91,16 +91,10 @@ static inline void get_tree(struct audit_tree *tree)
 	atomic_inc(&tree->count);
 }
 
-static void __put_tree(struct rcu_head *rcu)
-{
-	struct audit_tree *tree = container_of(rcu, struct audit_tree, head);
-	kfree(tree);
-}
-
 static inline void put_tree(struct audit_tree *tree)
 {
 	if (atomic_dec_and_test(&tree->count))
-		call_rcu(&tree->head, __put_tree);
+		kfree_rcu(tree, head);
 }
 
 /* to avoid bringing the entire thing in audit.h */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5a54ff4..e0fd67c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -594,13 +594,6 @@ static void cgroup_call_pre_destroy(struct cgroup *cgrp)
 	return;
 }
 
-static void free_cgroup_rcu(struct rcu_head *obj)
-{
-	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
-
-	kfree(cgrp);
-}
-
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -632,7 +625,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 */
 		deactivate_super(cgrp->root->sb);
 
-		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
+		kfree_rcu(cgrp, rcu_head);
 	}
 	iput(inode);
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index bbedbb7..69892fa 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -85,15 +85,6 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
 		csd_flag_wait(data);
 }
 
-static void rcu_free_call_data(struct rcu_head *head)
-{
-	struct call_function_data *data;
-
-	data = container_of(head, struct call_function_data, rcu_head);
-
-	kfree(data);
-}
-
 /*
  * Invoked by arch to handle an IPI for call function. Must be called with
  * interrupts disabled.
@@ -139,7 +130,7 @@ void generic_smp_call_function_interrupt(void)
 			data->csd.flags &= ~CSD_FLAG_WAIT;
 		}
 		if (data->csd.flags & CSD_FLAG_ALLOC)
-			call_rcu(&data->rcu_head, rcu_free_call_data);
+			kfree_rcu(data, rcu_head);
 	}
 	rcu_read_unlock();
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 75f49d3..a7311ea 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -399,13 +399,6 @@ found:
 	return va;
 }
 
-static void rcu_free_va(struct rcu_head *head)
-{
-	struct vmap_area *va = container_of(head, struct vmap_area, rcu_head);
-
-	kfree(va);
-}
-
 static void __free_vmap_area(struct vmap_area *va)
 {
 	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
@@ -413,7 +406,7 @@ static void __free_vmap_area(struct vmap_area *va)
 	RB_CLEAR_NODE(&va->rb_node);
 	list_del_rcu(&va->list);
 
-	call_rcu(&va->rcu_head, rcu_free_va);
+	kfree_rcu(va, rcu_head);
 }
 
 /*
@@ -742,13 +735,6 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	return vb;
 }
 
-static void rcu_free_vb(struct rcu_head *head)
-{
-	struct vmap_block *vb = container_of(head, struct vmap_block, rcu_head);
-
-	kfree(vb);
-}
-
 static void free_vmap_block(struct vmap_block *vb)
 {
 	struct vmap_block *tmp;
@@ -768,7 +754,7 @@ static void free_vmap_block(struct vmap_block *vb)
 	BUG_ON(tmp != vb);
 
 	free_unmap_vmap_area_noflush(vb->va);
-	call_rcu(&vb->rcu_head, rcu_free_vb);
+	kfree_rcu(vb, rcu_head);
 }
 
 static void *vb_alloc(unsigned long size, gfp_t gfp_mask)
diff --git a/net/can/af_can.c b/net/can/af_can.c
index fa417ca..0c7ad27 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -471,16 +471,6 @@ int can_rx_register(struct net_device *dev, canid_t can_id, canid_t mask,
 EXPORT_SYMBOL(can_rx_register);
 
 /*
- * can_rx_delete_device - rcu callback for dev_rcv_lists structure removal
- */
-static void can_rx_delete_device(struct rcu_head *rp)
-{
-	struct dev_rcv_lists *d = container_of(rp, struct dev_rcv_lists, rcu);
-
-	kfree(d);
-}
-
-/*
  * can_rx_delete_receiver - rcu callback for single receiver entry removal
  */
 static void can_rx_delete_receiver(struct rcu_head *rp)
@@ -569,7 +559,7 @@ void can_rx_unregister(struct net_device *dev, canid_t can_id, canid_t mask,
 
 	/* schedule the device structure for deletion */
 	if (d)
-		call_rcu(&d->rcu, can_rx_delete_device);
+		kfree_rcu(d, rcu);
 }
 EXPORT_SYMBOL(can_rx_unregister);
 
@@ -815,7 +805,7 @@ static int can_notifier(struct notifier_block *nb, unsigned long msg,
 		spin_unlock(&can_rcvlists_lock);
 
 		if (d)
-			call_rcu(&d->rcu, can_rx_delete_device);
+			kfree_rcu(d, rcu);
 
 		break;
 	}
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 9cc9f95..fa3b8d1 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -245,13 +245,6 @@ int gen_new_estimator(struct gnet_stats_basic *bstats,
 }
 EXPORT_SYMBOL(gen_new_estimator);
 
-static void __gen_kill_estimator(struct rcu_head *head)
-{
-	struct gen_estimator *e = container_of(head,
-					struct gen_estimator, e_rcu);
-	kfree(e);
-}
-
 /**
  * gen_kill_estimator - remove a rate estimator
  * @bstats: basic statistics
@@ -274,7 +267,7 @@ void gen_kill_estimator(struct gnet_stats_basic *bstats,
 		write_unlock_bh(&est_lock);
 
 		list_del_rcu(&e->list);
-		call_rcu(&e->e_rcu, __gen_kill_estimator);
+		kfree_rcu(e, e_rcu);
 	}
 }
 EXPORT_SYMBOL(gen_kill_estimator);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 55151fa..5b700dc 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -441,14 +441,6 @@ void unregister_pernet_gen_device(int id, struct pernet_operations *ops)
 }
 EXPORT_SYMBOL_GPL(unregister_pernet_gen_device);
 
-static void net_generic_release(struct rcu_head *rcu)
-{
-	struct net_generic *ng;
-
-	ng = container_of(rcu, struct net_generic, rcu);
-	kfree(ng);
-}
-
 int net_assign_generic(struct net *net, int id, void *data)
 {
 	struct net_generic *ng, *old_ng;
@@ -480,7 +472,7 @@ int net_assign_generic(struct net *net, int id, void *data)
 	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len);
 
 	rcu_assign_pointer(net->gen, ng);
-	call_rcu(&old_ng->rcu, net_generic_release);
+	kfree_rcu(old_ng, rcu);
 assign:
 	ng->ptr[id - 1] = data;
 	return 0;
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ec0ae49..d306bf1 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -339,14 +339,9 @@ static inline void free_leaf(struct leaf *l)
 	call_rcu_bh(&l->rcu, __leaf_free_rcu);
 }
 
-static void __leaf_info_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct leaf_info, rcu));
-}
-
 static inline void free_leaf_info(struct leaf_info *leaf)
 {
-	call_rcu(&leaf->rcu, __leaf_info_free_rcu);
+	kfree_rcu(leaf, rcu);
 }
 
 static struct tnode *tnode_alloc(size_t size)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f9afb45..4238a39 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -302,14 +302,6 @@ static void snmp6_free_dev(struct inet6_dev *idev)
 	snmp_mib_free((void **)idev->stats.ipv6);
 }
 
-/* Nobody refers to this device, we may destroy it. */
-
-static void in6_dev_finish_destroy_rcu(struct rcu_head *head)
-{
-	struct inet6_dev *idev = container_of(head, struct inet6_dev, rcu);
-	kfree(idev);
-}
-
 void in6_dev_finish_destroy(struct inet6_dev *idev)
 {
 	struct net_device *dev = idev->dev;
@@ -326,7 +318,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 		return;
 	}
 	snmp6_free_dev(idev);
-	call_rcu(&idev->rcu, in6_dev_finish_destroy_rcu);
+	kfree_rcu(idev, rcu);
 }
 
 EXPORT_SYMBOL(in6_dev_finish_destroy);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 4b2c769..e07348b 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -66,12 +66,6 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)(*ext) + off;
 }
 
-static void __nf_ct_ext_free_rcu(struct rcu_head *head)
-{
-	struct nf_ct_ext *ext = container_of(head, struct nf_ct_ext, rcu);
-	kfree(ext);
-}
-
 void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *new;
@@ -111,7 +105,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 					(void *)ct->ext + ct->ext->offset[i]);
 			rcu_read_unlock();
 		}
-		call_rcu(&ct->ext->rcu, __nf_ct_ext_free_rcu);
+		kfree_rcu(ct->ext, rcu);
 		ct->ext = new;
 	}
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index f3c5c68..afd0ba8 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -150,44 +150,6 @@ static const struct nla_policy netlbl_unlabel_genl_policy[NLBL_UNLABEL_A_MAX + 1
  */
 
 /**
- * netlbl_unlhsh_free_addr4 - Frees an IPv4 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr4(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr4 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr4, rcu);
-	kfree(ptr);
-}
-
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-/**
- * netlbl_unlhsh_free_addr6 - Frees an IPv6 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr6(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr6 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr6, rcu);
-	kfree(ptr);
-}
-#endif /* IPv6 */
-
-/**
  * netlbl_unlhsh_free_iface - Frees an interface entry from the hash table
  * @entry: the entry's RCU field
  *
@@ -600,7 +562,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr4);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 
@@ -662,7 +624,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr6);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 #endif /* IPv6 */
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 3aacd0f..dcf11f4 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -121,14 +121,6 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 	return 0;
 }
 
-static void whitelist_item_free(struct rcu_head *rcu)
-{
-	struct dev_whitelist_item *item;
-
-	item = container_of(rcu, struct dev_whitelist_item, rcu);
-	kfree(item);
-}
-
 /*
  * called under cgroup_lock()
  */
@@ -151,7 +143,7 @@ remove:
 		walk->access &= ~wh->access;
 		if (!walk->access) {
 			list_del_rcu(&walk->list);
-			call_rcu(&walk->rcu, whitelist_item_free);
+			kfree_rcu(walk, rcu);
 		}
 	}
 }
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index ed85157..33ac501 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -655,19 +655,6 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 
 /*****************************************************************************/
 /*
- * dispose of a keyring list after the RCU grace period
- */
-static void keyring_link_rcu_disposal(struct rcu_head *rcu)
-{
-	struct keyring_list *klist =
-		container_of(rcu, struct keyring_list, rcu);
-
-	kfree(klist);
-
-} /* end keyring_link_rcu_disposal() */
-
-/*****************************************************************************/
-/*
  * dispose of a keyring list after the RCU grace period, freeing the unlinked
  * key
  */
@@ -806,7 +793,7 @@ int __key_link(struct key *keyring, struct key *key)
 
 		/* dispose of the old keyring list */
 		if (klist)
-			call_rcu(&klist->rcu, keyring_link_rcu_disposal);
+			kfree_rcu(klist, rcu);
 	}
 
 done:
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 7c687d5..79e5e96 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -72,20 +72,6 @@ EXPORT_SYMBOL_GPL(user_instantiate);
 
 /*****************************************************************************/
 /*
- * dispose of the old data from an updated user defined key
- */
-static void user_update_rcu_disposal(struct rcu_head *rcu)
-{
-	struct user_key_payload *upayload;
-
-	upayload = container_of(rcu, struct user_key_payload, rcu);
-
-	kfree(upayload);
-
-} /* end user_update_rcu_disposal() */
-
-/*****************************************************************************/
-/*
  * update a user defined key
  * - the key's semaphore is write-locked
  */
@@ -119,7 +105,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 		key->expiry = 0;
 	}
 
-	call_rcu(&zap->rcu, user_update_rcu_disposal);
+	kfree_rcu(zap, rcu);
 
 error:
 	return ret;
@@ -154,7 +140,7 @@ void user_revoke(struct key *key)
 
 	if (upayload) {
 		rcu_assign_pointer(key->payload.data, NULL);
-		call_rcu(&upayload->rcu, user_update_rcu_disposal);
+		kfree_rcu(upayload, rcu);
 	}
 
 } /* end user_revoke() */
diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index b4e14bc..b8a6657 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -103,22 +103,6 @@ static int sel_netif_insert(struct sel_netif *netif)
 }
 
 /**
- * sel_netif_free - Frees an interface entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table interface entry can be
- * released safely.
- *
- */
-static void sel_netif_free(struct rcu_head *p)
-{
-	struct sel_netif *netif = container_of(p, struct sel_netif, rcu_head);
-	kfree(netif);
-}
-
-/**
  * sel_netif_destroy - Remove an interface record from the table
  * @netif: the existing interface record
  *
@@ -130,7 +114,7 @@ static void sel_netif_destroy(struct sel_netif *netif)
 {
 	list_del_rcu(&netif->list);
 	sel_netif_total--;
-	call_rcu(&netif->rcu_head, sel_netif_free);
+	kfree_rcu(netif, rcu_head);
 }
 
 /**
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 7100072..563bbc3 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -68,22 +68,6 @@ static DEFINE_SPINLOCK(sel_netnode_lock);
 static struct sel_netnode_bkt sel_netnode_hash[SEL_NETNODE_HASH_SIZE];
 
 /**
- * sel_netnode_free - Frees a node entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table node entry can be
- * released safely.
- *
- */
-static void sel_netnode_free(struct rcu_head *p)
-{
-	struct sel_netnode *node = container_of(p, struct sel_netnode, rcu);
-	kfree(node);
-}
-
-/**
  * sel_netnode_hashfn_ipv4 - IPv4 hashing function for the node table
  * @addr: IPv4 address
  *
@@ -193,7 +177,7 @@ static void sel_netnode_insert(struct sel_netnode *node)
 			rcu_dereference(sel_netnode_hash[idx].list.prev),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netnode_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netnode_hash[idx].size++;
 }
@@ -306,7 +290,7 @@ static void sel_netnode_flush(void)
 		list_for_each_entry_safe(node, node_tmp,
 					 &sel_netnode_hash[idx].list, list) {
 				list_del_rcu(&node->list);
-				call_rcu(&node->rcu, sel_netnode_free);
+				kfree_rcu(node, rcu);
 		}
 		sel_netnode_hash[idx].size = 0;
 	}
diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index fe7fba6..86586e0 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -67,22 +67,6 @@ static DEFINE_SPINLOCK(sel_netport_lock);
 static struct sel_netport_bkt sel_netport_hash[SEL_NETPORT_HASH_SIZE];
 
 /**
- * sel_netport_free - Frees a port entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table port entry can be
- * released safely.
- *
- */
-static void sel_netport_free(struct rcu_head *p)
-{
-	struct sel_netport *port = container_of(p, struct sel_netport, rcu);
-	kfree(port);
-}
-
-/**
  * sel_netport_hashfn - Hashing function for the port table
  * @pnum: port number
  *
@@ -141,7 +125,7 @@ static void sel_netport_insert(struct sel_netport *port)
 			rcu_dereference(sel_netport_hash[idx].list.prev),
 			struct sel_netport, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netport_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netport_hash[idx].size++;
 }
@@ -240,7 +224,7 @@ static void sel_netport_flush(void)
 		list_for_each_entry_safe(port, port_tmp,
 					 &sel_netport_hash[idx].list, list) {
 			list_del_rcu(&port->list);
-			call_rcu(&port->rcu, sel_netport_free);
+			kfree_rcu(port, rcu);
 		}
 		sel_netport_hash[idx].size = 0;
 	}


