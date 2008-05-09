Return-Path: <linux-kernel-owner+w=401wt.eu-S935066AbYEIBWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbYEIBWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYEIBWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:22:31 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:50662 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbYEIBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:22:30 -0400
Date: Thu, 08 May 2008 20:22:10 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH] IPMI: Support I/O resources in OF driver
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nate Case <ncase@xes-inc.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080509012210.GA7305@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nate Case <ncase@xes-inc.com>

The current OF probing assumes that the resource is IORESOURCE_MEM.
This checks for the IORESOURCE_IO flag and behaves appropriately.
An I/O resource can exist with an ipmi device node on a legacy ISA bus.

Signed-off-by: Nate Case <ncase@xes-inc.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Seems reasonable to me, though I have no way to test this. -corey

Index: linux-2.6.25/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.25.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.25/drivers/char/ipmi/ipmi_si_intf.c
@@ -2353,10 +2353,16 @@ static int __devinit ipmi_of_probe(struc
 
 	info->si_type		= (enum si_type) match->data;
 	info->addr_source	= "device-tree";
-	info->io_setup		= mem_setup;
 	info->irq_setup		= std_irq_setup;
 
-	info->io.addr_type	= IPMI_MEM_ADDR_SPACE;
+	if (resource.flags & IORESOURCE_IO) {
+		info->io_setup		= port_setup;
+		info->io.addr_type	= IPMI_IO_ADDR_SPACE;
+	} else {
+		info->io_setup		= mem_setup;
+		info->io.addr_type	= IPMI_MEM_ADDR_SPACE;
+	}
+
 	info->io.addr_data	= resource.start;
 
 	info->io.regsize	= regsize ? *regsize : DEFAULT_REGSIZE;
