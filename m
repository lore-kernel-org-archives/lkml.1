Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYLBNq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYLBNq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbYLBNqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:46:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:53983 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbYLBNqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:46:47 -0500
From: Nicolas Palix <npalix@diku.dk>
To: Paul Mackerras <paulus@au.ibm.com>
Subject: [PATCH linux-next] powerpc/pseries: Add missing of_node_put in setup.c
Date: Tue, 2 Dec 2008 14:46:45 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Nicolas Palix <npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021446.46078.npalix@diku.dk>
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
 arch/powerpc/platforms/pseries/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index ec34170..bbda776 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -237,7 +237,7 @@ static void __init pseries_discover_pic(void)
 						   "interrupt-controller"));) {
 		typep = of_get_property(np, "compatible", NULL);
 		if (strstr(typep, "open-pic")) {
-			pSeries_mpic_node = of_node_get(np);
+			pSeries_mpic_node     = np;
 			ppc_md.init_IRQ       = pseries_mpic_init_IRQ;
 			ppc_md.get_irq        = mpic_get_irq;
 			setup_kexec_cpu_down_mpic();
@@ -247,6 +247,7 @@ static void __init pseries_discover_pic(void)
 			ppc_md.init_IRQ       = pseries_xics_init_IRQ;
 			setup_kexec_cpu_down_xics();
 			smp_init_pseries_xics();
+			of_node_put(np);
 			return;
 		}
 	}
-- 
Nicolas Palix
