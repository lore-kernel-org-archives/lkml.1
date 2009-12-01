Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZLAUk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZLAUk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZLAUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:40:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:41497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZLAUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:40:55 -0500
Message-ID: <4B157F23.4040701@kernel.org>
Date: Tue, 01 Dec 2009 12:40:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32	registers
References: <20091130214954.10845.23072.stgit@debian.lart> <20091201000332.GD24539@lackof.org> <20091201001942.GF24539@lackof.org> <1259640654.10482.44.camel@2710p.home> <20091201195523.GA16534@lackof.org>
In-Reply-To: <20091201195523.GA16534@lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Mon, Nov 30, 2009 at 09:10:54PM -0700, Alex Williamson wrote:
>> On Mon, 2009-11-30 at 17:19 -0700, Grant Grundler wrote:
>>> On Mon, Nov 30, 2009 at 05:03:32PM -0700, Grant Grundler wrote:
>>>> On Mon, Nov 30, 2009 at 02:51:44PM -0700, Alex Williamson wrote:
>>>>> Prior to 1f82de10 we always initialized the upper 32bits of the
>>>>> prefetchable memory window, regardless of the address range used.
>>>>> Now we only touch it for a >32bit address, which means the upper32
>>>>> registers remain whatever the BIOS initialized them too.
>>>>>
>>>>> It's valid for the BIOS to set the upper32 base/limit to
>>>>> 0xffffffff/0x00000000, which makes us program prefetchable ranges
>>>>> like 0xffffffffabc00000 - 0x00000000abc00000
>>>>>
>>>>> Revert the chunk of 1f82de10 that made this conditional so we always
>>>>> write the upper32 registers and remove now unused pref_mem64 variable.
>>>>>
>>>>> Signed-off-by: Alex Williamson <alex.williamson@hp.com>
>>>> Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
>>> NAK this - I messed up. Yinghai is correct. Something else is going on.
>>>
>>> It might be perfectly OK to read 0xffffffffabc00000 if the bridge
>>> isn't using the upper32 Prefetchable register. Maybe the problem is
>>> some code is reading the upper32 value without checking that it's valid?
>> Apologies for not threading the v2 patch into the original thread.  The
>> prefetchable base register does support the upper32 bits and it does
>> work correctly.  However per the pci-to-pci bridge spec, a little lower
>> on page 47, devices only supporting 32bit prefetchable ranges are to
>> implement the upper32 registers as read-only registers that return zero.
>> In the example above, -1 in the upper32 base simply means that base >
>> limit, which disables the range.
>>
>> Further investigation shows that the MEM_64 resource flag is setup for
>> this range based on hardware capabilities, but then it gets removed in
>> pbus_size_mem() because we want to use the range to map a 32bit option
>> ROM.  This leaves us entering pci_setup_bridge() with -1 in the upper32
>> base and the MEM_64 flag clear, so we never touch the upper32 base
>> register.  I think this patch is still a simple, safe solution.  Thanks,
> 
> Yup - after reading the PCI-PCI spec a 3rd time. I have to agree.
> Alex, sorry for the flip flopping. Pre-2.6.30 code was clearly working.
> Please add:
>   Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
> 
> I assumed Yinghai's objection was based on a specific problem he had
> seen with writing upper32 register. Bjorn asked the right question.
> If there isn't a specific problem, I'd prefer AW's simpler patch.

we just should not touch that register if the HW only support 32bit pref mmio.

> 
> I'm also thinking the resource allocation design which uses resource
> flags to indicate resources assigned (e.g a resource is 32-bit) rather
> than HW attributes is broken. We should be able to allocate 32-bit Option
> ROM into a 64-bit prefetchable MMIO window that is programmed with upper32
> as zeros without changing the resource type. The resource allocation
> code only be looking at Resource "Type" when (re)programming
> window registers. The rest of the time (programming BARs) should be
> able to just test "if it fits".

IORESOURCE_MEM_64 is the flags that the resource could be assigned to >4g range.
so it is NOT assigned resource ...

YH
