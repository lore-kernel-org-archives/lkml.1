Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYBUKua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYBUKua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYBUKuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:50:20 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52687 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYBUKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:50:19 -0500
Date: Thu, 21 Feb 2008 02:58:44 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802210258.45011.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


quad core 8 socket system will have apic id lifting.the apic id range could
be [4, 0x23]. or [8, 0x27]. apic_is_clustered_box will think that need to three clusters
and that is large than 2. So it is treated as clustered_box.

and will get

Marking TSC unstable due to TSCs unsynchronized

even the CPUs have X86_FEATURE_CONSTANT_TSC set.

this patch offset back the apic before get apic clusterid.

or use dmi to get apic_is_clustered?

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 9b2be3d..5bdf1bc 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1223,8 +1223,11 @@ __cpuinit int apic_is_clustered_box(void)
 		else
 			break;
 
-		if (id != BAD_APICID)
+		if (id != BAD_APICID) {
+			if (id >= boot_cpu_id)
+				id -= boot_cpu_id;
 			__set_bit(APIC_CLUSTERID(id), clustermap);
+		}
 	}
 
 	/* Problem:  Partially populated chassis may not have CPUs in some of
