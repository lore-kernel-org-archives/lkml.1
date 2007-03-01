Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXCARPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXCARPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965447AbXCARPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:15:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbXCARNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:13:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=iEsWL6e0eMwBefNhAbBGNv+ha29UZTR/uDwou5P2OVr430/MBtzjMXUraYwcty9+0
	wunK8SrygzbJ8RrDG7+KQ==
Date: Thu, 1 Mar 2007 09:13:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 6/7] x86_64: export physnode mapping to userspace
In-Reply-To: <Pine.LNX.4.64.0703010130310.10045@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0703010131070.10045@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703010127130.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010128150.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010128490.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010129180.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010130310.10045@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Exports the physical NUMA node to fake NUMA node mapping to user-space via
sysfs.  The information is now accessible via the 'physnode' file.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Rohit Seth <rohitseth@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/base/node.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -133,6 +133,13 @@ static ssize_t node_read_distance(struct sys_device * dev, char * buf)
 }
 static SYSDEV_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
+#ifdef CONFIG_NUMA_EMU
+static ssize_t node_read_physnode(struct sys_device *dev, char *buf)
+{
+	return sprintf(buf, "%d\n", get_phys_node(dev->id));
+}
+static SYSDEV_ATTR(physnode, S_IRUGO, node_read_physnode, NULL);
+#endif
 
 /*
  * register_node - Setup a driverfs device for a node.
@@ -153,6 +160,9 @@ int register_node(struct node *node, int num, struct node *parent)
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
+#ifdef CONFIG_NUMA_EMU
+		sysdev_create_file(&node->sysdev, &attr_physnode);
+#endif
 	}
 	return error;
 }
@@ -170,6 +180,9 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_meminfo);
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
+#ifdef CONFIG_NUMA_EMU
+	sysdev_remove_file(&node->sysdev, &attr_physnode);
+#endif
 
 	sysdev_unregister(&node->sysdev);
 }
