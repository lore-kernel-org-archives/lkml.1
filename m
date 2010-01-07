Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763Ab0AIWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0AIWk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809Ab0AIWk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:40:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:40146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0AIWk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:40:56 -0500
Date: Thu, 7 Jan 2010 23:57:56 GMT
From: tip-bot for Roel Kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roel.kluin@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roel.kluin@gmail.com, tglx@linutronix.de
In-Reply-To: <4B45F13E.3040202@gmail.com>
References: <4B45F13E.3040202@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv: Remove recursion in uv_heartbeat_enable()
Message-ID: <tip-99659a929d653d0c9ce458091870544768add871@git.kernel.org>
Git-Commit-ID: 99659a929d653d0c9ce458091870544768add871
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99659a929d653d0c9ce458091870544768add871
Gitweb:     http://git.kernel.org/tip/99659a929d653d0c9ce458091870544768add871
Author:     Roel Kluin <roel.kluin@gmail.com>
AuthorDate: Thu, 7 Jan 2010 15:35:42 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jan 2010 11:50:06 -0800

x86, uv: Remove recursion in uv_heartbeat_enable()

The recursion is not needed and does not improve readability.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
LKML-Reference: <4B45F13E.3040202@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index af5d103..d199dc3 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -475,7 +475,7 @@ static void uv_heartbeat(unsigned long ignored)
 
 static void __cpuinit uv_heartbeat_enable(int cpu)
 {
-	if (!uv_cpu_hub_info(cpu)->scir.enabled) {
+	while (!uv_cpu_hub_info(cpu)->scir.enabled) {
 		struct timer_list *timer = &uv_cpu_hub_info(cpu)->scir.timer;
 
 		uv_set_cpu_scir_bits(cpu, SCIR_CPU_HEARTBEAT|SCIR_CPU_ACTIVITY);
@@ -483,11 +483,10 @@ static void __cpuinit uv_heartbeat_enable(int cpu)
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
