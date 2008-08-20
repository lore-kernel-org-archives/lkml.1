Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYHTTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYHTTIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYHTTI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:08:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbYHTTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aMiQWmI3CF0W+eDDm2FnryiB+SsrOH/KfUzjq3yzSXDkIMdUpQNK3dkp1ojvZOw2gi
         KbrPvJ6uWi7utcYnvOU2l64THvC6fb/Hh7mYOuh/l4lCkQQHMjtL/uQUVzkWMZjr17F3
         vthW+o5Kzfa4y7grDoHaWoIFeKSZzw3QgyICU=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH] x86: silence section mismatch warning - uv_cpu_init
Date: Wed, 20 Aug 2008 21:07:48 +0200
Message-Id: <1219259268-5868-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
The function __cpuinit uv_cpu_init() references
a function __init uv_system_init().
If uv_system_init is only used by uv_cpu_init then
annotate uv_system_init with a matching annotation.

uv_system_init was ment to be called only once, so make explicit
by creating properly-named function and annotate it as __ref.

Old code relied on uv_node_to_blade being initialized to 0,
but it'a not initialized from anywhere and it's not static either.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 2d7e307..ecbfefa 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -385,14 +385,24 @@ static __init void uv_system_init(void)
 	map_mmioh_high(max_pnode);
 }
 
+/* Wrapper for uv_system_init which calls it only once. */
+static void __ref uv_system_init_once(void)
+{
+	static bool uv_system_inited = false;
+
+	if (!uv_system_inited) {
+		uv_system_init();
+		uv_system_inited = true;
+	}
+}
+
 /*
  * Called on each cpu to initialize the per_cpu UV data area.
  * 	ZZZ hotplug not supported yet
  */
 void __cpuinit uv_cpu_init(void)
 {
-	if (!uv_node_to_blade)
-		uv_system_init();
+	uv_system_init_once();
 
 	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
 
-- 
1.5.4.5

