Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0BSR7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:59:23 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:31351 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0BSR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:59:18 -0500
Subject: [PATCH v1 6/7] PNPACPI: add window support
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:48 -0700
Message-ID: <20100219175848.9199.19126.stgit@bob.kio>
In-Reply-To: <20100219175655.9199.30691.stgit@bob.kio>
References: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for resource windows.  This is for bridge resources, i.e.,
regions where a bridge forwards transactions from the primary to the
secondary side.  This does not add support for *setting* windows via
the /proc interface.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/interface.c        |    6 ++++--
 drivers/pnp/pnpacpi/rsparser.c |   35 ++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 17 deletions(-)


diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index 68b0c04..ba437b7 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -278,9 +278,11 @@ static ssize_t pnp_show_current_resources(struct device *dmdev,
 		switch (pnp_resource_type(res)) {
 		case IORESOURCE_IO:
 		case IORESOURCE_MEM:
-			pnp_printf(buffer, " %#llx-%#llx\n",
+			pnp_printf(buffer, " %#llx-%#llx%s\n",
 				   (unsigned long long) res->start,
-				   (unsigned long long) res->end);
+				   (unsigned long long) res->end,
+				   res->flags & IORESOURCE_WINDOW ?
+					" window" : "");
 			break;
 		case IORESOURCE_IRQ:
 		case IORESOURCE_DMA:
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 5702b2c..0d7d61d 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -177,7 +177,8 @@ static int dma_flags(struct pnp_dev *dev, int type, int bus_master,
 }
 
 static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev, u64 start,
-					       u64 len, int io_decode)
+					       u64 len, int io_decode,
+					       int window)
 {
 	int flags = 0;
 	u64 end = start + len - 1;
@@ -186,6 +187,8 @@ static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev, u64 start,
 		flags |= IORESOURCE_IO_16BIT_ADDR;
 	if (len == 0 || end >= 0x10003)
 		flags |= IORESOURCE_DISABLED;
+	if (window)
+		flags |= IORESOURCE_WINDOW;
 
 	pnp_add_io_resource(dev, start, end, flags);
 }
@@ -247,7 +250,7 @@ static void pnpacpi_parse_allocated_vendor(struct pnp_dev *dev,
 
 static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
 						u64 start, u64 len,
-						int write_protect)
+						int write_protect, int window)
 {
 	int flags = 0;
 	u64 end = start + len - 1;
@@ -256,6 +259,8 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
 		flags |= IORESOURCE_DISABLED;
 	if (write_protect == ACPI_READ_WRITE_MEMORY)
 		flags |= IORESOURCE_MEM_WRITEABLE;
+	if (window)
+		flags |= IORESOURCE_WINDOW;
 
 	pnp_add_mem_resource(dev, start, end, flags);
 }
@@ -265,6 +270,7 @@ static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
+	int window;
 
 	status = acpi_resource_to_address64(res, p);
 	if (!ACPI_SUCCESS(status)) {
@@ -273,37 +279,36 @@ static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
 		return;
 	}
 
-	if (p->producer_consumer == ACPI_PRODUCER)
-		return;
+	window = (p->producer_consumer == ACPI_PRODUCER) ? 1 : 0;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
 		pnpacpi_parse_allocated_memresource(dev,
 			p->minimum, p->address_length,
-			p->info.mem.write_protect);
+			p->info.mem.write_protect, window);
 	else if (p->resource_type == ACPI_IO_RANGE)
 		pnpacpi_parse_allocated_ioresource(dev,
 			p->minimum, p->address_length,
 			p->granularity == 0xfff ? ACPI_DECODE_10 :
-				ACPI_DECODE_16);
+				ACPI_DECODE_16, window);
 }
 
 static void pnpacpi_parse_allocated_ext_address_space(struct pnp_dev *dev,
 						      struct acpi_resource *res)
 {
 	struct acpi_resource_extended_address64 *p = &res->data.ext_address64;
+	int window;
 
-	if (p->producer_consumer == ACPI_PRODUCER)
-		return;
+	window = (p->producer_consumer == ACPI_PRODUCER) ? 1 : 0;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
 		pnpacpi_parse_allocated_memresource(dev,
 			p->minimum, p->address_length,
-			p->info.mem.write_protect);
+			p->info.mem.write_protect, window);
 	else if (p->resource_type == ACPI_IO_RANGE)
 		pnpacpi_parse_allocated_ioresource(dev,
 			p->minimum, p->address_length,
 			p->granularity == 0xfff ? ACPI_DECODE_10 :
-				ACPI_DECODE_16);
+				ACPI_DECODE_16, window);
 }
 
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
@@ -368,7 +373,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 		pnpacpi_parse_allocated_ioresource(dev,
 			io->minimum,
 			io->address_length,
-			io->io_decode);
+			io->io_decode, 0);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -380,7 +385,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 		pnpacpi_parse_allocated_ioresource(dev,
 			fixed_io->address,
 			fixed_io->address_length,
-			ACPI_DECODE_10);
+			ACPI_DECODE_10, 0);
 		break;
 
 	case ACPI_RESOURCE_TYPE_VENDOR:
@@ -396,21 +401,21 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 		pnpacpi_parse_allocated_memresource(dev,
 			memory24->minimum,
 			memory24->address_length,
-			memory24->write_protect);
+			memory24->write_protect, 0);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		memory32 = &res->data.memory32;
 		pnpacpi_parse_allocated_memresource(dev,
 			memory32->minimum,
 			memory32->address_length,
-			memory32->write_protect);
+			memory32->write_protect, 0);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		fixed_memory32 = &res->data.fixed_memory32;
 		pnpacpi_parse_allocated_memresource(dev,
 			fixed_memory32->address,
 			fixed_memory32->address_length,
-			fixed_memory32->write_protect);
+			fixed_memory32->write_protect, 0);
 		break;
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:

