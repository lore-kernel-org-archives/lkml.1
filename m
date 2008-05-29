Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYE2NFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYE2NFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYE2NEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:04:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51574 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbYE2NEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:04:53 -0400
Date: Thu, 29 May 2008 15:04:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] Eliminate double kfree
Message-ID: <Pine.LNX.4.64.0805291504030.26229@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The destination of goto error also does a kfree(g_iommus), so it is not
correct to do one here.

This was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r1@
expression E;
position p1,p2;
@@

kfree@p1(E);
...
kfree@p2(E);

@subexps@
expression E1;
position r1.p1,p;
@@

kfree@p1(<+... E1@p ...+>);

@recollect@
position subexps.p;
expression E1;
@@

E1@p

@doublekfree@
position r1.p1,r1.p2;
expression recollect.E1,E2,E;
position p;
statement S;
@@

kfree@p1(E);
<+... E1@p=E2 ...+> // the actual semantic match contains other assignments
kfree@p2(E);

@notdoublekfree@
position r1.p1,r1.p2;
position any doublekfree.p;
expression E,E1,E2;
@@

* kfree@p1(E);
... when != E1@p
    when != E1@p = E2 // needed to match a variable decl
* kfree@p2(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c	2008-05-15 18:11:35.000000000 +0200
+++ b/drivers/pci/intel-iommu.c	2008-05-24 21:20:24.000000000 +0200
@@ -1725,7 +1725,6 @@ int __init init_dmars(void)
 	deferred_flush = kzalloc(g_num_of_iommus *
 		sizeof(struct deferred_flush_tables), GFP_KERNEL);
 	if (!deferred_flush) {
-		kfree(g_iommus);
 		ret = -ENOMEM;
 		goto error;
 	}
