Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXCXJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXCXJEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 05:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbXCXJEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 05:04:45 -0400
Received: from smtpout04-01.prod.mesa1.secureserver.net ([64.202.165.196]:33955
	"HELO smtpout04-02.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932274AbXCXJEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 05:04:44 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Mar 2007 05:04:43 EDT
Message-ID: <4604E7D2.3020704@bristyle.com>
Date: Sat, 24 Mar 2007 01:56:50 -0700
From: Brian Braunstein <brian@bristyle.com>
User-Agent: Icedove 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       rajesh_mish@yahoo.com
Subject: PATCH: tun/tap driver hw address handling
References: <45E6BF26.7080607@bristyle.com> <45E73715.9030909@qualcomm.com>
In-Reply-To: <45E73715.9030909@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Max,

  Here's the patch we discussed at the beginning of the month.

Linus,

  According to Documentation/SubmittingPatches "bug fixes" or "obvious" 
changes
  should CCed to you, so this is why I have done this.

Note: This entire email can be found at
http://bristyle.com/share/patch-tuntap-hw_addr_handling.txt

-----------------------------------------------------------------------------
Patch Description:

  Kernel Version: 2.6.20.4

  Summary:
    Fix tun/tap driver's handling of hw addresses.  Specifically, ensure 
that
    when the tun.dev_addr field is set, the net_device.dev_addr field gets
    set to the same value.

  Background:
    The device hw address is stored in 2 places, in the tun.dev_addr field,
    and of course the net_device struct's dev_addr field.  It really 
seems to
    me that the tun.dev_addr field is redundant, and that anywhere it is 
used
    it would be better to use the net_device.dev_addr field.  However, I do
    not want to start ripping things out of structs that other people might
    be using, so I've left it.

  Fixed Problem:
    The problem was that when one did an IOCTL on the tun/tap device, the
    device address would only get updated in the tun.dev_addr, and not the
    net_device.dev_addr field.  In addition, the initial setting of the
    tun.dev_addr and net_device.addr fields were different.  This meant that
    if you asked the tun/tap device for it's hw address, it would report a
    different value than ifconfig.

  Still Remaining Problem:
    There is a problem with not fixing the redundant tun.dev_addr field
    around.  The problem is that when the net_device.dev_addr gets updated,
    we get no notification of this update.  So if someone changes the 
address
    using "ifconfig hw ether xxxxx", then the net_device.dev_addr and
    tun.dev_addr fields different in value.  Not good.  If you think I 
should
    strip out the tun.dev_addr field and replace it's usage with
    net_device.dev_addr, then I will do that later.  However, I would 
need to
    do a survey to see if anyone else's code outside of tun.c depends on 
this
    field.  If so...I guess I'll just leave it.


--- linux-2.6.20.4-ORIG/drivers/net/tun.c       2007-03-23 
12:52:51.000000000 -0700
+++ linux-2.6.20.4/drivers/net/tun.c    2007-03-24 01:36:59.000000000 -0700
@@ -18,6 +18,11 @@
 /*
  *  Changes:
  *
+ *  Brian Braunstein <linuxkernel@bristyle.com> 2007/03/23
+ *    Fixed hw address handling.  Now net_device.dev_addr is kept 
consistent
+ *    with tun.dev_addr when the address is set by this module.  However,
+ *    changes made to the net_device.dev_addr are still not tracked.
+ *
  *  Mike Kershaw <dragorn@kismetwireless.net> 2005/08/14
  *    Add TUNSETLINK ioctl to set the link encapsulation
  *
@@ -196,7 +201,10 @@ static void tun_net_init(struct net_devi
                dev->set_multicast_list = tun_net_mclist;

                ether_setup(dev);
-               random_ether_addr(dev->dev_addr);
+
+               /* Random address already created for us by tun_set_iff, 
use it */
+               memcpy(dev->dev_addr, tun->dev_addr, 
min(sizeof(tun->dev_addr), sizeof(dev->dev_addr)) );
+
                dev->tx_queue_len = TUN_READQ_SIZE;  /* We prefer our 
own queue length */
                break;
        }
@@ -636,6 +644,7 @@ static int tun_chr_ioctl(struct inode *i
                return 0;

        case SIOCGIFHWADDR:
+               /* Note: the actual net device's address may be different */
                memcpy(ifr.ifr_hwaddr.sa_data, tun->dev_addr,
                                min(sizeof ifr.ifr_hwaddr.sa_data, 
sizeof tun->dev_addr));
                if (copy_to_user( argp, &ifr, sizeof ifr))
@@ -652,7 +661,8 @@ static int tun_chr_ioctl(struct inode *i
                                tun->dev->name,
                                tun->dev_addr[0], tun->dev_addr[1], 
tun->dev_addr[2],
                                tun->dev_addr[3], tun->dev_addr[4], 
tun->dev_addr[5]);
-               return 0;
+               /* Now set the actual net device's address */
+               return dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);

        case SIOCADDMULTI:
                /** Add the specified group to the character device's 
multicast filter


-----------------------------------------------------------------------------

