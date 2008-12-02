Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYLBNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYLBNpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYLBNpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:45:21 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55170 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYLBNpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:45:20 -0500
From: Nicolas Palix <npalix@diku.dk>
To: paulus@samba.org, benh@kernel.crashing.org
Subject: [PATCH linux-next] powerpc/powermac: Add missing of_node_put
Date: Tue, 2 Dec 2008 14:45:18 +0100
User-Agent: KMail/1.9.10
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Nicolas Palix <npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021445.18670.npalix@diku.dk>
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
struct device_node *n1;
statement S;
identifier f;
expression E;
expression *ptr != NULL;
@@

n@p1 = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
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
 arch/powerpc/platforms/powermac/pci.c     |    2 ++
 arch/powerpc/platforms/powermac/time.c    |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index bcf50d7..800fcce 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -661,6 +661,7 @@ static void __init init_second_ohare(void)
 			pci_find_hose_for_OF_device(np);
 		if (!hose) {
 			printk(KERN_ERR "Can't find PCI hose for OHare2 !\n");
+			of_node_put(np);
 			return;
 		}
 		early_read_config_word(hose, bus, devfn, PCI_COMMAND, &cmd);
@@ -669,6 +670,7 @@ static void __init init_second_ohare(void)
 		early_write_config_word(hose, bus, devfn, PCI_COMMAND, cmd);
 	}
 	has_second_ohare = 1;
+	of_node_put(np);
 }
 
 /*
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 59eb840..394593c 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -265,12 +265,14 @@ int __init via_calibrate_decr(void)
 	struct resource rsrc;
 
 	vias = of_find_node_by_name(NULL, "via-cuda");
 	if (vias == 0)
 		vias = of_find_node_by_name(NULL, "via-pmu");
 	if (vias == 0)
 		vias = of_find_node_by_name(NULL, "via");
 	if (vias == 0 || of_address_to_resource(vias, 0, &rsrc))
 		return 0;
+	of_node_put(vias);
+
 	via = ioremap(rsrc.start, rsrc.end - rsrc.start + 1);
 	if (via == NULL) {
 		printk(KERN_ERR "Failed to map VIA for timer calibration !\n");
@@ -297,7 +299,7 @@ int __init via_calibrate_decr(void)
 	ppc_tb_freq = (dstart - dend) * 100 / 6;
 
 	iounmap(via);
-	
+
 	return 1;
 }
 #endif
-- 
Nicolas Palix
