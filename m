Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZHXR4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZHXR4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZHXR4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:56:34 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38834 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZHXRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=YP3ekwRKq2zsssLv4sOOCD6s5d6mzW5FEIWQaeluY/TYk+KNjUCTpjlSv0mdipsoM4
         /D3JD0ItRM16hY5Z79mJmLBuETEMjkrE/joxy3YaliLHrcsJeBZ67AVlCk+VtlxjAJlY
         a4er86ip/DCygfAghdUraBZJqLtT/KQ6qHN6Y=
Message-Id: <20090824175551.493629148@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 24 Aug 2009 21:53:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [rfc -tip 4/4] x86,ioapic: ioapic_setup_resources - get rid of needless check and simplify
References: <20090824175335.186713800@openvz.org>
Content-Disposition: inline; filename=x86-io-apic-bootmem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_bootmem do panic on allication failure.
There is no need to check the result.

Also there is a way to unbind global variable from its
body and use it as a parameter which allow us to simplify
ioapic_init_mappings as well -- "for" cycle already uses
nr_ioapics as a conditional variable and there is no need
to check if ioapic_setup_resources was returning NULL again.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -4056,7 +4056,7 @@ void __init setup_ioapic_dest(void)
 
 static struct resource *ioapic_resources;
 
-static struct resource * __init ioapic_setup_resources(void)
+static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 {
 	unsigned long n;
 	struct resource *res;
@@ -4072,15 +4072,13 @@ static struct resource * __init ioapic_s
 	mem = alloc_bootmem(n);
 	res = (void *)mem;
 
-	if (mem != NULL) {
-		mem += sizeof(struct resource) * nr_ioapics;
+	mem += sizeof(struct resource) * nr_ioapics;
 
-		for (i = 0; i < nr_ioapics; i++) {
-			res[i].name = mem;
-			res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-			sprintf(mem,  "IOAPIC %u", i);
-			mem += IOAPIC_RESOURCE_NAME_SIZE;
-		}
+	for (i = 0; i < nr_ioapics; i++) {
+		res[i].name = mem;
+		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		sprintf(mem,  "IOAPIC %u", i);
+		mem += IOAPIC_RESOURCE_NAME_SIZE;
 	}
 
 	ioapic_resources = res;
@@ -4094,7 +4092,7 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	ioapic_res = ioapic_setup_resources();
+	ioapic_res = ioapic_setup_resources(nr_ioapics);
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].apicaddr;
@@ -4123,11 +4121,9 @@ fake_ioapic_page:
 			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
 
-		if (ioapic_res != NULL) {
-			ioapic_res->start = ioapic_phys;
-			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
-			ioapic_res++;
-		}
+		ioapic_res->start = ioapic_phys;
+		ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+		ioapic_res++;
 	}
 }
 

