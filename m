Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXIZQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXIZQuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXIZQuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:50:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52067 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbXIZQuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:50:11 -0400
X-Greylist: delayed 1167 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 12:50:10 EDT
Date: Wed, 26 Sep 2007 19:30:41 +0300 (EEST)
From: Timo Jantunen <jeti@welho.com>
To: Francois Romieu <romieu@fr.zoreil.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send
 performance
Message-ID: <Pine.LNX.4.64.0709261853110.5869@limbo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heip!

(commit: "r8169: merge with version 6.001.00 of Realtek's r8169 driver")


In current 2.6.23-rc8 snapshot r8169 send performance is bad, around 
32MB/s. In 2.6.22 it was around 83MB/s. Interestingly, the receive 
performance has increased from around 85MB/s to 96MB/s at the same time!


Git bisect gave commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 as the 
culprit, and reverting it from the 2.6.23-rc8 increases send speed back to 
.22 level. (It didn't revert cleanly and the file needed some cleaning up 
by hand.)


Performance data:

(The other end of iperf is machine with kernel 2.6.22.6 and nForce3 
built-in nic.)

2.6.22 (and 2.6.23-rc8 with that change reverted)
===cut
$ iperf -m -l32k -c gw -r
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Client connecting to gw, TCP port 5001
TCP window size: 64.0 KByte (default)
------------------------------------------------------------
[  5] local 10.0.0.1 port 36068 connected with 10.0.0.254 port 5001
[  5]  0.0-10.0 sec    832 MBytes    696 Mbits/sec
[  5] MSS size 7148 bytes (MTU 7188 bytes, unknown interface)
[  4] local 10.0.0.1 port 5001 connected with 10.0.0.254 port 59713
[  4]  0.0-10.2 sec    825 MBytes    678 Mbits/sec
[  4] MSS size 7148 bytes (MTU 7188 bytes, unknown interface)

$ vmstat 2
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1960780   2948  32948    0    0   236    11   48  327  2  3 86  9
 0  0      0 1960660   2948  32972    0    0     0     0   94  944  0  0 100  0
 0  0      0 1960752   2952  32996    0    0    14     0   90  233  0  0 100  0
 0  0      0 1960776   2952  32996    0    0     0     0   89  964  0  0 100  0
 1  0      0 1959544   3044  33788    0    0   420    52  154  458  0  1 97  2
 0  0      0 1940288   3080  34704    0    0   434    34 16075 2198  0  2 98  0
 0  0      0 1940116   3080  34704    0    0     0     0 16464 2835  0  1 99  0
 0  0      0 1940020   3080  34704    0    0     0    58 16590 2194  0  1 99  0
 0  0      0 1940316   3080  34704    0    0     0     0 16489 2887  0  1 99  0
 0  0      0 1940268   3080  34704    0    0     0     0 16505 2990  0  1 99  0
 0  0      0 1957936   3080  34704    0    0     0     4 23482 24903  0  2 98  0
 0  0      0 1957720   3080  34704    0    0     0     0 24270 29139  0  2 98  0
 0  0      0 1957980   3080  34704    0    0     0     4 22045 27621  0  2 98  0
 1  0      0 1958004   3080  34704    0    0     0     0 24383 30106  0  2 98  0
 0  0      0 1957956   3080  34704    0    0     0     0 21984 27709  0  2 98  0
 0  0      0 1958112   3080  34704    0    0     0     0 3083 5826  0  0 100  0
 0  0      0 1958168   3080  34704    0    0     0     0   83 2392  0  0 100  0
===cut


2.6.23-rc8 without changes
===cut
$ iperf -m -l32k -c gw -r
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Client connecting to gw, TCP port 5001
TCP window size: 73.0 KByte (default)
------------------------------------------------------------
[  5] local 10.0.0.1 port 55265 connected with 10.0.0.254 port 5001
[  5]  0.0-10.1 sec    328 MBytes    272 Mbits/sec
[  5] MSS size 7148 bytes (MTU 7188 bytes, unknown interface)
[  4] local 10.0.0.1 port 5001 connected with 10.0.0.254 port 41340
[  4]  0.0-10.0 sec    964 MBytes    805 Mbits/sec
[  4] MSS size 7148 bytes (MTU 7188 bytes, unknown interface)

$ vmstat 2
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1961244   3756  31580    0    0   292    13   52  331  2  4 84 10
 0  0      0 1959916   3756  32368    0    0   436     0  186  893  0  0 99  0
 0  0      0 1944668   3756  32504    0    0     0     0 7141 2223  0  2 98  0
 0  0      0 1948260   3756  32504    0    0     0     0 7012 2213  0  2 98  0
 1  0      0 1946532   3756  32504    0    0     0     0 7001 2222  0  1 99  0
 1  0      0 1942276   3756  32504    0    0     0     0 6996 2168  0  2 98  0
 1  0      0 1943336   3756  32504    0    0     0     0 6946 2181  0  0 100  0
 2  0      0 1959144   3848  33296    0    0   420    52 19020 24412  0  2 96  2
 1  0      0 1959064   3884  33344    0    0     0    82 21825 30835  0  3 97  0
 0  0      0 1959152   3884  33344    0    0     0     0 21816 32094  0  2 98  0
 0  0      0 1959040   3884  33344    0    0     0     6 21850 31934  0  3 96  0
 2  0      0 1959072   3884  33344    0    0     0     0 21812 32068  0  2 98  0
 0  0      0 1959104   3884  33344    0    0     0     0 5247 9402  0  1 99  0
===cut


lspci
===cut
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI Express Root Port (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc R580 [Radeon X1900]
01:00.1 Display controller: ATI Technologies Inc Unknown device 7264
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
04:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
===cut

lspci -vx, only eth0 device
===cut
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
	Subsystem: ABIT Computer Corp. Unknown device 1083
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
	I/O ports at ae00 [size=256]
	Memory at fdcff000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at fdb00000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
00: ec 10 67 81 07 00 b0 02 10 00 00 02 08 20 00 00
10: 01 ae 00 00 00 f0 cf fd 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 7b 14 83 10
30: 00 00 00 00 dc 00 00 00 00 00 00 00 07 01 20 40
===cut


parts of .config (full .config available on request)
===cut
CONFIG_NO_HZ=y
CONFIG_HZ=1000
CONFIG_R8169=y
CONFIG_R8169_NAPI=y
===cut

I also tried with CONFIG_R8169_NAPI=n but that didn't make a difference.

ethtool -k eth0
===cut
Offload parameters for eth0:
Cannot get device udp large send offload settings: Operation not supported
rx-checksumming: on
tx-checksumming: on
scatter-gather: off
tcp segmentation offload: off
udp fragmentation offload: off
generic segmentation offload: off
===cut

I tried also other combinations. scatter-gather caused small performance 
penalty, as well as not using jumbo frames (7200). Other settings didn't 
matter.


//T
