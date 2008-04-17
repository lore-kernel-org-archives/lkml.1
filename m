Return-Path: <linux-kernel-owner+w=401wt.eu-S1765660AbYDQBdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765660AbYDQBdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbYDQBOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:14:21 -0400
Received: from sous-sol.org ([216.99.217.87]:59888 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760702AbYDQBOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:14:19 -0400
Message-Id: <20080417010339.321227891@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Carol Hebert <cah@us.ibm.com>, Corey Minyard <cminyard@mvista.com>
Subject: ipmi: change device node ordering to reflect probe order
Content-Disposition: inline; filename=ipmi-change-device-node-ordering-to-reflect-probe-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Carol Hebert <cah@us.ibm.com>

upstream commit: abd24df828f1a72971db29d1b74fefae104ea9e2

In 2.6.14 a patch was merged which switching the order of the ipmi device
naming from in-order-of-discovery over to reverse-order-of-discovery.

So on systems with multiple BMC interfaces, the ipmi device names are being
created in reverse order relative to how they are discovered on the system
(e.g.  on an IBM x3950 multinode server with N nodes, the device name for the
BMC in the first node is /dev/ipmiN-1 and the device name for the BMC in the
last node is /dev/ipmi0, etc.).

The problem is caused by the list handling routines chosen in dmi_scan.c.
Using list_add() causes the multiple ipmi devices to be added to the device
list using a stack-paradigm and so the ipmi driver subsequently pulls them off
during initialization in LIFO order.  This patch changes the
dmi_save_ipmi_device() list handling paradigm to a queue, thereby allowing the
ipmi driver to build the ipmi device names in the order in which they are
found on the system.

Signed-off-by: Carol Hebert <cah@us.ibm.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/firmware/dmi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -219,7 +219,7 @@ static void __init dmi_save_ipmi_device(
 	dev->name = "IPMI controller";
 	dev->device_data = data;
 
-	list_add(&dev->list, &dmi_devices);
+	list_add_tail(&dev->list, &dmi_devices);
 }
 
 /*

-- 
