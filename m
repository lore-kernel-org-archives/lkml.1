Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZG0QTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZG0QTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZG0QTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:19:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44406 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZG0QTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:19:10 -0400
Date: Mon, 27 Jul 2009 18:15:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: paul.moore@hp.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 11/12] net/netlabel: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271815260.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

entry was tested for NULL near the beginning of the function, followed by a
return, and there is no intervening modification of its value.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/netlabel/netlabel_kapi.c        |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index b0e582f..3ff6f32 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -185,8 +185,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
 	return 0;
 
 cfg_unlbl_map_add_failure:
-	if (entry != NULL)
-		kfree(entry->domain);
+	kfree(entry->domain);
 	kfree(entry);
 	kfree(addrmap);
 	kfree(map4);
@@ -385,8 +384,7 @@ int netlbl_cfg_cipsov4_map_add(u32 doi,
 
 cfg_cipsov4_map_add_failure:
 	cipso_v4_doi_putdef(doi_def);
-	if (entry != NULL)
-		kfree(entry->domain);
+	kfree(entry->domain);
 	kfree(entry);
 	kfree(addrmap);
 	kfree(addrinfo);
