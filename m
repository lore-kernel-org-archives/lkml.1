Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYCKAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYCKAz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYCKAzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:55:19 -0400
Received: from ns.suse.de ([195.135.220.2]:60139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbYCKAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:55:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Balaji Rao <balajirrao@gmail.com>
Subject: [PATCH 1/4] sysdev: fix problem with sysdev_class being re-registered
Date: Mon, 10 Mar 2008 17:55:11 -0700
Message-Id: <1205196914-17965-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004219.GA17890@suse.de>
References: <20080311004219.GA17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to initialize the kobject for a sysdev_class as it could have
been recycled (stupid static kobjects...)

We also do the same thing in case sysdev devices are being
re-registered.

Thanks to Balaji Rao <balajirrao@gmail.com> for pointing out the
problem.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 2f79c55..8e13fd9 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 	pr_debug("Registering sysdev class '%s'\n",
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
+	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
@@ -227,6 +228,9 @@ int sysdev_register(struct sys_device * sysdev)
 
 	pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
 
+	/* initialize the kobject to 0, in case it had previously been used */
+	memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
+
 	/* Make sure the kset is set */
 	sysdev->kobj.kset = &cls->kset;
 
-- 
1.5.4.3

