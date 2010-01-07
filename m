Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836Ab0AGOby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0AGOby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558Ab0AGOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:31:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:10250 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0AGObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=G4bK+FEalcY+Nqh+s+pejANZi2GgJUnhTFNc6m0TfwVFnABL4O/N/EKRvh8AfIRdhZ
         VYJ7Oy3VJZaf6qN5WkR2sdjm0qKzQqUG/WmHjlsCrHTGi79Ch1RVKfWKdefFEXYhGODs
         ldOzv6sUsKebJLVVQROGHwq+0+m287o3m3zbs=
Message-ID: <4B45F13E.3040202@gmail.com>
Date: Thu, 07 Jan 2010 15:35:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, UV: remove recursion in uv_heartbeat_enable()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recursion is not needed and does not improve readability.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 8edb27c..fcc3f4a 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -473,7 +473,7 @@ static void uv_heartbeat(unsigned long ignored)
 
 static void __cpuinit uv_heartbeat_enable(int cpu)
 {
-	if (!uv_cpu_hub_info(cpu)->scir.enabled) {
+	while (!uv_cpu_hub_info(cpu)->scir.enabled) {
 		struct timer_list *timer = &uv_cpu_hub_info(cpu)->scir.timer;
 
 		uv_set_cpu_scir_bits(cpu, SCIR_CPU_HEARTBEAT|SCIR_CPU_ACTIVITY);
@@ -481,11 +481,10 @@ static void __cpuinit uv_heartbeat_enable(int cpu)
 		timer->expires = jiffies + SCIR_CPU_HB_INTERVAL;
 		add_timer_on(timer, cpu);
 		uv_cpu_hub_info(cpu)->scir.enabled = 1;
-	}
 
-	/* check boot cpu */
-	if (!uv_cpu_hub_info(0)->scir.enabled)
-		uv_heartbeat_enable(0);
+		/* also ensure that boot cpu is enabled */
+		cpu = 0;
+	}
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
