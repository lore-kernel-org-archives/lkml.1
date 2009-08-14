Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZHNUt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZHNUt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZHNUt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:49:26 -0400
Received: from mail.candelatech.com ([208.74.158.172]:36173 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZHNUtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:49:25 -0400
Message-ID: <4A85CDCF.3060802@candelatech.com>
Date: Fri, 14 Aug 2009 13:49:19 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
References: <4A81BDA6.4080804@candelatech.com> <20090811201206.14556624@lxorguk.ukuu.org.uk>
In-Reply-To: <20090811201206.14556624@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 12:12 PM, Alan Cox wrote:
> On Tue, 11 Aug 2009 11:51:18 -0700
> Ben Greear<greearb@candelatech.com>  wrote:
>
>> I'm trying to use Fedora 11 with default kernel on an old via system
>> that boots from compact flash.  DMA is not supported on the CF for
>> whatever reason, and in previous kernels, I've always disabled
>> DMA, first with ide=nodma, and then later with
>> ide_core.nodma=0.0 ide_core.nodma=0.1 ...
>
> Fedora switched to libata some releases ago so
>
> libata.dma=n
>
> 0 - off
> 1 - disk only
>
> + 2 disk/CD
> + 4 disk/CD/CFA
>
> (so you can turn DMA off just for CFA devices providing they admit they
> are CFA)


This worked fine, but now I'm having some more issues.  Using libata is 1/2
as fast as using IDE mode.  I *think* the problem might be that libsata
may not be using 32-bit PIO mode, but I'm not certain of that.  It seems
that ide mode uses PIO2 v/s PIO4 for libsata too.

I'm going to try configuring a .31 kernel with ide instead of libsata.
In case it helps anyone, here are more more details:


On Fedora 8, using a 2.6.29-6 kernel compiled for ide instead of libata,
I get about 6MB/s read (according to hdparm -t).

[root@lanforge-D0-20 lanforge]# hdparm -tT /dev/hdb1

/dev/hdb1:
  Timing cached reads:   460 MB in  2.00 seconds = 230.00 MB/sec
  Timing buffered disk reads:   18 MB in  3.24 seconds =   5.56 MB/sec
[root@lanforge-D0-20 lanforge]# hdparm -tT /dev/hdb1

/dev/hdb1:
  Timing cached reads:   460 MB in  2.00 seconds = 229.78 MB/sec
  Timing buffered disk reads:   18 MB in  3.23 seconds =   5.57 MB/sec

dmesg output:
Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:0f.1: VIA vt8237 (rev 00) IDE UDMA133
via82cxxx 0000:00:0f.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:0f.1: not 100% native mode: will probe irqs later
ide: disallowing DMA for hda
ide: disallowing DMA for hdb
     ide0: BM-DMA at 0xe900-0xe907
     ide1: BM-DMA at 0xe908-0xe90f
Probing IDE interface ide0...
hdb: Ridata CF, CFA DISK drive
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO2
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO2
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hdb: max request size: 128KiB
hdb: 15662304 sectors (8019 MB) w/1KiB Cache, CHS=15538/16/63
  hdb: hdb1


[root@lanforge-D0-20 lanforge]# hdparm /dev/hdb1

/dev/hdb1:
  multcount     =  0 (off)
  IO_support    =  1 (32-bit)
  unmaskirq     =  1 (on)
  using_dma     =  0 (off)
  keepsettings  =  0 (off)
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 15538/16/63, sectors = 3887667, start = 63



On F11, using a kernel compiled for libata, I'm getting about 1/2 that
speed.  I get similar results for a 2.6.31-rc5 kernel and the official
F11 2.6.29-6-ish kernel.  I also get similar results on FC8 with the
default FC8 2.6.26 kernel (using libsata).


Gscsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe900 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe908 irq 15
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
ata1.01: CFA: Ridata CF, 20080820, max UDMA/133
ata1.01: 15662304 sectors, multi 0: LBA
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.01: configured for PIO4
scsi 0:0:1:0: Direct-Access     ATA      Ridata CF        2008 PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] 15662304 512-byte hardware sectors: (8.01 GB/7.46 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sda] 15662304 512-byte hardware sectors: (8.01 GB/7.46 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1
sd 0:0:1:0: [sda] Attached SCSI disk
sd 0:0:1:0: Attached scsi generic sg0 type 0


[root@lanforge-D0-20 ~]# hdparm /dev/sda1

/dev/sda1:
  IO_support    =  0 (default)
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 974/255/63, sectors = 14336000, start = 63


[root@lanforge-D0-20 ~]# hdparm -Tt /dev/sda1

/dev/sda1:
  Timing cached reads:   280 MB in  2.00 seconds = 139.98 MB/sec
  Timing buffered disk reads:   10 MB in  3.69 seconds =   2.71 MB/sec


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

