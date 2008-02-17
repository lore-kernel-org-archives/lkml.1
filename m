Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbYBQMbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbYBQMbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbYBQMX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:28 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55077 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 05/27] cpu: fix section mismatch warnings in hotcpu_register
Date: Sun, 17 Feb 2008 13:22:42 +0100
Message-Id: <1203250984-11285-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.data+0x5020): Section mismatch in reference from the variable cpu_vsyscall_notifier_nb.12876 to the function .cpuinit.text:cpu_vsyscall_notifier()
WARNING: vmlinux.o(.data+0x9ce0): Section mismatch in reference from the variable profile_cpu_callback_nb.17654 to the function .devinit.text:profile_cpu_callback()
WARNING: vmlinux.o(.data+0xd380): Section mismatch in reference from the variable workqueue_cpu_callback_nb.15004 to the function .devinit.text:workqueue_cpu_callback()
WARNING: vmlinux.o(.data+0x11d00): Section mismatch in reference from the variable relay_hotcpu_callback_nb.19626 to the function .cpuinit.text:relay_hotcpu_callback()
WARNING: vmlinux.o(.data+0x12970): Section mismatch in reference from the variable cpu_callback_nb.24694 to the function .devinit.text:cpu_callback()
WARNING: vmlinux.o(.data+0x3fee0): Section mismatch in reference from the variable percpu_counter_hotcpu_callback_nb.10903 to the function .cpuinit.text:percpu_counter_hotcpu_callback()
WARNING: vmlinux.o(.data+0x74ce0): Section mismatch in reference from the variable topology_cpu_callback_nb.12506 to the function .cpuinit.text:topology_cpu_callback()

Functions used as argument are by definition only used
in HOTPLUG_CPU situations so thay are annotated __cpuinit.
Annotate the static variable used by hotcpu_register with
__cpuinitdata to match this definition.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 include/linux/cpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 0be8d65..237c19a 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -109,7 +109,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
-- 
1.5.4.rc3.14.g44397

