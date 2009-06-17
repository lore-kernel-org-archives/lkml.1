Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZFQBjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZFQBjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFQBjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:39:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZFQBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:39:44 -0400
Message-ID: <4A384914.1090900@zytor.com>
Date: Tue, 16 Jun 2009 18:38:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Cliff Wickman <cpw@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [PATCH] x86: efi/e820 table merge fix
References: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com> <1245201005.11965.4.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1245201005.11965.4.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Wed, 2009-06-17 at 05:43 +0800, Cliff Wickman wrote:
>> From: Cliff Wickman <cpw@sgi.com>
>> --- linux.orig/arch/x86/kernel/efi.c
>> +++ linux/arch/x86/kernel/efi.c
>> @@ -240,10 +240,35 @@ static void __init do_add_efi_memmap(voi
>>  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>>  		int e820_type;
>>  
>> -		if (md->attribute & EFI_MEMORY_WB)
>> -			e820_type = E820_RAM;
>> -		else
>> +		switch (md->type) {
>> +		case EFI_LOADER_CODE:
>> +		case EFI_LOADER_DATA:
>> +		case EFI_BOOT_SERVICES_CODE:
>> +		case EFI_BOOT_SERVICES_DATA:
>> +		case EFI_CONVENTIONAL_MEMORY:
>> +			if (md->attribute & EFI_MEMORY_WB)
>> +				e820_type = E820_RAM;
>> +			else
>> +				e820_type = E820_RESERVED;
>> +			break;
> 
> Why does BIOS mark memory region without EFI_MEMORY_WB as these types?
> Any example?
> 

Probably not, but if it does, it's broken, and the memory should be
ignored. The original code had the EFI_MEMORY_WB check already, so it
seems prudent to keep it.

	-hpa
