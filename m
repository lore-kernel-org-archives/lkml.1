Return-Path: <linux-kernel-owner+w=401wt.eu-S1764875AbXHFRSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764875AbXHFRSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXHFRSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:18:22 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42726 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781AbXHFRSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:18:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=iO7SqHIUwK4e/NCZw9521TvcuaKLfuEi6bTpPhqXFS54tgajca9VxyA+iaGlt4ZE59XccQb5iKvnmVAO/QzNcVQOtEj4J9uUodPFXEXXEzFF1qRvZBsLURWdQz43oboa;
Message-ID: <46B757D7.4070804@simon.arlott.org.uk>
Date: Mon, 06 Aug 2007 18:18:15 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Joonwoo Park <joonwpark81@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] kexec: fix pci device initialization fail after kexec
 (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com>	 <200708061650.16555.rjw@sisk.pl> <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com>
In-Reply-To: <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/07 16:50, Joonwoo Park wrote:
> 2007/8/6, Rafael J. Wysocki <rjw@sisk.pl>:
>> On Monday, 6 August 2007 15:42, Joonwoo Park wrote:
>> > Hi.
>> > I think that the pci_set_power_state() has bug.
>> > The specification says that some delays is required.
>>
>> And they are in place, AFAICS (from drivers/pci/pci.c):
>>
>>        /* Mandatory power management transition delays */
>>        /* see PCI PM 1.1 5.6.1 table 18 */
>>        if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
>>                msleep(pci_pm_d3_delay);
>>        else if (state == PCI_D2 || dev->current_state == PCI_D2)
>>                udelay(200);
>>
> 
> The problem is occurred when state is 'PCI_D0', so those codes can't cover it.
> But pci pm specification 5.4.1 says that when programmed to D0 the
> equivalent of a warm reset, delay for the duration of the D3hot to D0
> Uninitialized state
> transition (10ms) to pci signal drivers remain disabled is required.
> 
>> > Simon, please can I know whether it works to you?
>> > It is seems to the things are related.
>> >
>> > Joonwoo Park.
>> >
>> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> > index 37c00f6..9f78064 100644
>> > --- a/drivers/pci/pci.c
>> > +++ b/drivers/pci/pci.c
>> > @@ -493,8 +493,14 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>> >    * restore at least the BARs so that the device will be
>> >    * accessible to its driver.
>> >    */
>> > - if (need_restore)
>> > + if (need_restore) {
>> > +   /* The specification also says that "Must ensure that all of
>> > +    * its PCI signal drivers remain disabled for the duration of
>> > +    * the D3hot to D0 Uninitialized state transition".
>> > +    */
>> > +   msleep(10);
>>
>> It's too late for the delay.
>>
> 
> How about this?

It doesn't fix it.

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 37c00f6..974dd04 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -471,6 +471,8 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>                 msleep(pci_pm_d3_delay);
>         else if (state == PCI_D2 || dev->current_state == PCI_D2)
>                 udelay(200);
> +      else if (state == PCI_D0)
> +              msleep(10);
> 
>         /*
>          * Give firmware a chance to be called, such as ACPI _PRx, _PSx
> 
> 
>> >     pci_restore_bars(dev);
>> > + }
>> >
>> >   return 0;
>> >  }

Your patches have spaces everywhere instead of tabs.

-- 
Simon Arlott

