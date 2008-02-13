Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbYBMQWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbYBMQWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYBMQWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:22:16 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:60593 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbYBMQWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:22:15 -0500
Date: Wed, 13 Feb 2008 10:22:12 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 2/8] IPMI: Change device node ordering to reflect probe order
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Carol Hebert <cah@us.ibm.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080213162212.GB9830@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carol Hebert <cah@us.ibm.com>

Currently, on systems with multiple BMC interfaces, the ipmi device
names are being created in reverse order relative to how they are
discovered on the system (e.g. on an IBM x3950 multinode server with N
nodes, the device name for the BMC in the first node is /dev/ipmiN-1 and
the device name for the BMC in the last node is /dev/ipmi0, etc.). The
problem is caused by the list handling routines chosen in dmi_scan.c.
Using list_add() causes the multiple ipmi devices to be added to the
device list using a stack-paradigm and so the ipmi driver subsequently
pulls them off during initialization in LIFO order.  This patch changes
the dmi_save_ipmi_device() list handling paradigm to a queue, thereby
allowing the ipmi driver to build the ipmi device names in the order in
which they are found on the system.

Signed-off-by: Carol Hebert <cah@us.ibm.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

--- linux-2.6.24.orig/drivers/firmware/dmi_scan.c	2008-01-30 11:21:55.000000000 -0800
+++ linux-2.6.24/drivers/firmware/dmi_scan.c	2008-01-30 11:18:05.000000000 -0800
@@ -219,7 +219,7 @@ static void __init dmi_save_ipmi_device(
 	dev->name = "IPMI controller";
 	dev->device_data = data;
 
-	list_add(&dev->list, &dmi_devices);
+	list_add_tail(&dev->list, &dmi_devices);
 }
 
 /*

