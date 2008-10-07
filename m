Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYJGBDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYJGBDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbYJGAqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:21 -0400
Received: from mail.suse.de ([195.135.220.2]:47254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175AbYJGAqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:19 -0400
Date: Mon, 6 Oct 2008 17:40:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 63/71] sparc64: Fix disappearing PCI devices on e3500.
Message-ID: <20081007004013.GL3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0004-sparc64-Fix-disappearing-PCI-devices-on-e3500.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 7ee766d8fba9dfd93bf3eca7a8d84a25404a68dc ]

Based upon a bug report by Meelis Roos.

The OF device layer builds properties by matching bus types and
applying 'range' properties as appropriate, up to the root.

The match for "PCI" busses is looking at the 'device_type' property,
and this does work %99 of the time.

But on an E3500 system with a PCI QFE card, the DEC 21153 bridge
sitting above the QFE network interface devices has a 'name' of "pci",
but it completely lacks a 'device_type' property.  So we don't match
it as a PCI bus, and subsequently we end up with no resource values at
all for the devices sitting under that DEC bridge.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/of_device.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -170,7 +170,7 @@ static unsigned int of_bus_default_get_f
 
 static int of_bus_pci_match(struct device_node *np)
 {
-	if (!strcmp(np->type, "pci") || !strcmp(np->type, "pciex")) {
+	if (!strcmp(np->name, "pci")) {
 		const char *model = of_get_property(np, "model", NULL);
 
 		if (model && !strcmp(model, "SUNW,simba"))
@@ -201,7 +201,7 @@ static int of_bus_simba_match(struct dev
 	/* Treat PCI busses lacking ranges property just like
 	 * simba.
 	 */
-	if (!strcmp(np->type, "pci") || !strcmp(np->type, "pciex")) {
+	if (!strcmp(np->name, "pci")) {
 		if (!of_find_property(np, "ranges", NULL))
 			return 1;
 	}
@@ -426,7 +426,7 @@ static int __init use_1to1_mapping(struc
 	 * it lacks a ranges property, and this will include
 	 * cases like Simba.
 	 */
-	if (!strcmp(pp->type, "pci") || !strcmp(pp->type, "pciex"))
+	if (!strcmp(pp->name, "pci"))
 		return 0;
 
 	return 1;
@@ -709,8 +709,7 @@ static unsigned int __init build_one_dev
 				break;
 			}
 		} else {
-			if (!strcmp(pp->type, "pci") ||
-			    !strcmp(pp->type, "pciex")) {
+			if (!strcmp(pp->name, "pci")) {
 				unsigned int this_orig_irq = irq;
 
 				irq = pci_irq_swizzle(dp, pp, irq);

-- 
