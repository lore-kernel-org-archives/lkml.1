Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYATSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYATSto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYATSth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:49:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYATStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:49:36 -0500
Message-ID: <47939787.3050707@zytor.com>
Date: Sun, 20 Jan 2008 10:48:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org> <1200847490.26633.62.camel@cthulhu.hellion.org.uk> <20080120173938.GA27247@one.firstfloor.org>
In-Reply-To: <20080120173938.GA27247@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jan 20, 2008 at 04:44:50PM +0000, Ian Campbell wrote:
>> Indeed it does. I don't have any non-PAE to test it but I turned the
>> failure case into a simple jmp to hlt_loop since we ought never to get
>> here in any case.
> 
> There are various loaders (kexec, elilo, ...) that skip the 16bit code
> and jump directly to 32bit head.S. So in theory those could hit it.
> But still having the loop only is probably fine.
> 

It's probably just as well, since we don't really know how to get a 
message out in such an environment anyway...

>>>> + * Since a paravirt guest will never come down this path we want
>>>> + * native style page table accessors here.
>>>> + */
>>>> +#undef CONFIG_PARAVIRT
>>> Seems quite fragile. I'm sure that would hurt later.
>> The problem here is that we explicitly want native accessors because
>> it's too early to use the pv ops since we are still running P==V. A PV
>> kernel boot will never come down this path -- it is diverted earlier in
>> head_32.S so using the native versions are appropriate.
> 
> Then i think it would be cleaner to just open code everything without
> any accessors.

I was thinking about this yesterday, and it seems to me that there are 
two cleaner options here...

- either we should put in the full machinery to be able to run C code 
compiled with -fPIC/-fPIE before paging is enabled.  Unfortunately gcc 
generates R_386_GOT32 relocations for external references even with 
-fPIE, so we'll have to put in some code to adjust the GOT (easy enough 
to do.)

As far as the native accessors are concerned, the right thing to do 
would is to use the native_ forms thereof, not #undef CONFIG_PARAVIRT.

- alternatively, we recognize that this isn't all that big of a piece of 
code and doing it in C really isn't necessary.  We can have a small 
assembly loop for PAE that matches the small assembly loop we already 
have for !PAE.

>> As hpa says we can't be above 4G at this point. Probably I can use some
>> variant of make_pte now though.
> 
> The 32bit cast still feels unclean. After all the PTE is not 32bit.

No, but (pte_t *) is 32 bits.  To be more "Linuxy" it probably should be 
(long) or (unsigned long) though.

	-hpa
