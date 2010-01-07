Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626Ab0AGC1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0AGC1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302Ab0AGC1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:27:21 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37776 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0AGC1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:27:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X65A/JLGpqqWATm2EHJoC5GZvOK2ARGJl/2IuMvKIeAjujiZLWehJdhrCy9nWvyvSG
         PYhGDwluyOVJ9Mq3sStzpb4+MXaHS0gRGK/L/EMJnWN2skHMbpZY94Aqmt483J2z+yTJ
         Taz9QxAOqPGuty0AXzihv2pS/Gnv8G8hwUWfE=
MIME-Version: 1.0
In-Reply-To: <4B4531F9.3060108@gmail.com>
References: <64bb37e1001060137h597322e8s4305b7cc1c91527e@mail.gmail.com>
	 <4B4531F9.3060108@gmail.com>
Date: Thu, 7 Jan 2010 03:27:15 +0100
Message-ID: <64bb37e1001061827i64ead7f9m3dbe1b7b707c79eb@mail.gmail.com>
Subject: Re: New MSI support in sata_sil24 still broken in 2.6.33-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Mahajan <vivek.mahajan@freescale.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 1:59 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 01/06/2010 03:37 AM, Torsten Kaiser wrote:
>>
>> After activating the MSI support by adding sata_sil24.msi=1 to the
>> kernel command line, the first write to a drive attached to the SiI
>> 3132 controller results in the following errors:
>>
>> [  138.950074] ata2.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x6
>> frozen
>> [  138.961023] ata2.00: failed command: WRITE FPDMA QUEUED
>> [  138.970034] ata2.00: cmd 61/00:00:a5:95:4a/04:00:01:00:00/40 tag 0
>> ncq 524288 out
>> [  138.970037]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
>> 0x4 (timeout)
>
> Looking at the code in sata_sil24 and the SiI3132 datasheet, there's a
> control bit which doesn't seem to be handled in the driver, global control
> register bit 30: "MSI Acknowledge (W). Writing a one to this bit
> acknowledges a Message Signaled Interrupt and permits generation of another
> MSI. This bit is cleared immediately after the acknowledgement is recognized
> by the control logic, hence the bit will always be read as a zero. If all
> interrupt conditions are removed subsequent to an MSI, it is not necessary
> to assert this Acknowledge; another MSI will be generated when an interrupt
> condition occurs."
>
> The way the interrupt handler for this driver works is that we check the
> global IRQ status register, and then based on what ports indicated an
> interrupt in that register, we check the individual port command completion
> registers. The issue would seem to be that if a port got an interrupt
> condition in between these two operations, we'd miss it, and the MSI logic
> described above then wouldn't generate any more interrupts since we didn't
> remove all interrupt conditions.
>
> Can you try this patch and see if it helps? (Might be whitespace damaged but
> hopefully you can apply manually in that case.)

Tried it, but writing still fails:
[   53.467694] XFS mounting filesystem sdb2
[  141.010058] ata2.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x6 frozen
[  141.020361] ata2.00: failed command: WRITE FPDMA QUEUED
[  141.028718] ata2.00: cmd 61/00:00:5d:cd:48/04:00:01:00:00/40 tag 0
ncq 524288 out
[  141.028721]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  141.049895] ata2.00: status: { DRDY }
[  141.056715] ata2.00: failed command: WRITE FPDMA QUEUED
[  141.065133] ata2.00: cmd 61/00:08:5d:c5:48/04:00:01:00:00/40 tag 1
ncq 524288 out
[  141.065135]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  141.086492] ata2.00: status: { DRDY }
[  141.093313] ata2.00: failed command: WRITE FPDMA QUEUED
[  141.101679] ata2.00: cmd 61/00:10:5d:c9:48/04:00:01:00:00/40 tag 2
ncq 524288 out
[  141.101682]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  141.122813] ata2.00: status: { DRDY }
[  141.129522] ata2.00: failed command: WRITE FPDMA QUEUED
[  141.137769] ata2.00: cmd 61/00:18:5d:d1:48/04:00:01:00:00/40 tag 3
ncq 524288 out
[  141.137771]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  141.158660] ata2.00: status: { DRDY }
[  141.165313] ata2: hard resetting link
[  143.370049] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  148.370031] ata2.00: qc timeout (cmd 0xec)
[  148.377198] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  148.386450] ata2.00: revalidation failed (errno=-5)
[  148.394504] ata2: hard resetting link
[  150.600064] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  160.600038] ata2.00: qc timeout (cmd 0xec)
[  160.607451] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  160.616913] ata2.00: revalidation failed (errno=-5)
[  160.625181] ata2: limiting SATA link speed to 1.5 Gbps
[  160.633746] ata2: hard resetting link
[  162.830049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
...

Please note, that in my first report I also mentioned that I get the
same behavior with sata_nv. If I use sata_nv.msi=1 writing to the
drives attached to the MCP55 fail. The sata_nv problem is not new,
that never worked for me, but I only retried it with 2.6.33-rc1.
Other drivers can use MSI successfull (tg3, hda-intel, radeon).

> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 1370df6..d3d8dec 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -102,6 +102,7 @@ enum {
>        HOST_CTRL_STOP          = (1 << 18), /* latched PCI STOP */
>        HOST_CTRL_DEVSEL        = (1 << 19), /* latched PCI DEVSEL */
>        HOST_CTRL_REQ64         = (1 << 20), /* latched PCI REQ64 */
> +       HOST_CTRL_MSIACK        = (1 << 30), /* MSI acknowledge */
>        HOST_CTRL_GLOBAL_RST    = (1 << 31), /* global reset */
>
>        /*
> @@ -1168,6 +1169,7 @@ static irqreturn_t sil24_interrupt(int irq, void
> *dev_instance)
>                                       ": interrupt from disabled port %d\n",
> i);
>                }
>
> +       writel(IRQ_STAT_4PORTS | HOST_CTRL_MSIACK, host_base + HOST_CTRL);
>        spin_unlock(&host->lock);
>  out:
>        return IRQ_RETVAL(handled);
>
