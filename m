Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbYDVBMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbYDVBMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761020AbYDVBMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:12:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34797 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760988AbYDVBMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:12:36 -0400
Date: Mon, 21 Apr 2008 18:12:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dwalker@mvista.com, sdietrich@novell.com, dvhltc@us.ibm.com,
       niv@us.ibm.com
Subject: Re: [PATCH] SELinux fixups needed for preemptable RCU from -rt
Message-ID: <20080422011233.GG9153@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080422003412.GA9983@linux.vnet.ibm.com> <Pine.LNX.4.58.0804212053530.25185@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0804212053530.25185@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 08:54:51PM -0400, Steven Rostedt wrote:
> 
> On Mon, 21 Apr 2008, Paul E. McKenney wrote:
> > @@ -807,8 +810,14 @@ int avc_ss_reset(u32 seqno)
> >
> >  	for (i = 0; i < AVC_CACHE_SLOTS; i++) {
> >  		spin_lock_irqsave(&avc_cache.slots_lock[i], flag);
> > +		/*
> > +		 * On -rt the outer spinlock does not prevent RCU
> > +		 * from being performed:
> 
> I would suggest to change this comment to "With preemptible RCU" from
> "On -rt".

Good point...  How about the following?

> -- Steve
> 
> > +		 */
> > +		rcu_read_lock();
> >  		list_for_each_entry(node, &avc_cache.slots[i], list)
> >  			avc_node_delete(node);
> > +		rcu_read_unlock();
> >  		spin_unlock_irqrestore(&avc_cache.slots_lock[i], flag);
> >  	}


Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com> (comment change)
---
 security/selinux/avc.c   |    9 +++++++++
 security/selinux/netif.c |    2 ++
 2 files changed, 11 insertions(+)

Index: linux-2.6.24.4-rt4/security/selinux/avc.c
===================================================================
--- linux-2.6.24.4-rt4.orig/security/selinux/avc.c	2008-03-24 19:05:09.000000000 -0400
+++ linux-2.6.24.4-rt4/security/selinux/avc.c	2008-03-24 19:06:41.000000000 -0400
@@ -312,6 +312,7 @@ static inline int avc_reclaim_node(void)
 		if (!spin_trylock_irqsave(&avc_cache.slots_lock[hvalue], flags))
 			continue;
 
+		rcu_read_lock();
 		list_for_each_entry(node, &avc_cache.slots[hvalue], list) {
 			if (atomic_dec_and_test(&node->ae.used)) {
 				/* Recently Unused */
@@ -319,11 +320,13 @@ static inline int avc_reclaim_node(void)
 				avc_cache_stats_incr(reclaims);
 				ecx++;
 				if (ecx >= AVC_CACHE_RECLAIM) {
+					rcu_read_unlock();
 					spin_unlock_irqrestore(&avc_cache.slots_lock[hvalue], flags);
 					goto out;
 				}
 			}
 		}
+		rcu_read_unlock();
 		spin_unlock_irqrestore(&avc_cache.slots_lock[hvalue], flags);
 	}
 out:
@@ -807,8 +810,14 @@ int avc_ss_reset(u32 seqno)
 
 	for (i = 0; i < AVC_CACHE_SLOTS; i++) {
 		spin_lock_irqsave(&avc_cache.slots_lock[i], flag);
+		/*
+		 * With preemptable RCU, the outer spinlock does not
+		 * prevent RCU grace periods from ending.
+		 */
+		rcu_read_lock();
 		list_for_each_entry(node, &avc_cache.slots[i], list)
 			avc_node_delete(node);
+		rcu_read_unlock();
 		spin_unlock_irqrestore(&avc_cache.slots_lock[i], flag);
 	}
 
Index: linux-2.6.24.4-rt4/security/selinux/netif.c
===================================================================
--- linux-2.6.24.4-rt4.orig/security/selinux/netif.c	2008-03-24 19:05:09.000000000 -0400
+++ linux-2.6.24.4-rt4/security/selinux/netif.c	2008-03-24 19:06:41.000000000 -0400
@@ -210,6 +210,7 @@ static void sel_netif_flush(void)
 {
 	int idx;
 
+	rcu_read_lock();
 	spin_lock_bh(&sel_netif_lock);
 	for (idx = 0; idx < SEL_NETIF_HASH_SIZE; idx++) {
 		struct sel_netif *netif;
@@ -218,6 +219,7 @@ static void sel_netif_flush(void)
 			sel_netif_destroy(netif);
 	}
 	spin_unlock_bh(&sel_netif_lock);
+	rcu_read_unlock();
 }
 
 static int sel_netif_avc_callback(u32 event, u32 ssid, u32 tsid,
