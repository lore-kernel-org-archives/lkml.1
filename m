Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZIMARb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZIMARb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 20:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZIMARa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 20:17:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZIMAR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 20:17:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=D6QywyY885Q8m+rJpMcACNTMBCmIQq0LefSSzm84PpydOXHU1blcdXHAXtHIPfpfR
	RMpvD0VTs6PkBgMXrHCNQ==
MIME-Version: 1.0
In-Reply-To: <4AABD122.2000400@gmail.com>
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com> 
	<1252721641.28368.34.camel@desktop> <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com> 
	<4AABD122.2000400@gmail.com>
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Sat, 12 Sep 2009 17:17:08 -0700
Message-ID: <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X 
	controllers
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 9:49 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 09/12/2009 04:59 AM, Jung-Ik (John) Lee wrote:
>
> (snip)
>
> Looks mostly reasonable to me, other than a few issues:
>
>> +static void atp867x_set_piomode(struct ata_port *ap, struct ata_device
>> *adev)
>> +{
>> +       struct ata_device *peer = ata_dev_pair(adev);
>> +       struct atp867x_priv *dp = ap->private_data;
>> +       u8 speed = adev->pio_mode;
>> +       struct ata_timing t, p;
>> +       int T, UT;
>> +       u8 b;
>> +
>> +       T = 1000000000 / 33333;
>> +       UT = T/4;
>> +
>> +       switch (speed) {
>> +       case XFER_PIO_4:
>> +       case XFER_PIO_3:
>> +       case XFER_PIO_2:
>> +       case XFER_PIO_1:
>> +       case XFER_PIO_0:
>> +       case XFER_PIO_SLOW:
>> +               break;
>> +       default:
>> +               printk(KERN_WARNING "ATP867X: Unsupported speed %#x."
>> +                       " Default to XFER_PIO_0.\n", (unsigned)speed);
>> +               speed = XFER_PIO_0;
>> +       }
>> +
>> +       ata_timing_compute(adev, speed,&t, T, UT);
>> +       if (peer&&  peer->pio_mode) {
>> +               ata_timing_compute(peer, peer->pio_mode,&p, T, UT);
>> +               ata_timing_merge(&p,&t,&t, ATA_TIMING_8BIT);
>> +       }
>> +
>> +       b = inb(dp->dma_mode);
>> +       if (adev->devno&  1)
>> +               b = (b&  ~ATP867X_IO_DMAMODE_SLAVE_MASK);
>> +       else
>> +               b = (b&  ~ATP867X_IO_DMAMODE_MSTR_MASK);
>> +       outb(b, dp->dma_mode);
>> +
>> +#ifdef ATP867X_NO_HACK_PIOMODE
>> +       b = atp867x_get_active_clocks_shifted(t.active) |
>> +               atp867x_get_recover_clocks_shifted(t.recover);
>> +#else
>> +       /*
>> +        * magic value that works (from doc 6.4, 6.6.9)
>> +        */
>> +       b = 0x31;
>> +#endif
>
> What's the purpose of this ifdef?

The magic value part must go. I'll update the patch.

>
>> +       if (dp->pci66mhz)
>> +               b += 0x10;
>> +
>> +       if (adev->devno&  1)
>> +               outb(b, dp->slave_piospd);
>> +       else
>> +               outb(b, dp->mstr_piospd);
>> +
>> +       /*
>> +        * use the same value for comand timing as for PIO timimg
>> +        */
>> +       outb(b, dp->eightb_piospd);
>> +}
>> +
>> +static int atp867x_cable_detect(struct ata_port *ap)
>> +{
>> +       return ATA_CBL_PATA40_SHORT;
>> +}
>
> Doesn't the controller have a way to do proper 80-wire cable detection?

No programmatic way. libata.force should be used for other configurations.

Thanks,
-John
