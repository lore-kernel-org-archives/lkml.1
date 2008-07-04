Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYGDBaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYGDBaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYGDB3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:29:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41667 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYGDB3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:29:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, <netdev@vger.kernel.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>
	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org>
	<486CF71F.5090405@gmail.com> <m1y74iiidz.fsf_-_@frodo.ebiederm.org>
	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>
	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>
	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>
	<m1d4luihea.fsf_-_@frodo.ebiederm.org>
	<m18wwiihbn.fsf_-_@frodo.ebiederm.org>
	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>
	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>
	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>
	<m1r6aah2hh.fsf_-_@frodo.ebiederm.org>
	<m1mykyh2fu.fsf_-_@frodo.ebiederm.org>
	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org>
Date: Thu, 03 Jul 2008 18:21:28 -0700
In-Reply-To: <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 03 Jul 2008 18:20:09 -0700")
Message-ID: <m1d4luh2av.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 13/15] Revert "netns: Fix device renaming for sysfs"
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit aaf8cdc34ddba08122f02217d9d684e2f9f5d575.

Drivers like the ipw2100 call device_create_group when they
are initialized and device_remove_group when they are shutdown.
Moving them between namespaces deletes their sysfs groups early.

In particular the following call chain results.
netdev_unregister_kobject -> device_del -> kobject_del -> sysfs_remove_dir
With sysfs_remove_dir recursively deleting all of it's subdirectories,
and nothing adding them back.

Ouch!

Therefore we need to call something that ultimate calls sysfs_mv_dir
as that sysfs function can move sysfs directories between namespaces
without deleting their subdirectories or their contents.   Allowing
us to avoid placing extra boiler plate into every driver that does
something interesting with sysfs.

Currently the function that provides that capability is device_rename.
That is the code works without nasty side effects as originally written.

So remove the misguided fix for moving devices between namespaces.  The
bug in the kobject layer that inspired it has now been recognized and
fixed.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/dev.c       |    4 +---
 net/core/net-sysfs.c |    7 +------
 net/core/net-sysfs.h |    2 +-
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fca23a3..585584d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3806,7 +3806,6 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	netdev_initialize_kobject(dev);
 	ret = netdev_register_kobject(dev);
 	if (ret)
 		goto err_uninit;
@@ -4239,8 +4238,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	}
 
 	/* Fixup kobjects */
-	netdev_unregister_kobject(dev);
-	err = netdev_register_kobject(dev);
+	err = device_rename(&dev->dev, dev->name);
 	WARN_ON(err);
 
 	/* Add the device back in the hashes */
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 90e2177..4e7b847 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -449,6 +449,7 @@ int netdev_register_kobject(struct net_device *net)
 	struct device *dev = &(net->dev);
 	struct attribute_group **groups = net->sysfs_groups;
 
+	device_initialize(dev);
 	dev->class = &net_class;
 	dev->platform_data = net;
 	dev->groups = groups;
@@ -469,12 +470,6 @@ int netdev_register_kobject(struct net_device *net)
 	return device_add(dev);
 }
 
-void netdev_initialize_kobject(struct net_device *net)
-{
-	struct device *device = &(net->dev);
-	device_initialize(device);
-}
-
 int netdev_kobject_init(void)
 {
 	return class_register(&net_class);
diff --git a/net/core/net-sysfs.h b/net/core/net-sysfs.h
index 14e7524..f5f108d 100644
--- a/net/core/net-sysfs.h
+++ b/net/core/net-sysfs.h
@@ -4,5 +4,5 @@
 int netdev_kobject_init(void);
 int netdev_register_kobject(struct net_device *);
 void netdev_unregister_kobject(struct net_device *);
-void netdev_initialize_kobject(struct net_device *);
+
 #endif
-- 
1.5.3.rc6.17.g1911

