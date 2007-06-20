Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXFTUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXFTUox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXFTUop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:44:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51089 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXFTUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:44:44 -0400
Date: Wed, 20 Jun 2007 13:44:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>, jengelh@linux01.gwdg.de
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 11/12] pcmcia/net_pcmcia: all net_pcmcia modules depend
 on PCMCIA
Message-Id: <20070620134435.21410ceb.randy.dunlap@oracle.com>
In-Reply-To: <20070619225203.GM5193@alberich.amd.com>
References: <20070619225203.GM5193@alberich.amd.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 00:52:03 +0200 Andreas Herrmann wrote:

> Fix several build errors with PCMCIA=m && NET_PCMCIA=y:
> 
>    LD      .tmp_vmlinux1
>    drivers/built-in.o: In function `nmclan_release':
>    nmclan_cs.c:(.text+0x14026c): undefined reference to `pcmcia_disable_device'
>    ...
>    drivers/built-in.o: In function `exit_xirc2ps_cs':
>    xirc2ps_cs.c:(.exit.text+0x1055): undefined reference to `pcmcia_unregister_driver'
>    make: *** [.tmp_vmlinux1] Error 1

This is interesting.  This is a result of the menuconfig changes,
which made NET_PCMCIA a boolean, and then some tristates depend
on NET_PCMCIA and the boolean -> tristate dependencies aren't
specific enough.

Your fix is one way to do it.  I'd prefer to make
NET_PCMCIA a tristate instead, then let its value trickle down
to the subordinate config symbols.

This probably means that some of the other menuconfig changes
need to be audited for this "feature."


Here is my preferred patch.
~~~~~~~~~~

From: Randy Dunlap <randy.dunlap@oracle.com>

Make NET_PCMCIA a tristate symbol so that net/pcmcia drivers
are constrained to M when needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/pcmcia/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.22-rc5.orig/drivers/net/pcmcia/Kconfig
+++ linux-2.6.22-rc5/drivers/net/pcmcia/Kconfig
@@ -3,14 +3,14 @@
 #
 
 menuconfig NET_PCMCIA
-	bool "PCMCIA network device support"
+	tristate "PCMCIA network device support"
 	depends on PCMCIA
 	---help---
-	  Say Y if you would like to include support for any PCMCIA or CardBus
-	  network adapters, then say Y to the driver for your particular card
-	  below.  PCMCIA- or PC-cards are credit-card size devices often used
-	  with laptops computers; CardBus is the newer and faster version of
-	  PCMCIA.
+	  Say Y or M if you would like to include support for any PCMCIA or
+	  CardBus network adapters, then say Y or M to the driver for your
+	  particular card below.  PCMCIA- or PC-cards are credit-card size
+	  devices often used with laptops computers; CardBus is the newer
+	  and faster version of PCMCIA.
 
 	  To use your PC-cards, you will need supporting software from David
 	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
