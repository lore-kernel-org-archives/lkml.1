Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZCaIPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZCaIPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZCaIPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:15:01 -0400
Received: from mga12.intel.com ([143.182.124.36]:11789 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757909AbZCaIO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,451,1233561600"; 
   d="scan'208";a="126013256"
Message-ID: <49D1D10B.5010308@linux.intel.com>
Date: Tue, 31 Mar 2009 10:15:07 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <49CB4677.9010403@linux.intel.com> <49CC9FEC.6090300@jp.fujitsu.com> <49CCAAFD.2000606@linux.intel.com> <49D08B85.9040206@jp.fujitsu.com> <49D0996D.1050106@linux.intel.com> <49D1C4BC.1020806@jp.fujitsu.com>
In-Reply-To: <49D1C4BC.1020806@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Andi Kleen wrote:
>>>> BTW another thing you need to be aware of is that not all CMCI banks necessarily support
>>>> thresholds > 1. The SDM has a special algorithm to discover the counter width.
>>>> This means the scheme wouldn't work for some banks.
>>> My current implementation already follows the SDM.
>> Yes didn't want to doubt that, just saying that it's not very useful
>> to play with the thresholds on those "only one" banks.
> 
> I know such "only one" banks is possible according to specification,
> but I'd like to know how many such banks are there in real world.

I was told they are possible.

> # Exactly It is great that Intel introduced threshold capability.
> # But are there any reason why they don't implement it to all banks,
> # and even implemented why some cannot have > 1?
> ## ... Don't mind, this is not complaints to you, Andi.

I don't know why it was done this way.

>>>  - Disabling polling (but use CMCI) is pointless.
>>>     (only use on trouble that only break polling?)
>> You can already do that by setting check_interval == 0
> 
> Right.  Give documents for it, please.

Patch done.

>>>  - Disabling stuff for CE (both of polling and CMCI) will be help for some
>>>    particular cases.
>> Actually I have my doubts of that (if you think of the SMI logging
>> which should be able to get them first anyways without kernel options),
>> but a boot option for this at least wouldn't be particularly
>> bloated. I suspect the use case would be to mainly shut off
>> the printk.
> 
> Unfortunately SMI is not the case.

Hmm, how does your BIOS log on its own then if it doesn't use SMI for this?

>> Also it's still open if you want to do the logging of left over
>> errors from boot too or not included with this.
> 
> I don't care the left over record at this time.

That means you want to log them or not? There's already a option to
disable it, but I suspect if for user friendliness you would want
to combine them in one.

Note that this is the only way to log fatal panics to disk on normal
systems.

>>> IIRC, the complain was from user of IPF, because it was "noise" for him.
>>> Or just there was "it would be acceptable if the rate were 1/5" or so.
>>> Real solution will be killing CE related stuff in kernel at all, anyway.
>> Or in the BIOS. We can do it in the kernel, but I suspect for you
>> it would be user friendlier if the BIOS just never made them
>> visible.
> 
> However I heard that hiding such thing by BIOS might be a problem in
> case that making it visible is required for hardware certificates,
> e.g. Windows's certificates.

Windows uses a different mechanism anyways I believe.

> 
>>> In short, it changes behavior on uncorrected errors, from "panic" to "hang up."
>> Playing devils advocate here, but if your BIOS is really that intelligent
>> isn't that what you want?  As far as I understand your patches seem
>> to be all about moving things from the OS to the BIOS and that
>> would be the ultimate way to move UC errors to the BIOS too.
> 
> Traditionally (actually I'm not sure how much long ago it means) corrected
> errors were just ignored or only handled by BIOS, while uncorrected errors
> were forwarded to OS.  For another example, there are some particular cases
> that a vendor specific hardware monitoring application is bundled with the
> hardware, expecting that it can gather error information in the hardware,

That means it accesses MSRs directly?

> 
> Of course I don't doubt that such scheme will not applicable in these days,
> however there are still some doing so in the old style.  We should stop
> them but have not done yet.  Is it help you if I call setting ignore_ce as
> traditional-compatible mode?

I don't think it's traditional on most standard x86 systems at least.

> 
> Personally, I can understand a policy that a platform (server hardware)
> should be stand alone not depending on the OS running on it.
> Like PAL/SAL on IPF, intelligent firmwares will be able to take a part of
> error recovery.
> 
> But here I'm not requesting such fancy thing for x86.
> 
> In conclusion, the mce=ignore_ce and mce=no_cmci will be better interface.
> Compare with current version, it lacks threshold >1 support but it does
> no matter because threshold >1 will work improperly and help nothing.

There's still the open issue with the leftover events at boot.

-Andi
