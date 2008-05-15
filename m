Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYEOBQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYEOBQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbYEOBQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:16:18 -0400
Received: from mail.vyatta.com ([216.93.170.194]:50089 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbYEOBQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:16:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.499
Date: Wed, 14 May 2008 18:15:28 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>, fubar@us.ibm.com
Cc: netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] bonding: handle case of device named bonding_master
Message-ID: <20080514181528.1ff1791a@extreme>
In-Reply-To: <20080514181257.74fbb5aa@extreme>
References: <20080514170316.672f809d@extreme>
	<20080514181257.74fbb5aa@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device already exists named bonding_masters, then fail. This is a wierd
corner case only a QA group could love.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
Note: bonding is not yet network namespace aware, it will need lots of
work to get this to happen.

--- a/drivers/net/bonding/bond_sysfs.c	2008-05-14 17:49:29.000000000 -0700
+++ b/drivers/net/bonding/bond_sysfs.c	2008-05-14 18:02:36.000000000 -0700
@@ -1437,8 +1437,16 @@ int bond_create_sysfs(void)
 	 * configure multiple bonding devices.
 	 */
 	if (ret == -EEXIST) {
-		netdev_class = NULL;
-		return 0;
+		/* Is someone being kinky and naming a device bonding_master? */
+		if (__dev_get_by_name(&init_net,
+				      class_attr_bonding_masters.attr.name))
+			printk(KERN_ERR
+			       "network device named %s already exists in sysfs",
+			       class_attr_bonding_masters.attr.name);
+		else {
+			netdev_class = NULL;
+			return 0;
+		}
 	}
 
 	return ret;
