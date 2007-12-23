Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbXLWH2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbXLWH2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXLWH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:28:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:48418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbXLWH2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:28:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 2/2] Modules: fix memory leak of module names
Date: Sat, 22 Dec 2007 23:27:16 -0800
Message-Id: <1198394836-8994-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <20071223072424.GB8764@kroah.com>
References: <20071223072424.GB8764@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the change in kobject name handling, the module kobject needs to
have a null release function to ensure that the name it previously set
will be properly cleaned up.

All of this wierdness goes away in 2.6.25 with the rework of the kobject
name and cleanup logic, but this is required for 2.6.24.

Thanks to Alexey Dobriyan for finding the problem, and to Kay Sievers
for pointing out the simple way to fix it after I tried many complex
ways.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/params.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 2a4c514..7686417 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -697,8 +697,18 @@ static struct kset_uevent_ops module_uevent_ops = {
 decl_subsys(module, &module_ktype, &module_uevent_ops);
 int module_sysfs_initialized;
 
+static void module_release(struct kobject *kobj)
+{
+	/*
+	 * Stupid empty release function to allow the memory for the kobject to
+	 * be properly cleaned up.  This will not need to be present for 2.6.25
+	 * with the upcoming kobject core rework.
+	 */
+}
+
 static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
+	.release =	module_release,
 };
 
 /*
-- 
1.5.3.7

