Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbZKFTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbZKFTzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759728AbZKFTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:55:20 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:34272 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704AbZKFTzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:55:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AJVL/1UEQNkaZA3NYbTL+oY2ZkpZVxiHsVdd7BU8/vjZE8AkW34dx2kW7zbpFmO7cL
         UOG1017EGncowot1zkFO8ScnP6fXDjaW8gcu3HNQiqT+otgeeWOXF1Tbu7x3wAxWCj1H
         Na26fOEglvbHGVpSBrz2iI0C6e4dYRq0/Xhys=
Message-ID: <4AF47F24.9060903@gmail.com>
Date: Fri, 06 Nov 2009 20:55:16 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 10/41] rt2800pci: add rt2800_register_[read,write]() wrappers
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173313.28463.67108.sendpatchset@localhost.localdomain> <14add3d10911041116q1bb293a9hbd6c5361d59fe588@mail.gmail.com> <200911061713.15898.bzolnier@gmail.com>
In-Reply-To: <200911061713.15898.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/09 17:13, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 04 November 2009 20:16:26 Gertjan van Wingerde wrote:
>> On Wed, Nov 4, 2009 at 6:33 PM, Bartlomiej Zolnierkiewicz
>> <bzolnier@gmail.com> wrote:
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] rt2800pci: add rt2800_register_[read,write]() wrappers
>>>
>>> Part of preparations for later code unification.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>>  drivers/net/wireless/rt2x00/rt2800pci.c |  479 ++++++++++++++++----------------
>>>  drivers/net/wireless/rt2x00/rt2800pci.h |   21 +
>>>  2 files changed, 261 insertions(+), 239 deletions(-)
>>>
>>> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
>>> ===================================================================
>>> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
>>> @@ -57,7 +57,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>>>  /*
>>>  * Register access.
>>>  * All access to the CSR registers will go through the methods
>>> - * rt2x00pci_register_read and rt2x00pci_register_write.
>>> + * rt2800_register_read and rt2800_register_write.
>>>  * BBP and RF register require indirect register access,
>>>  * and use the CSR registers BBPCSR and RFCSR to achieve this.
>>>  * These indirect registers work with busy bits,
>>> @@ -66,6 +66,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>>>  * between each attampt. When the busy bit is still set at that time,
>>>  * the access attempt is considered to have failed,
>>>  * and we will print an error.
>>> + * The _lock versions must be used if you already hold the csr_mutex
>>>  */
>>>  #define WAIT_FOR_BBP(__dev, __reg) \
>>>        rt2x00pci_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
>>
>> The change to the _lock variant seems a bit odd. See below.
>>
>> <snip>
>>
>>> Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
>>> ===================================================================
>>> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
>>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
>>> @@ -27,6 +27,27 @@
>>>  #ifndef RT2800PCI_H
>>>  #define RT2800PCI_H
>>>
>>> +static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
>>> +                                       const unsigned int offset,
>>> +                                       u32 *value)
>>> +{
>>> +       rt2x00pci_register_read(rt2x00dev, offset, value);
>>> +}
>>> +
>>> +static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
>>> +                                        const unsigned int offset,
>>> +                                        u32 value)
>>> +{
>>> +       rt2x00pci_register_write(rt2x00dev, offset, value);
>>> +}
>>> +
>>> +static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
>>> +                                             const unsigned int offset,
>>> +                                             u32 value)
>>> +{
>>> +       rt2x00pci_register_write(rt2x00dev, offset, value);
>>> +}
>>> +
>>>  /*
>>>  * RF chip defines.
>>>  *
>>
>> Can we add a comment to the _lock variant explaining that this one
>> technically isn't
>> needed, but is present for alignment purposes with rt2800usb?
> 
> I couldn't come with the good comment for it so I just went for
> the minimal one in patch #25 (which removed all quoted above inlines):
> 
> +static const struct rt2800_ops rt2800pci_rt2800_ops = {
> +       .register_read          = rt2x00pci_register_read,
> +       .register_write         = rt2x00pci_register_write,
> +       .register_write_lock    = rt2x00pci_register_write, /* same for PCI */
> +
> +       .register_multiread     = rt2x00pci_register_multiread,
> +       .register_multiwrite    = rt2x00pci_register_multiwrite,
> +
> +       .regbusy_read           = rt2x00pci_regbusy_read,
> +};
> 
> but it certainly can be expanded if somebody has a better idea how
> the comment should look like.
> 

OK. Looks good enough for the moment. At least now there is some recognition
that it is not a bug / typo that the _write and _write_lock are the same on PCI.

With this change:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan.
