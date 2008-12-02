Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYLBNjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYLBNjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYLBNjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:39:00 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:60883 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYLBNi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:38:59 -0500
From: Nicolas Palix <npalix@diku.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH linux-next] drivers/hvc: Add missing of_node_put
Date: Tue, 2 Dec 2008 14:38:55 +0100
User-Agent: KMail/1.9.10
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Nicolas Palix <npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021438.56071.npalix@diku.dk>
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
 drivers/char/hvc_iseries.c |    4 +++-
 drivers/char/hvc_vio.c     |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hvc_iseries.c b/drivers/char/hvc_iseries.c
index b74a2f8..449727b 100644
--- a/drivers/char/hvc_iseries.c
+++ b/drivers/char/hvc_iseries.c
@@ -575,8 +575,10 @@ static int __init hvc_find_vtys(void)
 		 * of console adapters.
 		 */
 		if ((num_found >= MAX_NR_HVC_CONSOLES) ||
-				(num_found >= VTTY_PORTS))
+				(num_found >= VTTY_PORTS)) {
+			of_node_put(vty);
 			break;
+		}
 
 		vtermno = of_get_property(vty, "reg", NULL);
 		if (!vtermno)
diff --git a/drivers/char/hvc_vio.c b/drivers/char/hvc_vio.c
index 019e0b5..bd62dc8 100644
--- a/drivers/char/hvc_vio.c
+++ b/drivers/char/hvc_vio.c
@@ -153,8 +153,10 @@ static int hvc_find_vtys(void)
 		/* We have statically defined space for only a certain number
 		 * of console adapters.
 		 */
-		if (num_found >= MAX_NR_HVC_CONSOLES)
+		if (num_found >= MAX_NR_HVC_CONSOLES) {
+			of_node_put(vty);
 			break;
+		}
 
 		vtermno = of_get_property(vty, "reg", NULL);
 		if (!vtermno)
-- 
Nicolas Palix
