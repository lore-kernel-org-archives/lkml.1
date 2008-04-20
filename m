Return-Path: <linux-kernel-owner+w=401wt.eu-S1762691AbYDTKpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762691AbYDTKpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbYDTKk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYDTKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/36] driver core: cpu: fix section mismatch in cpu.c:store_online
Date: Sun, 20 Apr 2008 03:45:46 -0700
Message-Id: <1208688366-9252-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x64609c): Section mismatch in reference from the function store_online() to the function .cpuinit.text:cpu_up()

store_online() is defined inside a HOTPLUG_CPU block so references are OK.
Ignore references by annotating store_online() with __ref.

Note: This is needed because cpu_up() most likely should not have been
__cpuinit but all the hotplug cpu code misuses the __cpuinit annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.5.4.5

