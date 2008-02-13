Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbYBMK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbYBMK7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYBMK7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:59:11 -0500
Received: from pip12.gyao.ne.jp ([61.122.117.250]:15365 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbYBMK7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:59:10 -0500
Date: Wed, 13 Feb 2008 19:57:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: jkosina@suse.cz, dsterba@suse.cz, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] pcmcia: ipwireless depends on NETDEVICES.
Message-ID: <20080213105752.GA17229@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, jkosina@suse.cz,
	dsterba@suse.cz, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipwireless (added by 099dc4fb62653f6019d78db55fba7a18ef02d65b) is clearly
a net device:

drivers/built-in.o: In function `ipwireless_ppp_start_xmit':
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:165: undefined reference to `skb_under_panic'
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:165: undefined reference to `kfree_skb'
drivers/built-in.o: In function `ipwireless_network_packet_received':
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:377: undefined reference to `__alloc_skb'
/home/pmundt/devel/git/sh-2.6.25/drivers/char/pcmcia/ipwireless/network.c:377: undefined reference to `skb_over_panic'
drivers/built-in.o: In function `ppp_shutdown_interface':
/home/pmundt/devel/git/sh-2.6.25/drivers/net/ppp_generic.c:2517: undefined reference to `unregister_netdev'
/home/pmundt/devel/git/sh-2.6.25/drivers/net/ppp_generic.c:2517: undefined reference to `free_netdev'
[ ... and many more ... ]

select strikes again. ipwireless selects PPP which in turn tries to select
SLHC, both of which are technically "protected" by an if NETDEVICES
in drivers/net/Kconfig. This leads to .config hilarity, with net suddenly
ending up in the SCSI menu:

	#
	# SCSI device support
	#
	# CONFIG_SCSI_DMA is not set
	# CONFIG_SCSI_NETLINK is not set
	CONFIG_PPP=y
	# CONFIG_PHONE is not set

Curiously the SLHC select from PPP doesn't seem to happen, as there's no
CONFIG_SLHC=y (only CONFIG_PPP=y gets set) -- Kconfig bug? Caught with a
randconfig.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/char/pcmcia/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index 00b8a84..ffa0efc 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -45,7 +45,7 @@ config CARDMAN_4040
 
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
-	depends on PCMCIA
+	depends on PCMCIA && NETDEVICES
 	select PPP
 	help
 	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
