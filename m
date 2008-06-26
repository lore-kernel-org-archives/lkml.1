Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbYFZNDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbYFZNDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbYFZMoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:44:14 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23727 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759444AbYFZMoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:44:12 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 22/60] microblaze_v4: heartbeat file
Date: Thu, 26 Jun 2008 14:29:51 +0200
Message-Id: <1214483429-32360-23-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-22-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/heartbeat.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/heartbeat.c

diff --git a/arch/microblaze/kernel/heartbeat.c b/arch/microblaze/kernel/heartbeat.c
new file mode 100644
index 0000000..5a21c1d
--- /dev/null
+++ b/arch/microblaze/kernel/heartbeat.c
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/sched.h>
+#include <asm/page.h>
+#include <asm/io.h>
+#include <asm/setup.h>
+
+void heartbeat(void)
+{
+	static unsigned int cnt, period, dist;
+
+	if (cnt == 0 || cnt == dist)
+		iowrite32(1, CONFIG_HEART_BEAT_ADDRESS);
+	else if (cnt == 7 || cnt == dist + 7)
+		iowrite32(0, CONFIG_HEART_BEAT_ADDRESS);
+
+	if (++cnt > period) {
+		cnt = 0;
+		/*
+		 * The hyperbolic function below modifies the heartbeat period
+		 * length in dependency of the current (5min) load. It goes
+		 * through the points f(0)=126, f(1)=86, f(5)=51, f(inf)->30.
+		 */
+		period = ((672 << FSHIFT) / (5 * avenrun[0] +
+					(7 << FSHIFT))) + 30;
+		dist = period / 4;
+	}
+}
-- 
1.5.4.GIT

