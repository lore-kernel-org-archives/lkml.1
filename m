Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZBKFFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZBKFFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 00:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZBKFFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 00:05:24 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:21160 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZBKFFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 00:05:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sLr+kZGz0BMERB+igzj/oCmf9uxEDpqCF+yyX2H1q2xf/Q+dChH4Lh/J56OKh1fEMR
         68eIUwzbwC2eAl8ZIsBXBvGwVtgDEY0T72h+C8frlrU0h1f1ly6sBgjCGKOs174M+MV3
         AEGYV5O/s/zQOGYfOyUR5Zit1s277cSJn7/Sg=
MIME-Version: 1.0
In-Reply-To: <9ae48b020902101457o575f8eb0qa72120efea521c46@mail.gmail.com>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A206A.2070309@kernel.org>
	 <4990DF7C.1090701@kernel.org> <4990DFBA.1050401@kernel.org>
	 <9ae48b020902101457o575f8eb0qa72120efea521c46@mail.gmail.com>
Date: Tue, 10 Feb 2009 21:05:21 -0800
X-Google-Sender-Auth: 4d9add9a66ecaae3
Message-ID: <86802c440902102105w332e496h412733437ca4352d@mail.gmail.com>
Subject: Re: Subject: [PATCH] x86/pci: Detect mmconfig on nVidia MCP55 -v2
From: Yinghai Lu <yinghai@kernel.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: jbarnes@virtuousgeek.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 2:57 PM, Ed Swierk <eswierk@aristanetworks.com> wrote:
> On Mon, Feb 9, 2009 at 6:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> From: Ed Swierk <eswierk@aristanetworks.com>
>>
>> Detect and enable memory-mapped PCI configuration space on the nVidia
>> MCP55 southbridge.  Tested against 2.6.27.4 on an Arista Networks
>> development board with one MCP55, Coreboot firmware, no ACPI.
>>
>> v2: add multi mcp55 support, and conexist with amd quad core system by Yinghai
>>    also only enable it only when acpi=off or acpi is not built-in
>>
>> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
>
> A couple of comments below. Let me test this version before signing off.
>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/pci/mmconfig-shared.c |   64 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 64 insertions(+)
>>
>> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
>> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
>> @@ -166,6 +166,68 @@ static const char __init *pci_mmcfg_amd_
>>        return "AMD Family 10h NB";
>>  }
>>
>> +static bool __initdata mcp55_checked;
>> +static const char __init *pci_mmcfg_nvidia_mcp55(void)
>> +{
>> +       int bus;
>> +       int mcp55_mmconf_found = 0;
>> +
>> +       static const u32 extcfg_regnum          = 0x90;
>> +       static const u32 extcfg_regsize         = 4;
>> +       static const u32 extcfg_enable_mask     = 1<<31;
>> +       static const u32 extcfg_start_mask      = 0xff<<16;
>> +       static const int extcfg_start_shift     = 16;
>> +       static const u32 extcfg_size_mask       = 0x3<<28;
>> +       static const int extcfg_size_shift      = 28;
>> +       static const int extcfg_sizebus[]       = {0x100, 0x80, 0x40, 0x20};
>> +       static const u32 extcfg_base_mask[]     = {0x7ff8, 0x7ffc, 0x7ffe, 0x7fff};
>> +       static const int extcfg_base_lshift     = 25;
>> +
>> +       /*
>> +        * do check if amd fam10h already took over
>> +        */
>> +       if (!acpi_disabled || pci_mmcfg_config_num || mcp55_checked)
>> +               return NULL;
>
> Why skip this if !acpi_disabled? I thought we want to have the host
> bridge mmconfig settings override the ACPI MCFG. At least that appears
> to be the logic for other host bridges.

try to make thing simple.
for system: with AMD Fam10h, and MCP55 + 2 IO55
amd fam10h cpu: said it needs [0,0]
mcp55: said it need [0,255]
io55 #1: said it need [0x40, 0x40+255], then u8 end_bus_number = 0x3f
io55 #2: said it need [0x80, 0x80+255], then u8 end_bus_number = 0x7f
MMIO route in NBs is right.

but MCFG is right... so just use that.

when acpi=off, if check_and_enable_amd_mconf, it will forcely to make
amd fam10h cpu: said it needs [0,255] and pci_mmcfg_config_num = 1
so mcp55 mconf is not used.


>
>> +       mcp55_checked = true;
>> +       for (bus = 0; bus < 256; bus++) {
>> +               u64 base;
>> +               u32 l, extcfg;
>> +               u16 vendor, device;
>> +               int start, size_index, end;
>> +
>> +               raw_pci_ops->read(0, bus, PCI_DEVFN(0, 0), 0, 4, &l);
>
> Don't we need to check devices 8, 16 and 24 as well as 0?

you didn't put mcp55 on device 0? why?

YH
