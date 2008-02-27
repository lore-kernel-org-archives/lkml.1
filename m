Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYB0KEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYB0KEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbYB0KEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:04:23 -0500
Received: from foobar.fi ([81.17.200.65]:33154 "EHLO foobar.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYB0KEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:04:22 -0500
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 05:04:22 EST
Message-ID: <47C52F8D.7020301@bluegiga.com>
Date: Wed, 27 Feb 2008 11:38:21 +0200
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080218)
MIME-Version: 1.0
To: maxk@qualcomm.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] fix RTNL-locking in tun/tap driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current tun/tap driver sets also net device's hw address when asked to
change character device's hw address. This is a good idea, but it
misses RTLN-locking, resulting following error message in
2.6.25-rc3's inetdev_event() function:

RTNL: assertion failed at net/ipv4/devinet.c (1050)

Attached patch fixes this problem.

Signed-off-by: Kim B. Heino <Kim.Heino@bluegiga.com>


--- linux-2.6.25-rc3/drivers/net/tun.c.foo	2008-02-27 10:06:28.000000000 +0200
+++ linux-2.6.25-rc3/drivers/net/tun.c	2008-02-27 10:06:40.000000000 +0200
@@ -663,7 +663,11 @@ static int tun_chr_ioctl(struct inode *i
 	case SIOCSIFHWADDR:
 	{
 		/* try to set the actual net device's hw address */
-		int ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
+		int ret;
+
+		rtnl_lock();
+		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
+		rtnl_unlock();

 		if (ret == 0) {
 			/** Set the character device's hardware address. This is used when
