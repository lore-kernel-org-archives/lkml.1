Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbYBXFkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbYBXFkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYBXFkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:40:09 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39322 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYBXFkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:40:06 -0500
Date: Sat, 23 Feb 2008 21:48:42 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: make amd quad core 8 socket system not be
 clustered_box v2
In-reply-to: <47BF1BD9.4020808@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802232148.43255.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


quad core 8 socket system will have apic id lifting.the apic id range could
be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
and that is large than 2. So it is treated as clustered_box.

and will get

Marking TSC unstable due to TSCs unsynchronized

even the CPUs have X86_FEATURE_CONSTANT_TSC set.

this patch will check if the cpu is from AMD.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index d8d03e0..7d8ffda 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1180,9 +1180,19 @@ __cpuinit int apic_is_clustered_box(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
-	u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	u16 *bios_cpu_apicid;
 	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
 
+	/*
+	 * there is not this kind of box with AMD CPU yet.
+	 * Some AMD box with quadcore cpu and 8 sockets apicid
+	 * will be [4, 0x23] or [8, 0x27] could be thought to
+	 * have three apic_clusters. So go out early.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return 0;
+
+	bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
 	for (i = 0; i < NR_CPUS; i++) {
