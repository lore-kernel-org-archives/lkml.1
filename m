Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYBQMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYBQMZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYBQMXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55051 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/27] drivers/base/cpu: fix section mismatch in cpu.c:store_online
Date: Sun, 17 Feb 2008 13:22:50 +0100
Message-Id: <1203250984-11285-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x64609c): Section mismatch in reference from the function store_online() to the function .cpuinit.text:cpu_up()

store_online() is defined inside a HOTPLUG_CPU block
so references are OK. Ignore references by annotating
store_online() with __ref.

Note: This is needed because cpu_up() most likely should
not have been __cpuinit but all the hotplug cpu code
misuses the __cpuinit annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 499b003..3e417a9 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -28,7 +28,7 @@ static ssize_t show_online(struct sys_device *dev, char *buf)
 	return sprintf(buf, "%u\n", !!cpu_online(cpu->sysdev.id));
 }
 
-static ssize_t store_online(struct sys_device *dev, const char *buf,
+static ssize_t __ref store_online(struct sys_device *dev, const char *buf,
 			    size_t count)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
@@ -55,7 +55,7 @@ static ssize_t store_online(struct sys_device *dev, const char *buf,
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
-static void __devinit register_cpu_control(struct cpu *cpu)
+static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
 }
-- 
1.5.4.rc3.14.g44397

