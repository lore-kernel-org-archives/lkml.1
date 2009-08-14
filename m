Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZHNVvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZHNVvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZHNVvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:51:35 -0400
Received: from mail.candelatech.com ([208.74.158.172]:41100 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZHNVvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:51:35 -0400
Message-ID: <4A85DC5F.2090600@candelatech.com>
Date: Fri, 14 Aug 2009 14:51:27 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
References: <4A81BDA6.4080804@candelatech.com>	<20090811201206.14556624@lxorguk.ukuu.org.uk>	<4A85CDCF.3060802@candelatech.com>	<20090814221038.19e868a0@lxorguk.ukuu.org.uk>	<4A85D490.6000701@candelatech.com> <20090814223237.1ef61ff1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090814223237.1ef61ff1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 02:32 PM, Alan Cox wrote:
>> Can you give me a clue as to what code needs poking?  I'm working
>> on the latest 31-rc5 tree, btw.
>>
>>
>> PS.  Can't get an ide based 2.6.31-rc5 kernel to boot in F11, though it doesn't seem
>> to be related to ide.  I probably have something wrong in my .config.
>
> Tejun made it all very class based so you have inheriting operations
> structures thus in pata_via.c find
>
> static struct ata_port_operations via_port_ops = {
>          .inherits       =&ata_bmdma_port_ops,
>
> and change it to
>
> static struct ata_port_operations via_port_ops = {
>          .inherits       =&ata_bmdma32_port_ops,
> --


I can't see that it made any difference:

pata_via 0000:00:0f.1: version 0.3.4
pata_via 0000:00:0f.1: PCI->APIC IRQ transform: INT A -> IRQ 20
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe900 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe908 irq 15
ata1.01: CFA: Ridata CF, 20080820, max UDMA/133
ata1.01: 15662304 sectors, multi 0: LBA
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.01: configured for PIO4
scsi 0:0:1:0: Direct-Access     ATA      Ridata CF        2008 PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] 15662304 512-byte logical blocks: (8.01 GB/7.46 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  sda:
sd 0:0:1:0: Attached scsi generic sg0 type 0
  sda1
sd 0:0:1:0: [sda] Attached SCSI disk

[root@lanforge-D0-20 lanforge]# hdparm /dev/sda1

/dev/sda1:
  IO_support    =  0 (default)
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 974/255/63, sectors = 14336000, start = 63


(read speed is still just under 3MB/s)


I used this patch:


diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 45657ca..0a1a3c9 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -420,7 +420,7 @@ static struct scsi_host_template via_sht = {
  };

  static struct ata_port_operations via_port_ops = {
-       .inherits       = &ata_bmdma_port_ops,
+       .inherits       = &ata_bmdma32_port_ops,
         .cable_detect   = via_cable_detect,
         .set_piomode    = via_set_piomode,
         .set_dmamode    = via_set_dmamode,
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index bdd43c7..0085d4a 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -114,7 +114,7 @@ static struct scsi_host_template svia_sht = {
  };

  static struct ata_port_operations svia_base_ops = {
-       .inherits               = &ata_bmdma_port_ops,
+       .inherits               = &ata_bmdma32_port_ops,
         .sff_tf_load            = svia_tf_load,
  };


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

