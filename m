Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYLPPMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYLPPMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbYLPPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:12:21 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59674 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbYLPPMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:12:19 -0500
Date: Tue, 16 Dec 2008 16:12:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/11] drivers/infiniband: Move a dereference below a NULL
 test
Message-ID: <Pine.LNX.4.64.0812161611540.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/nes/nes_cm.c  |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 2caf9da..2194ee2 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -376,13 +376,14 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		int close_when_complete)
 {
 	unsigned long  flags;
-	struct nes_cm_core *cm_core = cm_node->cm_core;
+	struct nes_cm_core *cm_core;
 	struct nes_timer_entry *new_send;
 	int ret = 0;
 	u32 was_timer_set;
 
 	if (!cm_node)
 		return -EINVAL;
+	cm_core = cm_node->cm_core;
 	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
 	if (!new_send)
 		return -1;
