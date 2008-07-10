Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYGJHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYGJHcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYGJHcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:32:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:63410 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGJHcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WYK34j205QbMGVE7bAOAIfG8Ys4feZgc8SsZGFdSPa4mHEz34lRtrcItjVAw3Tg/VI
         grJt5QbuJYit1/LeQ2HHj+002keMztjMWQZCHx3q8MP4kl5eG8nyaAhirXWNFogAUjoM
         a3cklA5DJbnuiFLWlCqw4cdGvDQQbWXLOseHA=
Message-ID: <86802c440807100032n7da266c6n64a07c72f4c5b200@mail.gmail.com>
Date: Thu, 10 Jul 2008 00:32:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080710072023.GD14377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <200807092015.03004.yhlu.kernel@gmail.com>
	 <20080710065316.GA14377@elte.hu>
	 <86802c440807092357x293224bfh212665a164a41553@mail.gmail.com>
	 <20080710072023.GD14377@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > that the number of mapping ranges depends on our programming, not on
>> > any external factor. I.e. if anyone adds a new mapping range to the
>> > kernel for any purpose, it must be extended - but otherwise it
>> > cannot run out due to new hardware.
>>
>> 4k, 2M, 1G, 2M, 4k
>>
>> some day will get 512g page?
>
> i'd not be surprised to see that in ~10 years. Then we'll have to extend
> the array to 7 entries ;-)
>
> btw., i have a weird system:
>
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003ed93000 (usable)
> [    0.000000]  BIOS-e820: 000000003ed93000 - 000000003ee4d000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003ee4d000 - 000000003fea2000 (usable)
> [    0.000000]  BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
> [    0.000000]  BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
>
> look at the RAM splitup:
>
>  640K + BIOS-hole + ~1GB + acpi + 17MB + acpi + 16K + acpi + 4K
>
> and the end of it is not 1024 MB but 1023 MB.

what were those BIOS engineer doing?

>
> so the _best_ mapping strategy would probably be to do 2MB granular
> mapping up to 1GB, i.e. to 'overmap' into the end of RAM. But we also
> have to make sure that we have no PCI resources or weird chipset
> resources in the final 1MB that could hurt us with PAT, aliasing-wise.
>
> Since i'm not sure we can really ensure sanity on that level, i guess
> your solution to precisely map everything without overmapping is our
> best choice. Thus sane hw with such end of RAM mappings:
>
>  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
>
> and another one with:
>
>  BIOS-e820: 0000000100000000 - 0000000830000000 (usable)
>
> ... would be slightly faster (because it would use 2MB TLBs at the end
> of kernel RAM, instead of broken-up 4K TLBs)
>
> perhaps we could also have a config and boot option that would sanitize
> the e820 map to just ignore all non-2MB granular RAM. Losing 1-2MB of
> RAM is not an issue on a 32GB system.

change left over to E820_RESERVED,

YH
