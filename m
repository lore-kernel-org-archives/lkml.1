Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZHCPTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZHCPTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZHCPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:19:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbZHCPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:19:13 -0400
Message-ID: <4A76FF8E.80507@zytor.com>
Date: Mon, 03 Aug 2009 08:17:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT()
References: <20090718151219.GD11294@localhost.localdomain>	 <tip-d520da1173abd1f918b7e690220e14ba0fc56cfc@git.kernel.org>	 <20090803062024.GA22365@elte.hu> <4A768339.9060904@zytor.com> <961aa3350908030811n6467b2d7hf42dfd58e3a438e7@mail.gmail.com>
In-Reply-To: <961aa3350908030811n6467b2d7hf42dfd58e3a438e7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 08:11 AM, Akinobu Mita wrote:
>>>>
>> OK, I spotted the following error, which certainly would explain a crash on
>> an APM machine:
>>
>>        /* data */
>> -       [GDT_ENTRY_APMBIOS_BASE+2]      = { { { 0x0000ffff, 0x00409200 } }
>> },
>> +       [GDT_ENTRY_APMBIOS_BASE+2]      = GDT_ENTRY_INIT(0x409a, 0, 0xffff),
> 
> Oops, I really should have checked the binary because the compiler should
> generate same code with this patch.
> 

Well, it doesn't even on the best of days, because the last hunk changes
a dynamic initializer to a strange mix between static and dynamic:

-static struct desc_struct bad_bios_desc;
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);

 /*
  * At some point we want to use this stack frame pointer to unwind
@@ -476,9 +476,6 @@ void pnpbios_calls_init(union
pnp_bios_install_struct *header)
        pnp_bios_callpoint.offset = header->fields.pm16offset;
        pnp_bios_callpoint.segment = PNP_CS16;

-       bad_bios_desc.a = 0;
-       bad_bios_desc.b = 0x00409200;
-
        set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
        set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));

This is about at strange as it comes; I think we could simply do:

GDT_ENTRY_INIT(0x4092, (unsigned long)__va(0x400UL), 4095-0x400);

Although perhaps the 4095 should really be PAGE_SIZE-1...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

