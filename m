Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbYCGGAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbYCGGAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYCGGAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:00:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:45871 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYCGGAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=r23d/+5W89shSLt9eFvHX6SZo465/Gx99OuuW7Xi9ft7+Pk7n/vZ1MncVCg6Zz+qG1YZ0IppvgLdxs2m4fBYEs0uOg5Ebg8mavDy31y26lTPBF08EwjrsS7U1UxnFwfS5rZjCn5tEXtU85SjwQbaZC20N/ZcqO876sfCwlmUI0k=
Message-ID: <59fd4ce80803062200n203e5cd7o152be120adbdb717@mail.gmail.com>
Date: Fri, 7 Mar 2008 15:00:16 +0900
From: "Jeongdo Son" <sohn9086@gmail.com>
To: "Peter Korsgaard" <jacmet@sunsite.dk>,
       "Markus Brunner" <super.firetwister@googlemail.com>
Subject: [BUG REPORT] smc911x: Auto negotiation NOT supported
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SH <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to port smc911x driver for a custom sh4 board,
and I have a problem with static IP adress allocation.
(It is OK for IP address allocation by DHCP.)
Here is brief information about the board.
CPU : SH7780 by Renesas
Ethernet : LAN9115 by SMSC
Kernel version : 2.6.24 from www.kernel.org
Distribution(Userland): BusyBox-1.2.0

The problem is that only the first ifup after cold boot succeed.
Here is the instruction how to reproduce the symptom.
(smc911x is recognized as eth0 on the board.)
1. boot up the board, and login.
2. ifup eth0  (after doing this, ping works)
3. ifdown eth0
4. ifup eth0 ("Auto negotiation NOT supported" printed, and ping doesn't works)
Please refer to the bottom of this mail.

FYI, in the smc911x.h, I modified some macros like the following.
   #define SMC_USE_SH_DMA    1
   #define SMC_USE_16BIT         0
   #define SMC_USE_32BIT         1

There's no change if I turn off SMC_USE_SH_DMA,
but if I turn on SMC_USE_16BIT instead of SMC_USE_32BIT,
the driver occurs OOPS.

I hope this is a known(fixed) issue.

Thanks in advance.
Jeongdo Son
-----------------------------------------
(none) login: root
login[743]: root login  on `ttySC0'

~ $ ifup eth0
eth0: link down
~ $ eth0: link up, 100Mbps, full-duplex, lpa 0x05E1

~ $ ifconfig
eth0      Link encap:Ethernet  HWaddr 00:60:CB:1B:02:25
         inet addr:192.168.40.35  Bcast:192.168.40.255  Mask:255.255.255.0
         UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
         RX packets:24 errors:0 dropped:0 overruns:0 frame:0
         TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000
         RX bytes:3272 (3.1 KiB)  TX bytes:0 (0.0 B)
         Interrupt:9 DMA chan:ff

~ $ ping 192.168.40.255
PING 192.168.40.255 (192.168.40.255): 56 data bytes
64 bytes from 192.168.40.1: icmp_seq=0 ttl=64 time=1.1 ms
64 bytes from 192.168.40.1: icmp_seq=1 ttl=64 time=0.3 ms
64 bytes from 192.168.40.1: icmp_seq=2 ttl=64 time=0.4 ms
64 bytes from 192.168.40.1: icmp_seq=3 ttl=64 time=0.3 ms

--- 192.168.40.255 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.3/0.5/1.1 ms
~ $ ifdown eth0
~ $ ifup eth0
Auto negotiation NOT supported
~ $ ifconfig
eth0      Link encap:Ethernet  HWaddr 00:60:CB:1B:02:25
         inet addr:192.168.40.35  Bcast:192.168.40.255  Mask:255.255.255.0
         UP BROADCAST MULTICAST  MTU:1500  Metric:1
         RX packets:65 errors:0 dropped:0 overruns:0 frame:0
         TX packets:13 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000
         RX bytes:7637 (7.4 KiB)  TX bytes:770 (770.0 B)
         Interrupt:9 DMA chan:ff

~ $ ping 192.168.40.255
PING 192.168.40.255 (192.168.40.255): 56 data bytes

--- 192.168.40.255 ping statistics ---
53 packets transmitted, 0 packets received, 100% packet loss
~ $ ethtool eth0
Settings for eth0:
       Supported ports: [ TP MII ]
       Supported link modes:   10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
       Supports auto-negotiation: Yes
       Advertised link modes:  10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
       Advertised auto-negotiation: Yes
       Speed: 100Mb/s
       Duplex: Full
       Port: MII
       PHYAD: 1
       Transceiver: internal
       Auto-negotiation: on
       Current message level: 0x00000004 (4)
       Link detected: no
~ $
-----------------------------------------
