Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZHZGXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZHZGXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZHZGW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:22:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:50917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZHZGW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:22:57 -0400
Date: Wed, 26 Aug 2009 06:22:29 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090824175551.493629148@openvz.org>
References: <20090824175551.493629148@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Get rid of needless check and simplify ioapic_setup_resources()
Message-ID: <tip-ffc438366c2660a6a811b94ba33229bf217f8254@git.kernel.org>
Git-Commit-ID: ffc438366c2660a6a811b94ba33229bf217f8254
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 06:22:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffc438366c2660a6a811b94ba33229bf217f8254
Gitweb:     http://git.kernel.org/tip/ffc438366c2660a6a811b94ba33229bf217f8254
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 24 Aug 2009 21:53:39 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 08:16:38 +0200

x86, ioapic: Get rid of needless check and simplify ioapic_setup_resources()

alloc_bootmem() already panics on allocation failure. There is
no need to check the result.

Also there is a way to unbind global variable from its body and
use it as a parameter which allow us to simplify
ioapic_init_mappings as well -- "for" cycle already uses
nr_ioapics as a conditional variable and there is no need to
check if ioapic_setup_resources was returning NULL again.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090824175551.493629148@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2999f3d..d836b4d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4053,7 +4053,7 @@ void __init setup_ioapic_dest(void)
 
 static struct resource *ioapic_resources;
 
-static struct resource * __init ioapic_setup_resources(void)
+static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 {
 	unsigned long n;
 	struct resource *res;
@@ -4069,15 +4069,13 @@ static struct resource * __init ioapic_setup_resources(void)
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
@@ -4091,7 +4089,7 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	ioapic_res = ioapic_setup_resources();
+	ioapic_res = ioapic_setup_resources(nr_ioapics);
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].apicaddr;
@@ -4120,11 +4118,9 @@ fake_ioapic_page:
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
 
