Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYAAVDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYAAVDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYAAVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:03:37 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:38490 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYAAVDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:03:35 -0500
Date: Tue, 1 Jan 2008 22:02:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: paulus@au.ibm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] arch/powerpc/platforms/pseries: Add missing of_node_put
Message-ID: <Pine.LNX.4.64.0801012202040.19803@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Of_get_parent and of_find_compatible_node do an of_node_get, and thus a
corresponding of_code_put is needed in the error case.


The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = \(of_get_parent\|of_find_compatible_node\)(...);
  if (E == NULL) S
  ... when != of_node_put(...,(T1)E,...)
      when != if (E != NULL) { ... of_node_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != of_node_put(...,(T2)E,...)
        when != if (E != NULL) { ... of_node_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c	2007-07-20 17:45:44.000000000 +0200
+++ b/arch/powerpc/platforms/pseries/reconfig.c	2008-01-01 14:33:54.000000000 +0100
@@ -167,6 +167,7 @@ static int pSeries_reconfig_remove_node(
 
 	if ((child = of_get_next_child(np, NULL))) {
 		of_node_put(child);
+		of_node_put(parent);
 		return -EBUSY;
 	}
 
