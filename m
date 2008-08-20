Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYHTTIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYHTTIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYHTTIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:08:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYHTTIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WU0jghcO5wlCdpdUtHdNYijWUBoKnprpmd9pDn21YCY3uoHCskrBaGCuEixijw4N5C
         rp2z//sMiWxtVqaCFYX3mMX4oZLJV2FACf+W3pJCH667NYajukRw7LUW9ZNSAWaJk0yp
         4Agqx6N2n+u5bTIubbE2cOSikJvSFSmtUA3Bw=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Paalanen <pq@iki.fi>
Subject: [PATCH] x86, mmiotrace: silence section mismatch warning - leave_uniprocessor
Date: Wed, 20 Aug 2008 21:07:47 +0200
Message-Id: <1219259268-5868-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x180af): Section mismatch in reference from the function leave_uniprocessor() to the function .cpuinit.text:cpu_up()
The function leave_uniprocessor() references
the function __cpuinit cpu_up().
This is often because leave_uniprocessor lacks a __cpuinit
annotation or the annotation of cpu_up is wrong.

leave_uniprocessor calls cpu_up only when CONFIG_HOTPLUG_CPU is set,
so it can be safely annotated as __ref

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/mmio-mod.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index e7397e1..635b50e 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -430,7 +430,9 @@ static void enter_uniprocessor(void)
 						"may miss events.\n");
 }
 
-static void leave_uniprocessor(void)
+/* __ref because leave_uniprocessor calls cpu_up which is __cpuinit,
+   but this whole function is ifdefed CONFIG_HOTPLUG_CPU */
+static void __ref leave_uniprocessor(void)
 {
 	int cpu;
 	int err;
-- 
1.5.4.5

