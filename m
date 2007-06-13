Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXFMWyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXFMWyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXFMWyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:54:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502AbXFMWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:54:34 -0400
Date: Wed, 13 Jun 2007 15:53:35 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Jay Vosburgh <fubar@us.ibm.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] Fix race condition about network device name allocation
Message-ID: <20070613155335.47111c67@localhost>
In-Reply-To: <20070613094521.GA8860@localdomain>
References: <1178862045.3979.33.camel@kane-linux>
	<20070511092519.1f34ab34@freepuppy>
	<1179130660.3881.23.camel@kane-linux>
	<20070514085840.17a343f7@freepuppy>
	<20070613094521.GA8860@localdomain>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bonding refers to device after unregistering. This has always been
a dangerous thing. The following UNTESTED should fix the problem.

--- a/drivers/net/bonding/bond_sysfs.c	2007-06-13 15:48:37.000000000 -0700
+++ b/drivers/net/bonding/bond_sysfs.c	2007-06-13 15:49:17.000000000 -0700
@@ -164,9 +164,10 @@ static ssize_t bonding_store_bonds(struc
 				printk(KERN_INFO DRV_NAME
 					": %s is being deleted...\n",
 					bond->dev->name);
-				unregister_netdevice(bond->dev);
+
 				bond_deinit(bond->dev);
 		        	bond_destroy_sysfs_entry(bond);
+				unregister_netdevice(bond->dev);
 				rtnl_unlock();
 				goto out;
 			}
