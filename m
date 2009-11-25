Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZKYUA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZKYUA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbZKYUA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:00:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:56933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934838AbZKYUAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:00:55 -0500
Message-ID: <4B0D8CAB.8000605@kernel.org>
Date: Wed, 25 Nov 2009 11:59:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 6/9] pci: don't shrink bridge resources
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D88A4.5050904@kerne!
 l.org>
In-Reply-To: <4B0D88A4.5050904@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when we are clearing leaf bridge resource and try to get big one, we could shrink the bridge if
there is no resource under it.

let check with old resource size and make sure we are trying to get big one.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -390,7 +390,7 @@ static void pbus_size_io(struct pci_bus
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0;
+	unsigned long size = 0, size1 = 0, old_size;
 
 	if (!b_res)
  		return;
@@ -415,17 +415,18 @@ static void pbus_size_io(struct pci_bus
 	}
 	if (size < min_size)
 		size = min_size;
+	old_size = resource_size(b_res);
+	if (old_size == 1)
+		old_size = 0;
 /* To be fixed in 2.5: we should have sort of HAVE_ISA
    flag in the struct pci_bus. */
 #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
 	size = ALIGN(size + size1, 4096);
+	if (size < old_size)
+		size = old_size;
 	if (!size) {
-		if (b_res->start || b_res->end)
-			dev_info(&bus->self->dev, "disabling bridge window "
-				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
-				 bus->secondary, bus->subordinate);
 		b_res->flags = 0;
 		return;
 	}
@@ -441,7 +442,7 @@ static int pbus_size_mem(struct pci_bus
 			 unsigned long type, resource_size_t min_size)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size;
+	resource_size_t min_align, align, size, old_size;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -491,6 +492,11 @@ static int pbus_size_mem(struct pci_bus
 	}
 	if (size < min_size)
 		size = min_size;
+	old_size = resource_size(b_res);
+	if (old_size == 1)
+		old_size = 0;
+	if (size < old_size)
+		size = old_size;
 
 	align = 0;
 	min_align = 0;
@@ -507,10 +513,6 @@ static int pbus_size_mem(struct pci_bus
 	}
 	size = ALIGN(size, min_align);
 	if (!size) {
-		if (b_res->start || b_res->end)
-			dev_info(&bus->self->dev, "disabling bridge window "
-				 "%pR to [bus %02x-%02x] (unused)\n", b_res,
-				 bus->secondary, bus->subordinate);
 		b_res->flags = 0;
 		return 1;
 	}

