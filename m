Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXHBSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXHBSiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbXHBShw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:37:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:32931 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbXHBShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:37:51 -0400
Date: Thu, 2 Aug 2007 20:37:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Herbert Rosmanith <kernel@wildsau.enemy.org>, linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <Pine.LNX.4.64.0708021536350.24572@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0708022034190.9319@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
 <46B1D708.9040106@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021536350.24572@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,


I know I have seen my kernel outputting "A renamed to B". Since you two 
however wanted that information in the first place, I grepped a bit 
around, and actually found, (drumroll), that the SUSE kernel has had a 
proper patch for [I can't remember how long] quite some time. (At least 
one distro which does the right thing.) I copied it below.


	Jan
===
Name: patches.suse/nameif-track-rename.patch
Subject: [PATCH] keep track of network interface renaming
From: Olaf Hering <olh@suse.de>

Keep track about which network interface names were renamed after the
network device driver printed its banner. Example insanity:

honeydew:~ # dmesg| grep -Ew '(eth[0-9]|rename|renamed)'
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
dev_change_name: about to rename 'eth3' to 'eth0'
dev_change_name: about to rename 'eth3' to 'ethxx3'
eth3 renamed to ethxx3
dev_change_name: about to rename 'ethxx3' to 'eth0'
dev_change_name: about to rename 'eth0' to 'eth3'
eth0 renamed to eth3
dev_change_name: about to rename 'eth1' to 'eth2'
dev_change_name: about to rename 'eth1' to 'ethxx1'
eth1 renamed to ethxx1
dev_change_name: about to rename 'ethxx1' to 'eth2'
dev_change_name: about to rename 'eth2' to 'eth1'
eth2 renamed to eth1
dev_change_name: about to rename 'ethxx3' to 'eth0'
ethxx3 renamed to eth0
dev_change_name: about to rename 'ethxx1' to 'eth2'
ethxx1 renamed to eth2
e1000: eth0: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex



Signed-off-by: Olaf Hering <olh@suse.de>

 net/core/dev.c |    4 ++++
 1 files changed, 4 insertions(+)

--- linux-2.6.21.orig/net/core/dev.c
+++ linux-2.6.21/net/core/dev.c
@@ -822,7 +822,11 @@ int dev_change_name(struct net_device *d
 	else if (__dev_get_by_name(newname))
 		return -EEXIST;
 	else
+	{
+		if (strncmp(newname, dev->name, IFNAMSIZ))
+			printk(KERN_INFO "%s renamed to %s\n", dev->name, newname);
 		strlcpy(dev->name, newname, IFNAMSIZ);
+	}
 
 	device_rename(&dev->dev, dev->name);
 	hlist_del(&dev->name_hlist);
