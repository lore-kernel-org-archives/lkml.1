Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab0CLSlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:41:46 -0500
Received: from mail-yw0-f184.google.com ([209.85.211.184]:51453 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0CLSlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=DxS6tGHd4wrBEM3uNNNFZOsr1iQ8bEgx8PviUPPdGR20Pp2LssXLW16IPuAv0UDryU
         9Vk2yqtjVY+I4JX7Ur0OpIFz0BMdG6hNsaoVuvLokZu+ceTdNAVQ/M+McHsm9NffRX1Z
         9qO4wre8e6tpB03d2Nkaq0XlHKCFIbNAQ038c=
MIME-Version: 1.0
In-Reply-To: <9c7fa61f1003121013j3e4c9c5djb8de244f2e345943@mail.gmail.com>
References: <9c7fa61f1003121013j3e4c9c5djb8de244f2e345943@mail.gmail.com>
Date: Fri, 12 Mar 2010 19:41:42 +0100
Message-ID: <9c7fa61f1003121041r767cd60k4c2297ced36c9f88@mail.gmail.com>
Subject: Fwd: [PATCH] Clear abnormal poweroff flag on VIA southbridges, fix 
	resume
From: Marcus Lell <marcus.lell@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

[please cc me, as I am not subscribed to lkml]

maybe this patch got lost...

>Mon, 19 Jun 2006 23:01:48 -0700
>Andrew Morton wrote:
>
>>On Sun, 18 Jun 2006 20:14:22 +0100
>>Matthew Garrett <[EMAIL PROTECTED]> wrote:
>>
>> Some VIA southbridges contain a flag in the ACPI register space that
>> indicates whether an abnormal poweroff has occured, presumably with the
>> intention that it can be cleared on clean shutdown. Some BIOSes check
>> this flag at resume time, and will re-POST the system rather than jump
>> back to the OS if it's set. Clearing it at boot time appears to be
>> sufficient. I'm not sure if drivers/pci/quirks.c is the right place to
>> do it, but I'm not sure where would be cleaner.
>>
>> Signed-off-by: Matthew Garrett <[EMAIL PROTECTED]>
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 7537260..2f9f996 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -660,6 +660,33 @@ static void __devinit quirk_vt82c598_id(
>>  }
>>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C597_0,
>> quirk_vt82c598_id );
>>
>> +#ifdef CONFIG_ACPI
>> +
>> +/* Some VIA systems boot with the abnormal status flag set. This can
cause
>> + * the BIOS to re-POST the system on resume rather than passing control
>> + * back to the OS. Clear the flag on boot
>> + */
>> +
>> +static void __devinit quirk_via_abnormal_poweroff(struct pci_dev *dev)
>> +{
>> +     u32 reg;
>> +
>> +     acpi_hw_register_read (ACPI_MTX_DO_NOT_LOCK,
ACPI_REGISTER_PM1_STATUS,
>> +                            &reg);
>> +
>> +     if (reg & 0x800) {
>> +             printk ("Clearing abnormal poweroff flag\n");
>> +             acpi_hw_register_write (ACPI_MTX_DO_NOT_LOCK,
>> +                                     ACPI_REGISTER_PM1_STATUS,
>> +                                     (u16)0x800);
>> +     }
>> +}
>> +
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_VIA, PCI_DEVICE_ID_VIA_8235,
>> quirk_via_abnormal_poweroff);
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_VIA, PCI_DEVICE_ID_VIA_8237,
>> quirk_via_abnormal_poweroff);
>> +
>> +#endif
>
>Is CONFIG_ACPI the right thing to use here?  As opposed to, say,
>CONFIG_PM?
>Or CONFIG_ACPI_SLEEP??

I am still (@2010) not able to boot for a suspended (STR) system. my
pc reboots normally
instead of resuming. maybe this patch fixes this.
(I did a 's/register/reg/' in the orginal patch for obvious reasons...)

unfortunately I am not able to port it to 2.6.33, I don't know the kernel api...

I tried to test it, but it doesn't compile on 2.6.24.7 or 2.6.25.20,
but was posted in 2.6.25 time line for sure. (iirc it was based on the
2.6.25-mm2 patch)

as I don't know, what I can do about it, I am posting it here.
I hope, that someone comes in with advises, or better, patches, that
apply to 2.6.33 or 2.6.34-rc1. :-)

of course, I will be very glad to test patches, or will try to port
this patch, thus it is be more unlikely, that I am able to.


marcus lell

--
return to the point of no return._
