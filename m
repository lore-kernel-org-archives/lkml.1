Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYFTV1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYFTV1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYFTV10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:27:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:37134 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYFTV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mgse806dYP4dBVot6VnO/6kPq38beDBXo5NFWmjzrgRjq3Re3amKE4Tvo8zQGKT+9O
         gFq+f5HZZfDsTbfV37iXeGr+XB99L75m6wQYbXQXnBOGwyGdQb/kD2n/SbZJuLDxN9/w
         z2yTi+fCyQF+cMhn2giDIWI7XVF8lh7PIxbGs=
Message-ID: <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com>
Date: Fri, 20 Jun 2008 23:27:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620135639.GA5073@damson.getinternet.no>
	 <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
	 <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 10:40 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Fri, Jun 20, 2008 at 9:00 PM, Len Brown <lenb@kernel.org> wrote:
>>> @@ -333,6 +333,9 @@ static int __init acpi_rtc_init(void)
>>>  {
>>>       struct device *dev = get_rtc_dev();
>>>
>>> +     if (acpi_disabled)
>>> +             return 0;
>>> +
>>
>> hmm, i would expect dev to be 0 for acpi=off,
>> since pnp_match would fail, no?
>
> Obviously not. Because Ingo is booting with acpi=off and he still gets
> a warning about some mutex operation that originates from this very
> initcall:
>
> [    3.976213] calling  acpi_rtc_init+0x0/0xd3
> [    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread
> F7C50000 could not acquire Mutex [3] [20080321]
>
>

Aha. The device in question (PNP0b00) is discovered while doing
pnpbios_init(), NOT pnpacpi_init:

[    1.712032] initcall pnpacpi_init+0x0/0x80 returned 0 after 3 msecs
[    1.716032] calling  pnpbios_init+0x0/0x322
[    1.720032] PnPBIOS: Scanning system for PnP BIOS support...
[    1.724032] PnPBIOS: Found PnP BIOS installation structure at 0xc00fc550
[    1.728032] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc580, dseg 0xf0000
...
[    1.876032] pnp 00:03: parse allocated resources
[    1.880032] pnp 00:03:   add irq 8 flags 0x0
[    1.884032] pnp 00:03:   add io  0x70-0x71 flags 0x0
[    1.888032] pnp 00:03: parse resource options
[    1.892032] pnp 00:03: new independent option
[    1.896032] device: '00:03': device_add
[    1.900032] bus: 'pnp': add device 00:03
[    1.904032] PM: Adding info for pnp:00:03
[    1.908032] pnp 00:03: Plug and Play BIOS device, IDs PNP0b00 (active)

So I guess this function, pnpbios_init() needs the check as well. In
fact, it has this:

#ifdef CONFIG_PNPACPI
        if (!acpi_disabled && !pnpacpi_disabled) {
                pnpbios_disabled = 1;
                printk(KERN_INFO "PnPBIOS: Disabled by ACPI PNP\n");
                return -ENODEV;
        }
#endif                          /* CONFIG_ACPI */

...I guess that should be changed to say if (acpi_disabled ||
pnpacpi_disabled)? Or... I don't understand the purpose of the
original test. But it seems to be there since the beginning of time
(or, well, v2.6.12-rc2).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
