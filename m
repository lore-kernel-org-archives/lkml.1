Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYLBNtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYLBNtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYLBNtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:49:32 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:36168 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYLBNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:49:31 -0500
From: Nicolas Palix <npalix@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       dougthompson@xmission.com
Subject: [PATCH linux-next] drivers/edac/cell_edac.c: Add missing of_node_put
Date: Tue, 2 Dec 2008 14:49:28 +0100
User-Agent: KMail/1.9.10
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Nicolas Palix <npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021449.29385.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code or when the device
node is no longer used.

The semantic match that catches the bug is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression struct device_node *n;
position p1, p2;
statement S1,S2;
expression E,E1;
expression *ptr != NULL;
@@

(
if (!(n@p1 = of_find_node_by_name(...))) S1
|
n@p1 = of_find_node_by_name(...)
)
<... when != of_node_put(n)
    when != if (...) { <+... of_node_put(n) ...+> }
    when != true !n  || ...
    when != n = E
    when != E = n
if (!n || ...) S2
...>
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
n = E1
|
E1 = n
)
@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/edac/cell_edac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index cd2e3b8..cbc448b 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -139,6 +139,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 			continue;
 		if (of_node_to_nid(np) != priv->node)
 			continue;
+		of_node_put(np);
 		csrow->first_page = r.start >> PAGE_SHIFT;
 		csrow->nr_pages = (r.end - r.start + 1) >> PAGE_SHIFT;
 		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
-- 
Nicolas Palix
