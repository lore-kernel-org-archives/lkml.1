Return-Path: <linux-kernel-owner+w=401wt.eu-S934184AbZLGKkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbZLGKkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbZLGKkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:40:00 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:37352 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbZLGKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:39:56 -0500
Message-ID: <4B1CDCE6.5040502@pardus.org.tr>
Date: Mon, 07 Dec 2009 12:45:58 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: scameron@beardog.cce.hp.com, mike.miller@hp.com, jens.axboe@oracle.com
Subject: CCISS performance drop in buffered disk reads in newer kernels
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have 2 HP Proliant DL380G5 server running with different kernels.

I was inspecting a basic kernel-compile time. On the one with 2.6.25.20
kernel, the compilation took ~1.5 minutes. On the one with 2.6.30.9
kernel, it took ~6 minutes. Both systems are using ccache as a build helper.

Then I ran hdparm on both systems, the results are below.

I'd like to help debugging this issue through bisect or another method
but since there are more parameters that differ from one to the other
server than only the kernel version, I'm a little bit stuck.

Thanks,
Ozan



### 2.6.30.9 (Slow one, compiled with PAE support, FS is ext4) ###

# sync; sleep 2; echo 3 > /proc/sys/vm/drop_caches; hdparm -tT -vvvv
/dev/cciss/c0d0p5

/dev/cciss/c0d0p5:
 HDIO_DRIVE_CMD(identify) failed: Invalid exchange
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 245410/255/32, sectors = 2002550382, start = 4225158
 Timing cached reads:   12038 in  2.00 seconds = 6027.00 MB/sec
 Timing buffered disk reads:  184 MB in  3.00 seconds =  61.31
MB/sec             <------ Note the drop here!

# dmesg | grep cciss
[    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT vga=791
splash=silent quiet resume=/dev/cciss/c0d0p1
[    6.023542] cciss 0000:18:08.0: PCI INT A -> GSI 19 (level, low) ->
IRQ 19
[    6.023566] cciss: MSI init failed
[    6.053008] IRQ 19/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.053015] cciss0: <0x3238> at PCI 0000:18:08.0 IRQ 19 using DAC
[    6.053918]  cciss/c0d0: p1 p2 < p5 >
[    6.320852] kjournald2 starting: pid 190, dev cciss!c0d0p5:8, commit
interval 5 seconds
[    6.322344] EXT4-fs: mounted filesystem cciss!c0d0p5 with ordered
data mode
[   10.994505] EXT4 FS on cciss!c0d0p5, internal journal on cciss!c0d0p5:8
[   11.783302] Adding 2112508k swap on /dev/cciss/c0d0p1.  Priority:-1
extents:1 across:2112508k
[   16.696090] JBD: barrier-based sync failed on cciss!c0d0p5:8 -
disabling barriers


### 2.6.25.20 (Fast one, no PAE support, FS is ext3) ###

# sync;sleep 2; echo 3 > /proc/sys/vm/drop_caches; hdparm -tT -vvv
/dev/cciss/c0d0p5

/dev/cciss/c0d0p5:
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 245426/255/32, sectors = 2002678902, start = 4096638
 Timing cached reads:   10650 MB in  2.00 seconds = 5334.38 MB/sec
 Timing buffered disk reads:  420 MB in  3.01 seconds = 139.72 MB/sec

# dmesg | grep cciss
Kernel command line: root=LABEL=PARDUS_ROOT vga=791 splash=silent quiet
resume=/dev/cciss/c0d0p1
cciss0: <0x3238> at PCI 0000:18:08.0 IRQ 212 using DAC
 cciss/c0d0: p1 p2 < p5 >
EXT3 FS on cciss/c0d0p5, internal journal
Adding 2048248k swap on /dev/cciss/c0d0p1.  Priority:-1 extents:1
across:2048248k

