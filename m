Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXDCGIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXDCGIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXDCGIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:08:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43263 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbXDCGII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:08:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: Ignore sysfs network device rename bugs.
Date: Tue, 03 Apr 2007 00:07:30 -0600
Message-ID: <m1vegec7od.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The generic networking code ensures that no two networking devices
have the same name, so  there is no time except when sysfs has
implementation bugs that device_rename when called from
dev_change_name will fail. 

The current error handling for errors from device_rename in
dev_change_name is wrong and results in an unusable and unrecoverable
network device if device_rename is happens to return an error.

This patch removes the buggy error handling.  Which confines the mess
when device_rename hits a problem to sysfs, instead of propagating it
the rest of the network stack.  Making linux a little more robust.

Without this patch you can observe what happens when sysfs has a bug
when CONFIG_SYSFS_DEPRECATED is not set and you attempt to rename
a real network device to a name like (broken_parity_status, device,
modalias, power, resource2, subsystem_vendor, class,  driver, irq,
msi_bus, resource, subsystem, uevent, config, enable, local_cpus,
numa_node, resource0, subsystem_device, vendor)

Greg has a patch that fixes the sysfs bugs but he doesn't trust it
for a 2.6.21 timeframe.  This patch which just ignores errors should
be safe and it keeps the system from going completely wacky.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/dev.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5984b55..cf054f9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -751,13 +751,10 @@ int dev_change_name(struct net_device *dev, char *newname)
 	else
 		strlcpy(dev->name, newname, IFNAMSIZ);
 
-	err = device_rename(&dev->dev, dev->name);
-	if (!err) {
-		hlist_del(&dev->name_hlist);
-		hlist_add_head(&dev->name_hlist, dev_name_hash(dev->name));
-		raw_notifier_call_chain(&netdev_chain,
-				NETDEV_CHANGENAME, dev);
-	}
+	device_rename(&dev->dev, dev->name);
+	hlist_del(&dev->name_hlist);
+	hlist_add_head(&dev->name_hlist, dev_name_hash(dev->name));
+	raw_notifier_call_chain(&netdev_chain, NETDEV_CHANGENAME, dev);
 
 	return err;
 }
-- 
1.5.0.4

