Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbXH0LTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbXH0LTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXH0LTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:19:32 -0400
Received: from dalziel.ucs.ed.ac.uk ([129.215.13.80]:43534 "EHLO
	dalziel.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbXH0LTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:19:31 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
Subject: Re: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Date: Mon, 27 Aug 2007 12:18:17 +0100
User-Agent: KMail/1.9.7
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
References: <94439DDF32D7464A916B5068EFF76B3B0225E6FB@bart.tisolutions.biz>
In-Reply-To: <94439DDF32D7464A916B5068EFF76B3B0225E6FB@bart.tisolutions.biz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708271218.17165.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at dalziel.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007 10:28:09 Dermot Bradley wrote:
[snip]
> Thanks for the help Alistair! One other point you may be able to help
> with - this is the first time I've used a dual core processor and I
> expected that /proc/interrupts would should interrupts distributed
> between both cores whereas they actually seem to be mainly handled by
> the 1st core:
>
>            CPU0       CPU1
>   0:        251          0   IO-APIC-edge      timer
>   1:       2208         11   IO-APIC-edge      i8042
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  16:       5291          3   IO-APIC-fasteoi   ehci_hcd:usb1, eth0
>  17:     223026         13   IO-APIC-fasteoi   ahci
>  18:          0          1   IO-APIC-fasteoi   ohci_hcd:usb2
>  19:          0        126   IO-APIC-fasteoi   ohci_hcd:usb3,
> ohci_hcd:usb5
>  20:          0          2   IO-APIC-fasteoi   ohci_hcd:usb4,
> ohci_hcd:usb6
>  21:     188591          1   IO-APIC-fasteoi   HFC-multi
> NMI:          0          0
> LOC:    3036393    1527288
> ERR:          0
> MIS:          0
>
> Is this to be expected for dual core systems?

I assume that's with irqbalance installed (if not, try installing it). My 
understanding is that not every interrupt can be balanced and it's not always 
valuable to do it. On an Athlon64, there's probably no point.

> I'm currently rebuilding the kernel with the following patch to disable
> NCQ for these drives:
>
> --- linux-2.6.22.5/drivers/ata/libata-core.c    2007-08-23
> 00:23:54.000000000 +0100
> +++ linux-2.6.22.5.new/drivers/ata/libata-core.c        2007-08-27
> 10:25:16.000000000 +0100
> @@ -3788,6 +3788,7 @@
>         /* NCQ is broken */
>         { "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
>         { "Maxtor 6B200M0",     "BANC1B10",     ATA_HORKAGE_NONCQ },
> +        { "WDC WD800BEVS-07",   NULL,          ATA_HORKAGE_NONCQ },
>         /* NCQ hard hangs device under heavier load, needs hard power
> cycle */
>         { "Maxtor 6B250S0",     "BANC1B70",     ATA_HORKAGE_NONCQ },
>         /* Blacklist entries taken from Silicon Image 3124/3132

I've added Jeff to CC in case he's interested about the workaround for this 
drive (I assume you're using the AHCI driver with your ATI controller).

(Dermot's been having problems with his WD drive on an ATI chipset)

> Aug 24 13:55:31 playpbx kernel: ata3.00: exception Emask 0x42 SAct
> 0x7fc77 SErr0x800 action 0x6 frozen
> Aug 24 13:55:31 playpbx kernel: ata3.00: (spurious completions during
> NCQ issue=0x0 SAct=0x7fc77 FIS=004040a1:00000008)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:00:9a:b7:fc/00:00:04:00:00/40 tag 0 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:08:72:ba:fc/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/10:10:f2:bd:fc/00:00:04:00:00/40 tag 2 cdb 0x0 data 8192 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:20:8a:be:fc/00:00:04:00:00/40 tag 4 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:28:12:bf:fc/00:00:04:00:00/40 tag 5 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/10:30:4a:c0:fc/00:00:04:00:00/40 tag 6 cdb 0x0 data 8192 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:50:4a:b5:fc/00:00:04:00:00/40 tag 10 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:58:d2:b5:fc/00:00:04:00:00/40 tag 11 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/10:60:02:b7:fc/00:00:04:00:00/40 tag 12 cdb 0x0 data 8192 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:68:22:b8:fc/00:00:04:00:00/40 tag 13 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/10:70:52:b9:fc/00:00:04:00:00/40 tag 14 cdb 0x0 data 8192 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:78:ea:b9:fc/00:00:04:00:00/40 tag 15 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/10:80:a2:bb:fc/00:00:04:00:00/40 tag 16 cdb 0x0 data 8192 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:88:3a:bc:fc/00:00:04:00:00/40 tag 17 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
> 61/08:90:c2:bc:fc/00:00:04:00:00/40 tag 18 cdb 0x0 data 4096 out
> Aug 24 13:55:31 playpbx kernel:          res
> 40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
> Aug 24 13:55:31 playpbx kernel: ata3: hard resetting port
> Aug 24 13:55:32 playpbx kernel: ata3: SATA link up 1.5 Gbps (SStatus 113
> SControl 300)
> Aug 24 13:55:32 playpbx kernel: ata3.00: configured for UDMA/133
> Aug 24 13:55:32 playpbx kernel: ata3: EH complete
> Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] 156301488 512-byte
> hardware sectors (80026 MB)
> Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00
> 00
> Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Aug 24 13:56:39 playpbx kernel: APIC error on CPU0: 40(40)
> Aug 24 13:57:23 playpbx kernel: APIC error on CPU0: 40(40)
> Aug 24 13:58:08 playpbx last message repeated 2 times
> Aug 24 13:59:52 playpbx kernel: APIC error on CPU0: 40(40)
> Aug 24 14:00:52 playpbx last message repeated 3 times
> Aug 24 14:01:59 playpbx kernel: APIC error on CPU0: 40(40)
> Aug 24 14:02:24 playpbx last message repeated 2 times
> Aug 24 14:03:52 playpbx last message repeated 3 times
> Aug 24 14:05:08 playpbx kernel: APIC error on CPU0: 40(40)
> Aug 24 14:05:17 playpbx kernel: APIC error on CPU0: 40(40)
> Aug 24 14:05:19 playpbx kernel: ata1.00: exception Emask 0x2 SAct
> 0x41ffe SErr 0x0 action 0x2 frozen
> Aug 24 14:05:19 playpbx kernel: ata1.00: (spurious completions during
> NCQ issue=0x0 SAct=0x41ffe FIS=004040a1:00020000)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:08:52:9e:fc/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:10:e2:a2:fc/00:00:04:00:00/40 tag 2 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:18:72:a7:fc/00:00:04:00:00/40 tag 3 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:20:6a:97:fc/00:00:04:00:00/40 tag 4 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:28:0a:ac:fc/00:00:04:00:00/40 tag 5 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:30:62:b2:fc/00:00:04:00:00/40 tag 6 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:38:b2:b4:fc/00:00:04:00:00/40 tag 7 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:40:02:b7:fc/00:00:04:00:00/40 tag 8 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:48:52:b9:fc/00:00:04:00:00/40 tag 9 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:50:a2:bb:fc/00:00:04:00:00/40 tag 10 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:58:f2:bd:fc/00:00:04:00:00/40 tag 11 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:60:2a:87:fc/00:00:04:00:00/40 tag 12 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
> 61/08:90:c2:99:fc/00:00:04:00:00/40 tag 18 cdb 0x0 data 4096 out
> Aug 24 14:05:19 playpbx kernel:          res
> 40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
> Aug 24 14:05:19 playpbx kernel: ata1: soft resetting port
> Aug 24 14:05:20 playpbx kernel: ata1: SATA link up 1.5 Gbps (SStatus 113
> SControl 300)
> Aug 24 14:05:20 playpbx kernel: ata1.00: configured for UDMA/133
> Aug 24 14:05:20 playpbx kernel: ata1: EH complete
> Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] 156301488 512-byte
> hardware sectors (80026 MB)
> Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] Write Protect is off
> Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00
> 00
> Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
