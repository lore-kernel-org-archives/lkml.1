Return-Path: <linux-kernel-owner+w=401wt.eu-S1030690AbXCCRMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030690AbXCCRMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030689AbXCCRMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:12:24 -0500
Received: from h155.mvista.com ([63.81.120.155]:45797 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030325AbXCCRMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:12:23 -0500
Message-ID: <45E9AC6B.50701@ru.mvista.com>
Date: Sat, 03 Mar 2007 20:12:11 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cmd640: CMD640 PCI support
References: <20070302150306.368e24b9@lxorguk.ukuu.org.uk> <45E8B28D.7030500@garzik.org>
In-Reply-To: <45E8B28D.7030500@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>> +    /* The second channel has shared timings and the setup timing is
>> +       messy to switch to merge it for worst case */
>> +    if (ap->port_no && pair) {
>> +        struct ata_timing p;
>> +        ata_timing_compute(pair, pair->pio_mode, &p, T, 1);
>> +        ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP);
>> +    }
>> +
>> +    /* Make the timings fit */
>> +    if (t.recover > 16) {
>> +        t.active += t.recover - 16;
>> +        t.recover = 16;
>> +    }

    This code makes perfect sense in any driver, BTW... but I'm not sure any 
other drivers have anything alike -- what they do seem to just clamp clock 
count at its maximum...

>> +    if (t.active > 16)
>> +        t.active = 16;

    Erm, clamping active time is not a right thing to do. Right thing to do 
was to bail out. I didn't do it in the legacy driver rewrite though...

>> +
>> +    /* Now convert the clocks into values we can actually stuff into
>> +       the chip */
>> +
>> +    if (t.recover > 1)
>> +        t.recover--;    /* 640B only */
>> +    else
>> +        t.recover = 15;
>> +
>> +    if (t.setup > 4)
>> +        t.setup = 0xC0;
>> +    else
>> +        t.setup = setup_data[t.setup];
>> +
>> +    if (ap->port_no == 0) {
>> +        t.active &= 0x0F;    /* 0 = 16 */
>> +
>> +        /* Load setup timing */
>> +        pci_read_config_byte(pdev, arttim, &reg);
>> +        reg &= 0x3F;
>> +        reg |= t.setup;
>> +        pci_write_config_byte(pdev, arttim, reg);
>> +
>> +        /* Load active/recovery */
>> +        pci_write_config_byte(pdev, arttim + 1, (t.active << 4) | 
>> t.recover);
>> +    } else {
>> +        /* Save the shared timings for channel, they will be loaded
>> +           by qc_issue_prot. Reloading the setup time is expensive 
>> +           so we keep a merged one loaded */
>> +        pci_read_config_byte(pdev, ARTIM23, &reg);

    It's not even expensive, it may be just unsafe.

>> +        reg &= 0x3F;
>> +        reg |= t.setup;
>> +        pci_write_config_byte(pdev, ARTIM23, reg);
>> +        timing->reg58[adev->devno] = (t.active << 4) | t.recover;
>> +    }
>> +}

>> +static int cmd640_init_one(struct pci_dev *pdev, const struct 
>> pci_device_id *id)
>> +{
>> +    u8 r;
>> +    u8 ctrl;
>> +   
>> +    static struct ata_port_info info = {
>> +        .sht = &cmd640_sht,
>> +        .flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
>> +        .pio_mask = 0x1f,

> I-dont-know-the-hardware question:  does this h/w have no DMA support?

    Exactly. :-) The legacy driver used to support PIO5 though.

>> +    static struct ata_port_info *port_info[2] = { &info, &info };
>> +
>> +    /* CMD640 detected, commiserations */
>> +    pci_write_config_byte(pdev, 0x5C, 0x00);

> magic number

   Indeed, completely undocumented. And I don't even see it in the legacy 
driver...

>> +    /* Get version info */
>> +    pci_read_config_byte(pdev, CFR, &r);
>> +    /* PIO0 command cycles */
>> +    pci_write_config_byte(pdev, CMDTIM, 0);
>> +    /* 512 byte bursts (sector) */
>> +    pci_write_config_byte(pdev, BRST, 0x40);
>> +    /* +     * A reporter a long time ago
>> +     * Had problems with the data fifo
>> +     * So don't run the risk
>> +     * Of putting crap on the disk
>> +     * For its better just to go slow
>> +     */
>> +    /* Do channel 0 */
>> +    pci_read_config_byte(pdev, CNTRL, &ctrl);
>> +    pci_write_config_byte(pdev, CNTRL, ctrl | 0xC0);
>> +    /* Ditto for channel 1 */
>> +    pci_read_config_byte(pdev, ARTIM23, &ctrl);
>> +    ctrl |= 0x0C;
>> +    pci_write_config_byte(pdev, ARTIM23, ctrl);

    It's used to be a well known fact (soon after Intel put that chip on their 
motherboards :-) that PCI0640 may return bad data on command block reads if 
another channel has data port I/O going on. That's why the interrupts needed 
to be disabled during PIO in the legacy driver (and the channels serialized).

MBR, Sergei
