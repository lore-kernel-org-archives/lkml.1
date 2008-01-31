Return-Path: <linux-kernel-owner+w=401wt.eu-S934884AbYAaWLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884AbYAaWLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934020AbYAaWKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:41 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35692 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934317AbYAaWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:37 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] cpu: silence section mismatch warnings for hotcpu notifies
Date: Thu, 31 Jan 2008 23:10:35 +0100
Message-Id: <1201817440-5081-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hotcpu_notifier is used to create notifiers to be called later.
It really looks like the functions that are registered are only
relevant in a HOTPLUG_CPU configuration and the correct fix was
to wrap them in an #ifdef / #endif or similar.
But for now just tell modpost to silence the warning by annotating
the static variable with __refdata.

This silences the following warnings in kernel/:
WARNING: o-x86_64/kernel/built-in.o(.data+0x960): Section mismatch in reference from the variable profile_cpu_callback_nb.17240 to the function .devinit.text:profile_cpu_callback()
WARNING: o-x86_64/kernel/built-in.o(.data+0x3fa0): Section mismatch in reference from the variable workqueue_cpu_callback_nb.14663 to the function .devinit.text:workqueue_cpu_callback()
WARNING: o-x86_64/kernel/built-in.o(.data+0xe280): Section mismatch in reference from the variable relay_hotcpu_callback_nb.19247 to the function .cpuinit.text:relay_hotcpu_callback()

Additional warnings are silenced with this change but
they are left put.

This patch is just a workaround for the bad practice
to use __cpuinit to annotate code solely used for
HOTPLUG_CPU.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 include/linux/cpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 0be8d65..cebb8c0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -109,7 +109,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __refdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
-- 
1.5.4.rc3.14.g44397

