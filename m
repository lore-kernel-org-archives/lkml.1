Return-Path: <linux-kernel-owner+w=401wt.eu-S934396AbZKXXTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396AbZKXXTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbZKXXTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:19:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:34275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359AbZKXXTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:19:51 -0500
Message-ID: <4B0C69AD.3030106@kernel.org>
Date: Tue, 24 Nov 2009 15:18:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource that is not
 big -v11
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit!
 su.com>
In-Reply-To: <4B0B3C13.9030502@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> Yinghai Lu wrote:
>> Kenji Kaneshige wrote:
>>> Hi,
>>>
>>> I tried v11 patches. This version seems to fix the problem I
>>> reported against previous version.
>>>
>>> I have no objection against the idea of resource allocation
>>> changes for PCI express hotplug slots.
>>
>> thanks
>>
>>> But I still have concern about changing resource allocation for
>>> other than PCI express hotplug slots. For example, some hotplug
>>> controller other than PCI express can have multiple slots under
>>> the same bus. If some hotplug slots are occupied and the others
>>> are empty at the boot time, I think your code try to shrink the
>>> bus resources for hotplug slots allocated by BIOS. It would break
>>> the hot-add on the empty slots due to the resource allocation
>>> failure.
>>
>> no,
>> it will not touch bridge resources that already assigned by BIOS except
>> some bridge resource is not big enough. and get big one for them.
>>
> 
> Ok, I understood that if the BIOS assigns enough resources to the
> bridge, it has no impact.
> 
> One question. I thought your patch shrinks the bridge resource to
> allocate enough resource for sibling bridge. But it actually doesn't.
> Right?

please check if this one could fix the shrinking bridge resource problem...

[PATCH] pci: don't shrink bridge resources

when we are clearing leaf bridge resource and try to get big one, we could shrink the bridge if
there resource under it.

let check with old resource size and make sure we are trying to get big one.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -432,7 +432,7 @@ static void pbus_size_io(struct pci_bus
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0;
+	unsigned long size = 0, size1 = 0, old_size;
 
 	if (!b_res)
  		return;
@@ -457,17 +457,18 @@ static void pbus_size_io(struct pci_bus
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
@@ -483,7 +484,7 @@ static int pbus_size_mem(struct pci_bus
 			 unsigned long type, resource_size_t min_size)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size;
+	resource_size_t min_align, align, size, old_size;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -533,6 +534,11 @@ static int pbus_size_mem(struct pci_bus
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
@@ -549,10 +555,6 @@ static int pbus_size_mem(struct pci_bus
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
