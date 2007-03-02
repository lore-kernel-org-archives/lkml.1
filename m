Return-Path: <linux-kernel-owner+w=401wt.eu-S2992499AbXCBO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992499AbXCBO52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992501AbXCBO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:57:28 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:44631 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992499AbXCBO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:57:27 -0500
Date: Fri, 2 Mar 2007 14:57:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Message-ID: <20070302145709.GA3710@srcf.ucam.org>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302150313.198b6053.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302150313.198b6053.khali@linux-fr.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about this? It's informational only, but ought to result in 
complaints whenever ACPI tries to touch something that other hardware 
has reserved. We can't fail these accesses, but in theory we could 
consider some sort of locking layer that made it possible to interact 
anyway. I haven't even checked if this builds, but I think the concept 
is reasonable.

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index d870fb2..088abd1 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -35,6 +35,7 @@
 #include <linux/kmod.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
+#include <linux/ioport.h>
 #include <linux/nmi.h>
 #include <acpi/acpi.h>
 #include <asm/io.h>
@@ -338,6 +339,10 @@ acpi_status acpi_os_read_port(acpi_io_address port, u32 * value, u32 width)
 {
 	u32 dummy;
 
+	if (__check_region(&ioport_resource, port, width/8))
+		printk (KERN_INFO "ACPI read from allocated ioport %lx\n", 
+			port);
+
 	if (!value)
 		value = &dummy;
 
@@ -362,6 +367,10 @@ EXPORT_SYMBOL(acpi_os_read_port);
 
 acpi_status acpi_os_write_port(acpi_io_address port, u32 value, u32 width)
 {
+	if (__check_region(&ioport_resource, port, width/8))
+		printk (KERN_INFO "ACPI write to allocated ioport %lx\n", 
+			port);
+
 	switch (width) {
 	case 8:
 		outb(value, port);
@@ -387,6 +396,10 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u32 * value, u32 width)
 	u32 dummy;
 	void __iomem *virt_addr;
 
+	if (__check_region(&iomem_resource, phys_addr, width/8))
+		printk (KERN_INFO "ACPI read from allocated iomem %lx\n", 
+			phys_addr);
+
 	virt_addr = ioremap(phys_addr, width);
 	if (!value)
 		value = &dummy;
@@ -415,6 +428,10 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u32 value, u32 width)
 {
 	void __iomem *virt_addr;
 
+	if (__check_region(&iomem_resource, phys_addr, width/8))
+		printk (KERN_INFO "ACPI write to allocated iomem %lx\n", 
+			phys_addr);
+
 	virt_addr = ioremap(phys_addr, width);
 
 	switch (width) {

-- 
Matthew Garrett | mjg59@srcf.ucam.org
