Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZHZVD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZHZVD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZHZVD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:03:56 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:39429 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753702AbZHZVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:03:56 -0400
Date: Wed, 26 Aug 2009 14:45:32 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: core remove completion-wait for complete with
 rcu_barrier
Message-ID: <4a959eec.ILZAXmwdAGY2H5to%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <hawk@comx.dk>

Module edac_core.ko uses call_rcu() callbacks in edac_device.c, edac_mc.c
and edac_pci.c.

They all uses a wait_for_completion scheme, but this scheme it not 100%
safe on multiple CPUs.  See the _rcu_barrier() implementation which explains
why extra precausion is needed.

The patch adds a comment about rcu_barrier() and as a precausion calls
rcu_barrier().  A maintainer needs to look at removing the wait_for_completion
code.


Maintainer Doug Thompson removed the wait_for_completion code

Signed-off-by Jesper Dangaard Brouer" <hawk@comx.dk>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

Index: linux-2.6.31-rc7/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.31-rc7.orig/drivers/edac/edac_device.c	2009-08-21 19:00:46.000000000 -0600
+++ linux-2.6.31-rc7/drivers/edac/edac_device.c	2009-08-26 14:39:00.000000000 -0600
@@ -356,7 +356,6 @@ static void complete_edac_device_list_de
 
 	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
 	INIT_LIST_HEAD(&edac_dev->link);
-	complete(&edac_dev->removal_complete);
 }
 
 /*
@@ -369,10 +368,8 @@ static void del_edac_device_from_global_
 						*edac_device)
 {
 	list_del_rcu(&edac_device->link);
-
-	init_completion(&edac_device->removal_complete);
 	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
-	wait_for_completion(&edac_device->removal_complete);
+	rcu_barrier();
 }
 
 /*
Index: linux-2.6.31-rc7/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.31-rc7.orig/drivers/edac/edac_mc.c	2009-08-21 19:00:46.000000000 -0600
+++ linux-2.6.31-rc7/drivers/edac/edac_mc.c	2009-08-26 14:35:35.000000000 -0600
@@ -418,16 +418,14 @@ static void complete_mc_list_del(struct
 
 	mci = container_of(head, struct mem_ctl_info, rcu);
 	INIT_LIST_HEAD(&mci->link);
-	complete(&mci->complete);
 }
 
 static void del_mc_from_global_list(struct mem_ctl_info *mci)
 {
 	atomic_dec(&edac_handlers);
 	list_del_rcu(&mci->link);
-	init_completion(&mci->complete);
 	call_rcu(&mci->rcu, complete_mc_list_del);
-	wait_for_completion(&mci->complete);
+	rcu_barrier();
 }
 
 /**
Index: linux-2.6.31-rc7/drivers/edac/edac_pci.c
===================================================================
--- linux-2.6.31-rc7.orig/drivers/edac/edac_pci.c	2009-08-21 19:00:46.000000000 -0600
+++ linux-2.6.31-rc7/drivers/edac/edac_pci.c	2009-08-26 14:36:31.000000000 -0600
@@ -174,7 +174,6 @@ static void complete_edac_pci_list_del(s
 
 	pci = container_of(head, struct edac_pci_ctl_info, rcu);
 	INIT_LIST_HEAD(&pci->link);
-	complete(&pci->complete);
 }
 
 /*
@@ -185,9 +184,8 @@ static void complete_edac_pci_list_del(s
 static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
 {
 	list_del_rcu(&pci->link);
-	init_completion(&pci->complete);
 	call_rcu(&pci->rcu, complete_edac_pci_list_del);
-	wait_for_completion(&pci->complete);
+	rcu_barrier();
 }
 
 #if 0
