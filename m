Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZLRThh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZLRThh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZLRTgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:36 -0500
Received: from kroah.org ([198.145.64.141]:47450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZLRTgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:32 -0500
Subject: patch staging-slicoss-use-compare_ether_addr.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:53 -0800
In-Reply-To: <20091218080019.GA4531@coldcone>
Message-ID: <1261164833943@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss Use compare_ether_addr.

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-use-compare_ether_addr.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:34:17 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 11:00:19 +0300
Subject: staging: slicoss Use compare_ether_addr.
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218080019.GA4531@coldcone>
Content-Disposition: inline


Use compare_ether_addr.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/slicoss/slic.h    |    9 ---------
 drivers/staging/slicoss/slicoss.c |   11 +++--------
 2 files changed, 3 insertions(+), 17 deletions(-)

--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -527,15 +527,6 @@ struct adapter {
     (largestat) += ((newstat) - (oldstat));                              \
 }
 
-#define ETHER_EQ_ADDR(_AddrA, _AddrB, _Result)                           \
-{                                                                        \
-    _Result = true;                                                      \
-    if (*(u32 *)(_AddrA) != *(u32 *)(_AddrB))                          \
-	_Result = false;                                                 \
-    if (*(u16 *)(&((_AddrA)[4])) != *(u16 *)(&((_AddrB)[4])))        \
-	_Result = false;                                                 \
-}
-
 #if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
 #define   SLIC_GET_ADDR_LOW(_addr)  (u32)((u64)(_addr) & \
 	0x00000000FFFFFFFF)
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1249,13 +1249,11 @@ static struct net_device_stats *slic_get
 static int slic_mcast_add_list(struct adapter *adapter, char *address)
 {
 	struct mcast_address *mcaddr, *mlist;
-	bool equaladdr;
 
 	/* Check to see if it already exists */
 	mlist = adapter->mcastaddrs;
 	while (mlist) {
-		ETHER_EQ_ADDR(mlist->address, address, equaladdr);
-		if (equaladdr)
+		if (!compare_ether_addr(mlist->address, address))
 			return STATUS_SUCCESS;
 		mlist = mlist->next;
 	}
@@ -2469,7 +2467,6 @@ static bool slic_mac_filter(struct adapt
 	u32 opts = adapter->macopts;
 	u32 *dhost4 = (u32 *)&ether_frame->ether_dhost[0];
 	u16 *dhost2 = (u16 *)&ether_frame->ether_dhost[4];
-	bool equaladdr;
 
 	if (opts & MAC_PROMISC)
 		return true;
@@ -2493,10 +2490,8 @@ static bool slic_mac_filter(struct adapt
 			struct mcast_address *mcaddr = adapter->mcastaddrs;
 
 			while (mcaddr) {
-				ETHER_EQ_ADDR(mcaddr->address,
-					      ether_frame->ether_dhost,
-					      equaladdr);
-				if (equaladdr) {
+				if (!compare_ether_addr(mcaddr->address,
+							ether_frame->ether_dhost)) {
 					adapter->rcv_multicasts++;
 					adapter->stats.multicast++;
 					return true;

