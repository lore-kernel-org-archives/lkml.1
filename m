Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbXFNEgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbXFNEgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 00:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXFNEgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 00:36:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38263 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbXFNEgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 00:36:38 -0400
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] Fix race condition about network device name allocation 
In-reply-to: <20070613155335.47111c67@localhost> 
References: <1178862045.3979.33.camel@kane-linux> <20070511092519.1f34ab34@freepuppy> <1179130660.3881.23.camel@kane-linux> <20070514085840.17a343f7@freepuppy> <20070613094521.GA8860@localdomain> <20070613155335.47111c67@localhost>
Comments: In-reply-to Stephen Hemminger <shemminger@linux-foundation.org>
   message dated "Wed, 13 Jun 2007 15:53:35 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Wed, 13 Jun 2007 21:36:30 -0700
Message-ID: <15712.1181795790@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


	The following patch (based on a patch from Stephen Hemminger
<shemminger@linux-foundation.org>) removes use after free conditions in
the unregister path for the bonding master.  Without this patch, an
operation of the form "echo -bond0 > /sys/class/net/bonding_masters"
would trigger a NULL pointer dereference in sysfs.  I was not able to
induce the failure with the non-sysfs code path, but for consistency I
updated that code as well.

	I also did some testing of the bonding /proc file being open
while the bond is being deleted, and didn't see any problems there.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 223517d..6287ffb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4345,8 +4345,8 @@ static void bond_free_all(void)
 		bond_mc_list_destroy(bond);
 		/* Release the bonded slaves */
 		bond_release_all(bond_dev);
-		unregister_netdevice(bond_dev);
 		bond_deinit(bond_dev);
+		unregister_netdevice(bond_dev);
 	}
 
 #ifdef CONFIG_PROC_FS
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index a122baa..60cccf2 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -164,9 +164,9 @@ static ssize_t bonding_store_bonds(struct class *cls, const char *buffer, size_t
 				printk(KERN_INFO DRV_NAME
 					": %s is being deleted...\n",
 					bond->dev->name);
-				unregister_netdevice(bond->dev);
 				bond_deinit(bond->dev);
 		        	bond_destroy_sysfs_entry(bond);
+				unregister_netdevice(bond->dev);
 				rtnl_unlock();
 				goto out;
 			}
