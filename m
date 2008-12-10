Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYLJTcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYLJTcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbYLJTcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:32:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:36409 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754795AbYLJTci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:32:38 -0500
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1/4FNF22Ub44McALy6/2et28yxKorggj+t4FmWslZ
	CTorZ3CZXlkvvZ
Message-ID: <4940194A.1030103@gmx.net>
Date: Wed, 10 Dec 2008 20:32:26 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Adam M Belay <abelay@MIT.EDU>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
References: <493D8A1F.2090907@gmx.net> <20081208214910.6l58csoke98gw48w@webmail.mit.edu>
In-Reply-To: <20081208214910.6l58csoke98gw48w@webmail.mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam M Belay wrote:

> Hi Witold,
> 
> All in all your patch looks good, especially in the context of
> resolving the Thinkpad 600X issue.  I have some patches on the
> way that will add more complete power management support to the
> PNP stack and hopefully allow for runtime PM of these system
> devices, but I think this is a good short-term solution.
> 
> One quick comment.  acpi_bus_set_power() can fail, and
> pnpacpi_set_resources() needs to handle this gracefully.  Please
> update the patch to include this.

Hi Adam,

please take a look at my patch at http://lkml.org/lkml/2008/11/23/211,
a "precursor" to the current patch, which contains the required tests
(it, does, however, also remove a comment that Bjorn asked me to keep).
Would that be the type of tests you're thinking of?

--- Witold

> 
> Also, for the follow up to this patch, I'm wondering what sort
> of ACPI behavior we need to support D1 and D2 states.  In PCI,
> disabling resource decoding (similar to _DIS) is only required
> for entering D3.  The ACPI spec seems to be ambiguous with this
> issue.  Len, any thoughts?
> 
> Thanks,
> Adam
> 
> Quoting Witold Szczeponik <Witold.Szczeponik@gmx.net>:
> 
>> Subject: Enable PNPACPI _PSx Support
>>
>>
>> (This is an updated patch of http://lkml.org/lkml/2008/11/23/211)
>>
>> This patch sets the power of PnP ACPI devices to D0 when they
>> are activated and to D3 when they are disabled.  The latter is
>> in correspondence with the ACPI 3.0 specification, whereas the
>> former is added in order to be able to power up a device after
>> it has been previously disabled (or when booting up a system).
>> (As a consequence, the patch makes the PnP ACPI code more ACPI
>> compliant.)
>>
>> Section 6.2.2 of the ACPI Specification (at least versions 1.0b
>> and 3.0a) states: "Prior to running this control method [_DIS],
>> the OS[PM] will have already put the device in the D3 state."
>> Unfortunately, there is no clear statement as to when to put
>> a device in the D0 state. :-( Therefore, the patch executes the
>> method calls as _PS3/_DIS and _SRS/_PS0. What is clear: "If the
>> device is disabled, _SRS enables the device at the specified
>> resources." (From the ACPI 3.0a Specification.)
>>
>> The patch fixes a problem with some IBM ThinkPads (at least the
>> 600E and the 600X) where the serial ports have a dedicated
>> power source that needs to be brought up before the serial port
>> can be used.  Without this patch, the serial port is enabled
>> but has no power. (In the past, the tpctl utility had to be
>> utilized to turn on the power, but support for this feature
>> stopped with version 5.9 as it did not support the more recent
>> kernel versions.)
>>
>> No regressions were observed on hardware that does not require
>> this patch.
>>
>> The patch is applied against 2.6.27.8 (vanilla).
>>
>>
>> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
>>
>>
>> Index: linux/drivers/pnp/pnpacpi/core.c
>> ===================================================================
>> --- linux.orig/drivers/pnp/pnpacpi/core.c
>> +++ linux/drivers/pnp/pnpacpi/core.c
>> @@ -98,17 +98,20 @@ static int pnpacpi_set_resources(struct
>>      status = acpi_set_current_resources(handle, &buffer);
>>      if (ACPI_FAILURE(status))
>>          ret = -EINVAL;
>> +    else
>> +        acpi_bus_set_power(handle, ACPI_STATE_D0);
>>      kfree(buffer.pointer);
>>      return ret;
>>  }
>>
>>  static int pnpacpi_disable_resources(struct pnp_dev *dev)
>>  {
>> +    acpi_handle handle = dev->data;
>>      acpi_status status;
>>
>>      /* acpi_unregister_gsi(pnp_irq(dev, 0)); */
>> -    status = acpi_evaluate_object((acpi_handle) dev->data,
>> -                      "_DIS", NULL, NULL);
>> +    acpi_bus_set_power(handle, ACPI_STATE_D3);
>> +    status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
>>      return ACPI_FAILURE(status) ? -ENODEV : 0;
>>  }
>>
>>
> 
> 


