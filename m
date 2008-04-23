Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYDWEMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYDWEMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 00:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbYDWEMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 00:12:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:56279 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbYDWEMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 00:12:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [stable PATCH for 2.6.24.5 and 2.6.25] pnpacpi: fix potential corruption on "pnpacpi: exceeded the max number of IRQ resources 2"
Date: Wed, 23 Apr 2008 00:09:13 -0400
User-Agent: KMail/1.9.9
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Linux-acpi@vger.kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20080417010122.148289106@sous-sol.org> <20080417010359.629397865@sous-sol.org> <200804181548.33872.bjorn.helgaas@hp.com>
In-Reply-To: <200804181548.33872.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804230009.15258.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

PNP_MAX_IRQ is 2
If a device invokes pnpacpi_parse_allocated_irqresource() 0, 1, or 2 times, we are happy.
The 3rd time, we will fail and print "pnpacpi: exceeded the max number of IRQ resources: 2"
The 4th and subsequent calls (if this ever happened) would silently scribble on
irq_resource[2], which doesn't actualy exist.

Found-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 2dcd196..98cbc9f 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -84,10 +84,12 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_IRQ)
 		i++;
-	if (i >= PNP_MAX_IRQ && !warned) {
-		printk(KERN_WARNING "pnpacpi: exceeded the max number of IRQ "
-				"resources: %d \n", PNP_MAX_IRQ);
-		warned = 1;
+	if (i >= PNP_MAX_IRQ) {
+		if (!warned) {
+			printk(KERN_WARNING "pnpacpi: exceeded the max number"
+				" of IRQ resources: %d\n", PNP_MAX_IRQ);
+			warned = 1;
+		}
 		return;
 	}
 	/*
