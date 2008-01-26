Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYAZWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYAZWLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYAZWLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:43 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41234 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYAZWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in mcheck/mce_64.c
Date: Sat, 26 Jan 2008 23:11:47 +0100
Message-Id: <1201385513-26885-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/x86/kernel/cpu/mcheck/built-in.o(.text+0x752): Section mismatch: reference to .cpuinit.text:mce_create_device in 'mce_cpu_callback'

mce_cpu_callback() is only used by mce_cpu_notofier.
The notifier is only used for hotplugable cpu's as it is
registered using register_hotcpu_notifier(),

Annotate them both __cpuinit to fix the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 98b23d5..9a699ed 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -854,8 +854,8 @@ static void mce_remove_device(unsigned int cpu)
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int
-mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
+				      unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
@@ -872,7 +872,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier = {
+static struct notifier_block mce_cpu_notifier __cpuinitdata = {
 	.notifier_call = mce_cpu_callback,
 };
 
-- 
1.5.4.rc3.14.g44397

