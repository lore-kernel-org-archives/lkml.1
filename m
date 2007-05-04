Return-Path: <linux-kernel-owner+w=401wt.eu-S1423020AbXEDTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423020AbXEDTUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423037AbXEDTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:20:41 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43325 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423020AbXEDTUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:20:39 -0400
Date: Fri, 4 May 2007 21:19:01 +0200 (MEST)
Message-Id: <200705041919.l44JJ15g009202@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: jirislaby@gmail.com
Subject: Re: 2.6.21-mm1: many processes end up in D state
Cc: akpm@osdl.org, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, mikpe@it.uu.se, stable@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 17:02:10 +0200, Jiri Slaby wrote:
>>>> I have a problem with higher disk loads (e.g. running git-log or yum update).
>>>> Many processes end up in D state and system is unusable -- I'm not able to run
>>>> anything but smooth mouse moving when this happens.
...(boring stack dumps deleted)
>> causes this? When I change this:
>> diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
>> index f56549b..a0024ae 100644
>> --- a/drivers/ata/sata_promise.c
>> +++ b/drivers/ata/sata_promise.c
>> @@ -668,10 +668,8 @@ static inline unsigned int pdc_host_intr( struct ata_port *ap,
>>         else
>>                 err_mask &= ~PDC2_ERR_MASK;
>>         port_status = readl(port_mmio + PDC_GLOBAL_CTL);
>> -       if (unlikely(port_status & err_mask)) {
>> +       if (unlikely(port_status & err_mask))
>>                 pdc_error_intr(ap, qc, port_status, err_mask);
>> -               return 1;
>> -       }
>> 
>>         switch (qc->tf.protocol) {
>>         case ATA_PROT_DMA:
>> the problem disappears.
>Actually changes:
>ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>ata6.00: (port_status 0x20080000)
>ata6.00: cmd c8/00:08:03:d3:61/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>         res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x6 (timeout)
>ata6: soft resetting port
>ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>ata6.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
>ata6.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
>ata6.00: configured for UDMA/133
>ata6: EH complete
>sd 5:0:0:0: [sdc] 156301488 512-byte hardware sectors (80026 MB)
>sd 5:0:0:0: [sdc] Write Protect is off
>sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
>or FUA
>
>
>to
>ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
>ata5.00: (port_status 0x20080000)
>ata5.00: cmd c8/00:08:bf:cd:4b/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>         res 50/00:00:c6:cd:4b/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
>ata5: soft resetting port
>ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>ata5.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
>ata5.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
>ata5.00: configured for UDMA/133
>ata5: EH complete
>sd 4:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
>sd 4:0:0:0: [sdb] Write Protect is off
>sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
>or FUA
>
>
>I.e. no freezing of ports...

Your patch to delete the 'return 1;' on error is correct,
and makes the code match exactly the behaviour of previous
versions of sata_promise, except for the additional error
decoding.

ahci and sata_sil24 do the return in this situation. I don't
yet understand why they can get away with it while sata_promise
cannot, but for now the return should be removed.

/Mikael
