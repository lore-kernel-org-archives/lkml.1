Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0BXAjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:39:13 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:35293 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab0BXAjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:39:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CivbbgqH4Z92nYmuEX1WDZ2zNNVqEjfWddM+uw2H6trW1Uo2blDRx50GVefFPsSa+R
         Qc5RmSxiqEtXVexajgnWpWcl46Kb8rRdR81L2vwur0/tvV2EET69HTvCNMb6jA+OUpZI
         syNFKN9zXX9BpMp7ihPaLGc5JTtbioNc2eom4=
MIME-Version: 1.0
In-Reply-To: <1266360399.2257.50.camel@pgudadhe-dt3.nvidia.com>
References: <4B5FC213.1060601@gmail.com>
	 <1266360399.2257.50.camel@pgudadhe-dt3.nvidia.com>
Date: Tue, 23 Feb 2010 18:39:09 -0600
Message-ID: <51f3faa71002231639n52ff7803h818ae82968a1456d@mail.gmail.com>
Subject: Re: [PATCH] ahci: disable FPDMA auto-activate optimization on NVIDIA 
	AHCI
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Mike Cui <cuicui@gmail.com>,
       Peer Chen <pchen@nvidia.com>, Prajakta Gudadhe <pgudadhe@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, ping? Without further input from NVIDIA, I think we may want to
get this in for 2.6.33.

On Tue, Feb 16, 2010 at 4:46 PM, Prajakta Gudadhe <pgudadhe@nvidia.com> wrote:
> We are currently investigating this MCP79 issue when FPDMA auto activate
> feature is enabled. Meanwhile, this patch looks good to me.
>
> --Prajakta Gudadhe
>
> On Tue, 2010-01-26 at 20:33 -0800, Robert Hancock wrote:
>> Mike Cui reported that his system with an NVIDIA MCP79 (aka MCP7A) chipset
>> stopped working with 2.6.32. The problem appears to be that 2.6.32 now enables
>> the FPDMA auto-activate optimization in the ahci driver. The drive works fine
>> with this enabled on an Intel AHCI so this appears to be a chipset bug.
>> Since MCP79 is a fairly recent NVIDIA chipset and we don't have any info on
>> whether any other NVIDIA chipsets have this issue, disable FPDMA AA optimization
>> on all NVIDIA AHCI controllers for now.
>>
>> Should address http://bugzilla.kernel.org/show_bug.cgi?id=14922
>>
>> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
>>
>> ---
>>
>> Mike, can you test this out and make sure this resolves the problem for you?
>>
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index b8bea10..47e57dc 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -3067,8 +3067,16 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>       ahci_save_initial_config(pdev, hpriv);
>>
>>       /* prepare host */
>> -     if (hpriv->cap & HOST_CAP_NCQ)
>> -             pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
>> +     if (hpriv->cap & HOST_CAP_NCQ) {
>> +             pi.flags |= ATA_FLAG_NCQ;
>> +             /* Auto-activate optimization is supposed to be supported on
>> +                all AHCI controllers indicating NCQ support, but it seems
>> +                to be broken at least on some NVIDIA MCP79 chipsets.
>> +                Until we get info on which NVIDIA chipsets don't have this
>> +                issue, if any, disable AA on all NVIDIA AHCIs. */
>> +             if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
>> +                     pi.flags |= ATA_FLAG_FPDMA_AA;
>> +     }
>>
>>       if (hpriv->cap & HOST_CAP_PMP)
>>               pi.flags |= ATA_FLAG_PMP;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> -----------------------------------------------------------------------------------
> This email message is for the sole use of the intended recipient(s) and may contain
> confidential information.  Any unauthorized review, use, disclosure or distribution
> is prohibited.  If you are not the intended recipient, please contact the sender by
> reply email and destroy all copies of the original message.
> -----------------------------------------------------------------------------------
>
