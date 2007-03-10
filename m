Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXCJGV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXCJGV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXCJGVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:21:22 -0500
Received: from ns1.suse.de ([195.135.220.2]:41114 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXCJGU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:20:29 -0500
Date: Fri, 9 Mar 2007 22:18:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/20] Fix sparc64 device register probing
Message-ID: <20070310061849.GS31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc64-device-register-probing.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

[SPARC]: Fix bus handling in build_device_resources().

We mistakedly modify 'bus' in the innermost loop.  What
should happen is that at each register index iteration,
we start with the same 'bus'.

So preserve it's value at the top level, and use a loop
local variable 'dbus' for iteration.

This bug causes registers other than the first to be
decoded improperly.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/of_device.c   |    7 ++++---
 arch/sparc64/kernel/of_device.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/sparc/kernel/of_device.c
+++ b/arch/sparc/kernel/of_device.c
@@ -495,7 +495,7 @@ static void __init build_device_resource
 		u32 *reg = (preg + (index * ((na + ns) * 4)));
 		struct device_node *dp = op->node;
 		struct device_node *pp = p_op->node;
-		struct of_bus *pbus;
+		struct of_bus *pbus, *dbus;
 		u64 size, result = OF_BAD_ADDR;
 		unsigned long flags;
 		int dna, dns;
@@ -516,6 +516,7 @@ static void __init build_device_resource
 
 		dna = na;
 		dns = ns;
+		dbus = bus;
 
 		while (1) {
 			dp = pp;
@@ -528,13 +529,13 @@ static void __init build_device_resource
 			pbus = of_match_bus(pp);
 			pbus->count_cells(dp, &pna, &pns);
 
-			if (build_one_resource(dp, bus, pbus, addr,
+			if (build_one_resource(dp, dbus, pbus, addr,
 					       dna, dns, pna))
 				break;
 
 			dna = pna;
 			dns = pns;
-			bus = pbus;
+			dbus = pbus;
 		}
 
 	build_res:
--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -581,7 +581,7 @@ static void __init build_device_resource
 		u32 *reg = (preg + (index * ((na + ns) * 4)));
 		struct device_node *dp = op->node;
 		struct device_node *pp = p_op->node;
-		struct of_bus *pbus;
+		struct of_bus *pbus, *dbus;
 		u64 size, result = OF_BAD_ADDR;
 		unsigned long flags;
 		int dna, dns;
@@ -599,6 +599,7 @@ static void __init build_device_resource
 
 		dna = na;
 		dns = ns;
+		dbus = bus;
 
 		while (1) {
 			dp = pp;
@@ -611,13 +612,13 @@ static void __init build_device_resource
 			pbus = of_match_bus(pp);
 			pbus->count_cells(dp, &pna, &pns);
 
-			if (build_one_resource(dp, bus, pbus, addr,
+			if (build_one_resource(dp, dbus, pbus, addr,
 					       dna, dns, pna))
 				break;
 
 			dna = pna;
 			dns = pns;
-			bus = pbus;
+			dbus = pbus;
 		}
 
 	build_res:

-- 
