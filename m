Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYHUGpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYHUGpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbYHUGoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:44:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60860 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYHUGoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:44:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
References: <m1y74iiidz.fsf_-_@frodo.ebiederm.org>
	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>
	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>
	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>
	<m1d4luihea.fsf_-_@frodo.ebiederm.org>
	<m18wwiihbn.fsf_-_@frodo.ebiederm.org>
	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>
	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>
	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>
	<20080820021754.GA25182@kroah.com>
	<m1od3m282j.fsf_-_@frodo.ebiederm.org>
	<m1hc9e27ya.fsf_-_@frodo.ebiederm.org>
	<m1d4k227wg.fsf_-_@frodo.ebiederm.org>
	<m18wuq27uj.fsf_-_@frodo.ebiederm.org>
	<m14p5e27tb.fsf_-_@frodo.ebiederm.org>
Date: Wed, 20 Aug 2008 23:38:31 -0700
In-Reply-To: <m14p5e27tb.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Wed, 20 Aug 2008 23:36:32 -0700")
Message-ID: <m1vdxuzxco.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0433]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 6/8] Revert "netns: Fix device renaming for sysfs"
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
 net/core/net-sysfs.h |    1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 600bb23..a7e236c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3989,7 +3989,6 @@ int register_netdevice(struct net_device *dev)
 	if (dev->features & NETIF_F_SG)
 		dev->features |= NETIF_F_GSO;
 
-	netdev_initialize_kobject(dev);
 	ret = netdev_register_kobject(dev);
 	if (ret)
 		goto err_uninit;
@@ -4451,8 +4450,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	}
 
 	/* Fixup kobjects */
-	netdev_unregister_kobject(dev);
-	err = netdev_register_kobject(dev);
+	err = device_rename(&dev->dev, dev->name);
 	WARN_ON(err);
 
 	/* Add the device back in the hashes */
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c1f4e0d..c9968f1 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -449,6 +449,7 @@ int netdev_register_kobject(struct net_device *net)
 	struct device *dev = &(net->dev);
 	struct attribute_group **groups = net->sysfs_groups;
 
+	device_initialize(dev);
 	dev->class = &net_class;
 	dev->platform_data = net;
 	dev->groups = groups;
@@ -481,12 +482,6 @@ void netdev_class_remove_file(struct class_attribute *class_attr)
 EXPORT_SYMBOL(netdev_class_create_file);
 EXPORT_SYMBOL(netdev_class_remove_file);
 
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
index 14e7524..805555e 100644
--- a/net/core/net-sysfs.h
+++ b/net/core/net-sysfs.h
@@ -4,5 +4,4 @@
 int netdev_kobject_init(void);
 int netdev_register_kobject(struct net_device *);
 void netdev_unregister_kobject(struct net_device *);
-void netdev_initialize_kobject(struct net_device *);
 #endif
-- 
1.5.3.rc6.17.g1911

