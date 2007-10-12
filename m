Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbXJLWUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbXJLWUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760975AbXJLWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760796AbXJLWSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/75] Driver core: add CONFIG_UEVENT_HELPER_PATH
Date: Fri, 12 Oct 2007 15:16:09 -0700
Message-Id: <11922274643370-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274543490-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

The kernel creates a process for every event that is send, even when
there is no binary it could execute.  We are needlessly creating around
200-300 failing processes during early bootup, until we have the chance
to disable it from userspace.

This change allows us to disable /sbin/hotplug entirely, if you want to,
by setting UEVENT_HELPER_PATH="" in the kernel config.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |    8 ++++++++
 lib/kobject_uevent.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 5d6312e..d7da109 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -1,5 +1,13 @@
 menu "Generic Driver Options"
 
+config UEVENT_HELPER_PATH
+	string "path to uevent helper"
+	depends on HOTPLUG
+	default "/sbin/hotplug"
+	help
+	  Path to uevent helper program forked by the kernel for
+	  every uevent.
+
 config STANDALONE
 	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
 	default y
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 7d8aeb3..5ccda46 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -35,7 +35,7 @@ const char *kobject_actions[] = {
 
 #if defined(CONFIG_HOTPLUG)
 u64 uevent_seqnum;
-char uevent_helper[UEVENT_HELPER_PATH_LEN] = "/sbin/hotplug";
+char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
 static DEFINE_SPINLOCK(sequence_lock);
 #if defined(CONFIG_NET)
 static struct sock *uevent_sock;
-- 
1.5.3.4

