Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZA0POV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZA0POV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZA0POM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:14:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZA0POK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:14:10 -0500
Date: Tue, 27 Jan 2009 16:13:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Subject: [bug] CONFIG_I2C_VIAPRO=y breaks skge
Message-ID: <20090127151359.GA20369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

A -tip testsystem triggered this stuck eth0/skge bug today:

 [   24.787761] skge eth0: enabling interface
 [   24.793177] skge eth0: phy write timeout
 [   24.797035] skge eth0: phy write timeout
 [   24.801019] skge eth0: phy write timeout
 [   24.808325] skge eth0: phy write timeout
 [   24.813019] skge eth0: phy write timeout
 [   24.817019] skge eth0: phy write timeout
 [   24.821131] skge eth0: phy write timeout
 [   24.828610] skge eth0: phy write timeout
 [   24.832834] ADDRCONF(NETDEV_UP): eth0: link is not ready

 [root@centauri ~]# ifconfig 
 eth0     Link encap:Ethernet  HWaddr 00:0C:6E:B3:3D:C6  
          inet addr:10.0.1.22  Bcast:10.0.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:12884901885 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12884901885 errors:0 dropped:0 overruns:0 carrier:4294967295
          collisions:4294967295 txqueuelen:1000 
          RX bytes:18446744073709551615 (1.5 EiB)  TX bytes:18446744073709551615 (1.5 EiB)
          Interrupt:17 

(see the weird stats as well)

after a lengthy .config-bisection session i tracked it down to:

   CONFIG_I2C_VIAPRO=y

if that is disabled, the skge driver works fine and the stats look 
healthy:

eth0      Link encap:Ethernet  HWaddr 00:0C:6E:B3:3D:C6  
          inet addr:10.0.1.22  Bcast:10.0.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:6eff:feb3:3dc6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:837 errors:0 dropped:0 overruns:0 frame:0
          TX packets:767 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:128098 (125.0 KiB)  TX bytes:130996 (127.9 KiB)
          Interrupt:17 

Find below the lspci output - it's a pretty old system. I have not tested 
this system for a long time so the bug might have been there forever.

	Ingo

-------------------->
00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host Bridge (rev 01)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 South]
00:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)
00:0a.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)
00:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
00:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [KT600/K8T800/K8T890 South]
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (rev 01)
01:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (Secondary) (rev 01)
