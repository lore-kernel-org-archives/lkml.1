Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYF2Asu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYF2Asu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYF2As3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:48:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:56290 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYF2As1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OSgntfEnODfwL4vQDK8uxKFf4eIIu/rFFUO6/fv/EwxK8YBNMHUYi7y4+VXiX3NiEZ
         hg/DrXpBsD0H3J3rEseA52esi7OWdl5nCfRPWrzK/hzVncPaOxpWaeL1Zssb0udr2kli
         uoKOiLxeXPUZvoe0l0c9+r6L+ZNg6HA/fZsik=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix warning in e820_reserve_resources with 32bit
Date: Sat, 28 Jun 2008 17:49:59 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806271538.46829.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com>
In-Reply-To: <200806272247.11971.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806281749.59443.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when 64bit resource is not enabled, got:

arch/x86/kernel/e820.c: In function ‘e820_reserve_resources’:
arch/x86/kernel/e820.c:1217: warning: comparison is always false due to limited range of data type

because res->start/end is resource_t aka u32. it will overflow.

fix it with temp end of u64

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index fa77cb4..ba5ac88 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1202,6 +1202,7 @@ void __init e820_reserve_resources(void)
 {
 	int i;
 	struct resource *res;
+	u64 end;
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
 	for (i = 0; i < e820.nr_map; i++) {
@@ -1211,14 +1212,16 @@ void __init e820_reserve_resources(void)
 		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
 		default:	res->name = "reserved";
 		}
-		res->start = e820.map[i].addr;
-		res->end = res->start + e820.map[i].size - 1;
+		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
-		if (res->end > 0x100000000ULL) {
+		if (end > 0x100000000ULL) {
 			res++;
 			continue;
 		}
 #endif
+		res->start = e820.map[i].addr;
+		res->end = end;
+
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
 		res++;
