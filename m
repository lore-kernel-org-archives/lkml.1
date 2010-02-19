Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0BSR7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:59:00 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:43084 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab0BSR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:58:55 -0500
Subject: [PATCH v1 7/7] PNPACPI: add bus number support
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:53 -0700
Message-ID: <20100219175853.9199.94744.stgit@bob.kio>
In-Reply-To: <20100219175655.9199.30691.stgit@bob.kio>
References: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for bus number resources.  This is for bridges with a range of
bus numbers behind them.  Previously, PNP ignored bus number resources.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/base.h             |    3 +++
 drivers/pnp/interface.c        |    1 +
 drivers/pnp/pnpacpi/rsparser.c |   14 ++++++++++++++
 drivers/pnp/resource.c         |   27 ++++++++++++++++++++++++++-
 drivers/pnp/support.c          |    4 +++-
 5 files changed, 47 insertions(+), 2 deletions(-)


diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 0b8d140..0bab84e 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -166,6 +166,9 @@ struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 					  resource_size_t start,
 					  resource_size_t end, int flags);
+struct pnp_resource *pnp_add_bus_resource(struct pnp_dev *dev,
+					  resource_size_t start,
+					  resource_size_t end);
 
 extern int pnp_debug;
 
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index ba437b7..cfaf5b7 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -278,6 +278,7 @@ static ssize_t pnp_show_current_resources(struct device *dmdev,
 		switch (pnp_resource_type(res)) {
 		case IORESOURCE_IO:
 		case IORESOURCE_MEM:
+		case IORESOURCE_BUS:
 			pnp_printf(buffer, " %#llx-%#llx%s\n",
 				   (unsigned long long) res->start,
 				   (unsigned long long) res->end,
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 0d7d61d..54514aa 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -265,6 +265,14 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
 	pnp_add_mem_resource(dev, start, end, flags);
 }
 
+static void pnpacpi_parse_allocated_busresource(struct pnp_dev *dev,
+						u64 start, u64 len)
+{
+	u64 end = start + len - 1;
+
+	pnp_add_bus_resource(dev, start, end);
+}
+
 static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
 						  struct acpi_resource *res)
 {
@@ -290,6 +298,9 @@ static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
 			p->minimum, p->address_length,
 			p->granularity == 0xfff ? ACPI_DECODE_10 :
 				ACPI_DECODE_16, window);
+	else if (p->resource_type == ACPI_BUS_NUMBER_RANGE)
+		pnpacpi_parse_allocated_busresource(dev, p->minimum,
+						    p->address_length);
 }
 
 static void pnpacpi_parse_allocated_ext_address_space(struct pnp_dev *dev,
@@ -309,6 +320,9 @@ static void pnpacpi_parse_allocated_ext_address_space(struct pnp_dev *dev,
 			p->minimum, p->address_length,
 			p->granularity == 0xfff ? ACPI_DECODE_10 :
 				ACPI_DECODE_16, window);
+	else if (p->resource_type == ACPI_BUS_NUMBER_RANGE)
+		pnpacpi_parse_allocated_busresource(dev, p->minimum,
+						    p->address_length);
 }
 
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 64d0596..5b277db 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -470,7 +470,8 @@ int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 unsigned long pnp_resource_type(struct resource *res)
 {
 	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
-			     IORESOURCE_IRQ | IORESOURCE_DMA);
+			     IORESOURCE_IRQ | IORESOURCE_DMA |
+			     IORESOURCE_BUS);
 }
 
 struct resource *pnp_get_resource(struct pnp_dev *dev,
@@ -590,6 +591,30 @@ struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 	return pnp_res;
 }
 
+struct pnp_resource *pnp_add_bus_resource(struct pnp_dev *dev,
+					  resource_size_t start,
+					  resource_size_t end)
+{
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+
+	pnp_res = pnp_new_resource(dev);
+	if (!pnp_res) {
+		dev_err(&dev->dev, "can't add resource for BUS %#llx-%#llx\n",
+			(unsigned long long) start,
+			(unsigned long long) end);
+		return NULL;
+	}
+
+	res = &pnp_res->res;
+	res->flags = IORESOURCE_BUS;
+	res->start = start;
+	res->end = end;
+
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
+	return pnp_res;
+}
+
 /*
  * Determine whether the specified resource is a possible configuration
  * for this device.
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 9585c1c..f5beb24 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -69,8 +69,10 @@ char *pnp_resource_type_name(struct resource *res)
 		return "irq";
 	case IORESOURCE_DMA:
 		return "dma";
+	case IORESOURCE_BUS:
+		return "bus";
 	}
-	return NULL;
+	return "unknown";
 }
 
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)

