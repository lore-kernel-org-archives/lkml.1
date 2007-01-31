Return-Path: <linux-kernel-owner+w=401wt.eu-S965344AbXAaPTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344AbXAaPTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXAaPTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:19:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965430AbXAaPSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:18:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=fAyfV/9zF6OBiALeRDv6aV+IkBbdMjQf8J+u7qX2wyGDQJxx5A/1tb4505LfT/bNO
	5oR/60fSN3+i/XlIA1dsQ==
Date: Wed, 31 Jan 2007 07:18:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Andi Kleen <ak@suse.de>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 7/7] x86_64: export physnode mapping to userspace
In-Reply-To: <Pine.LNX.4.64.0701302226040.23658@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0701302226380.23658@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0701302223230.23653@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302224300.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302224550.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302225200.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302225390.23658@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0701302226040.23658@chino.kir.corp.google.com>
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
index 001e6f6..548d365 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -136,6 +136,13 @@ static ssize_t node_read_distance(struct sys_device * dev, char * buf)
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
@@ -156,6 +163,9 @@ int register_node(struct node *node, int num, struct node *parent)
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
+#ifdef CONFIG_NUMA_EMU
+		sysdev_create_file(&node->sysdev, &attr_physnode);
+#endif
 	}
 	return error;
 }
@@ -173,6 +183,9 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_meminfo);
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
+#ifdef CONFIG_NUMA_EMU
+	sysdev_remove_file(&node->sysdev, &attr_physnode);
+#endif
 
 	sysdev_unregister(&node->sysdev);
 }
