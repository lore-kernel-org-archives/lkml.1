Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYEHL2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYEHL2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYEHL2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:28:22 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:27335 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751168AbYEHL2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:28:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 07:28:19 EDT
X-Nifty-SrcIP: [202.219.216.120]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=T3/kzxzMlSnxLStT+/8Sa379gzel39CNZxTYJCAFchB+M6o94rcYJ6g/G5DzwSbCfXUiIl+qdMP4jm/1uwOfPg==  ;
Date: Thu, 08 May 2008 16:58:14 +0900 (JST)
Message-Id: <20080508.165814.197343623.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 2.6.25 with ide driver cs5520 does not boot.
From: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_May__8_16_58_14_2008_531)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Thu_May__8_16_58_14_2008_531)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

HI, all.
(please CC to me, I'm not on LKML)

kernel 2.6.25 with ide driver cs5520 does not boot.
Attached part of dmesgs as dmesgs.txt

kernel 2.6.23 with cs5520 is works correct. cs5520 scans ide0 and ide1.
kernel 2.6.24 with cs5520 is works wrong, but it can boot. cs5520 scans ide0 only.
kernel 2.6.25 with cs5520 is works wrong, it cannot boot. 
kernel 2.6.25 with ide-generic(CONFIG_IDE_GENERIC=y) is works correct.

cs5520 of 2.6.24 recognize access mode for hda as DMA. In 2.6.25 as DMA and PIO.
Summaries are:

                  DMA/PIO     ide1              boot
    2.6.18          DMA       found              OK
    2.6.19          pio       found              OK
    2.6.20          pio       found              OK
    2.6.21          pio       found              OK
    2.6.22          pio       found              OK
    2.6.23          pio       found              OK
    2.6.24          DMA       conflict IO ports  OK
    2.6.25      DMA and PIO   found              hang
    2.6.25(ide)    (PIO?)     found              OK

Threre are 2 in timing to hang. When system hangs, The access LED of HDD turning on. 
In addigion, I mind that an access mode is PIO, and it is DMA.

Timing to hangs are:
1:
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
  (system hangs)

2:
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 58605120 sectors (300005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
  (system hangs)

The pattern 1, I invested with printk() and I guess that system hangs at
  idedisk_setup()
    init_idedisk_capacity()
      idedisk_chech_hpa()
        idedisk_read_native_max_address()
          ide_no_data_taskfile()
            ide_raw_taskfile()
              ide_do_drive_cmd()  <-- did not return


The pattern 2, I guess that
  idedisk_setup()
    write_cache()
     update_ordered()
       blk_queue_ordered()  <-- I confirm reached here


----Next_Part(Thu_May__8_16_58_14_2008_531)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dmesgs.txt"

  * in kernel 2.6.23 with cs5520
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller at PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:pio, hdb:DMA
    ide1: BM-DMA at 0x5008-0x500f, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
Clocksource tsc unstable (delta = -214979047 ns)
Time: pit clocksource has been installed.
hda: IC25N030ATCS04-0, ATA DISK drive
PIO clocking = 4
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 58605120 sectors (30005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3

  * in kernel 2.6.24 with cs5520
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller (0x1078:0x0002 rev 0x00) at  PCI slot 0000:00:12.0
PCI: Setting latency timer of device 0000:00:12.0 to 64
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0x5000-0x5007 -- Error, ports in use.
Probing IDE interface ide0...
hda: IC25N030ATCS04-0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 58605120 sectors (30005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3

  * in kernel 2.6.25 with cs5520, 4 patterns
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller (0x1078:0x0002 rev 0x00) at  PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0x5008-0x500f, BIOS settings: hdd:DMA, hdd:DMA
Clocksource tsc unstable (delta = -205934842 ns)
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
  (system hangs)

Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller (0x1078:0x0002 rev 0x00) at  PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0x5008-0x500f, BIOS settings: hdd:DMA, hdd:DMA
Clocksource tsc unstable (delta = -205934842 ns)
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 58605120 sectors (300005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
  (system hangs)

Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller (0x1078:0x0002 rev 0x00) at  PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:PIO, hdb:DMA
    ide1: BM-DMA at 0x5008-0x500f, BIOS settings: hdd:PIO, hdd:DMA
Clocksource tsc unstable (delta = -212338808 ns)
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
  (system hangs)

Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller (0x1078:0x0002 rev 0x00) at  PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:PIO, hdb:DMA
    ide1: BM-DMA at 0x5008-0x500f, BIOS settings: hdd:PIO, hdd:DMA
Clocksource tsc unstable (delta = -212338808 ns)
hda: IC25N030ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 58605120 sectors (300005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
  (system hangs)

  * in kernel 2.6.25 with IDE generic
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: IC25N030ATCS04-0, ATA DISK drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 58605120 sectors (30005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3

----Next_Part(Thu_May__8_16_58_14_2008_531)----
