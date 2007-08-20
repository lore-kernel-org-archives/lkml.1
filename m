Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXHTRNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXHTRNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760662AbXHTRM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:12:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760651AbXHTRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:12:56 -0400
Message-ID: <46C9CB89.7020603@zytor.com>
Date: Mon, 20 Aug 2007 10:12:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>	 <20070815154245.500c572c.akpm@linux-foundation.org>	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de>	 <1187313920.28497.1.camel@caritas-dev.intel.com>	 <46C5C8C4.4060407@zytor.com> <1187580031.27947.67.camel@caritas-dev.intel.com>
In-Reply-To: <1187580031.27947.67.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>>
>> I propose that, in addition to the aforementioned version number and
>> magic fields, we add a pointer, which should be the last pointer added
>> that doesn't point into I/O space or reserved memory (i.e. memory that
>> is off limit anyway for the operating system.)
>>
>> This pointer should point to a linked list of suggested form:
>>
>> struct setup_data {
>> 	u64 next;
>> 	u32 type;
>> 	u32 len;
>> 	u8 data[];
>> };
>>
>> This can thus encapsulate large objects as necessary, and the early
>> kernel entry can linearize them if it needs to move them out of the way.
>>  Better yet, this information can be made available to sysfs for
>> debuggability, and/or use by kexec.
> 
> This is a good interface. It is extensible. In the future, when we need
> more boot information, we can just define a new type.
> 
> And with this interface, it is not necessary to export the "zero page
> protocol" as a external boot protocol (ABI) of the kernel. So, I
> proposed that:
> 
> 1. Keep "zero page" as a internal interface, even make that explicitly
> in the document.
> 2. Increase the version number of standard boot protocol.
> 3. Append this pointer (pointed to linked list of struct setup_data) to
> standard boot protocol.
> 4. Define a set of types of struct setup_data, each for one zero_page
> field.
> 5. The kernel 16-bit setup code generates "linked list of struct
> setup_data" instead of generating "zero page". On machine with BIOS
> other than legacy BIOS (such as EFI, LinuxBIOS, etc), the bootloader
> (incuding kexec) generates the "linked list of struct setup_data"
> instead of generating "zero page" too.
> 6. In kernel early booting code, the "zero page" is generated from the
> "linked list of struct setup_data".
> 7. In the future, most booting code uses "linked list of struct
> setup_data" directly instead of "zero page".
> 
> So, we need not define a new boot protocol, just extend the standard
> boot protocol. The version number and magic need not to be added to
> "zero page". But, at the same time, the bootloader on EFI, LinuxBIOS and
> kexec must be changed accordingly.
> 

I think this is too radical of a change to be practical.  Instead, I
propose the following:

- "struct boot_params" (the zeropage) is kept as a legacy interface.
%esi will continue to point to it on entry to the 32-bit entrypoint
(presumably that is %rsi on entry to a 64-bit entrypoint?)

- We add a magic number and a pointer chain to the zeropage.  The
presence of the magic number indicates that:

	- Any unused fields in the zeropage is zero;
	- The pointer chain is valid (unless zero);
	- The old "HD info" fields (and possibly the EDD fields)
	  can be recycled.

What a post-upgrade kernel should do upon encountering an old structure
(sans magic) is to zero out any fields that wasn't present in the legacy
structure definition, including the pointer chain, then it can use it as-is.

We should avoid adding fields to the zero_page after that, unless
necessary for backwards compatibility reasons.  In general, new data
items should be added as pointer capabilities.

Compare this to the legacy PCI header vs. PCI capabilities.

	-hpa
