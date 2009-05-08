Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZEHSJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZEHSJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZEHSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:08:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZEHSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:08:50 -0400
Message-ID: <4A04742E.8050506@intel.com>
Date: Fri, 08 May 2009 11:04:30 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       sam@ravnborg.org
Subject: Re: [PATCH 00/14] RFC: x86: relocatable kernel changes
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com> <m1tz3wgk3n.fsf@fess.ebiederm.org>
In-Reply-To: <m1tz3wgk3n.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>>> The direction of this patch seems reasonable.  The details are broken.
>>> The common case for relocatable kernels today is kdump.  A situation
>>> with very minimal memory.  In that situation the kernel needs to run
>>> where we put it, modifying the kernel to not run where it gets put
>>> is a problem.
>> I thought in the kdump case you typically loaded it pretty high?  Either
>> which way, kdump is always loaded by kexec, so it should just be a
>> matter of updating kexec to zero the runtime_start field, no?
> 
> Yes.  In practice it doesn't matter. I just don't want to get into a
> contest with the kernel about who knows better how to put the kernel
> in memory the bootloader or the kernel decompressor.
> 
>> Basically
>> this is the bootloader saying "do what I say, dammit."  Since the
>> existing protocol doesn't have a way to unambiguously communicate one
>> direction versus another (see below), it seems like a relatively small
>> issue involving only one tool.  Suboptimal, yes.
> 
> The existing protocol doesn't have the option of anything else.
> 
> Physical start has always been <= the alignment for x86 and x86_64,
> in any real world configuration.

That assumption seems to be the fundamental flaw of the relocation
protocol as written, and rather quite what provoked this whole thing.
We really would want to run at above 16 MB for not just 15 MB hole but
also for ZONE_DMA reasons.

> Something goofy may have happened during unification, I thought I had
> removed physical start as totally unnecessary from x86_64.
> 
> In the non-kdump case this is interesting.  I know of instances where
> kexec is burned in firmware.  So I am strongly reluctant to make anything
> that feels like a true backwards incompatible change.
> 
> Those systems also don't have the stupid 15MB hole either.

OK, kexec in firmware is probably a showstopper... assuming *those*
kexec instances care about the exact final location of the code.
Otherwise, if all they are doing is loading the kernel and want it to
take over the machine, the proposed behavior (realign the kernel to a
more optimal point) is pretty much The Right Thing.  Could you expand on
this use case?  This seems like a key piece of the puzzle.

It's pretty well understood that we can't require changes for the tons
of deployed bootloaders, but at the same time we're stuck in a case with
overloading semantics that have to be disambiguated.

> On the 64bit kernel 2MB really is required.  We run at a fixed virtual
> address and use 2MB pages. So anything less that 2MB really won't work.
> 
> So I think it would be a bad idea if we had bootloaders ignoring the
> alignment.
> 
> With the suggested start address, it probably make sense to only
> export our true alignment requirement.

On 32 bits (which is the only case where one megabyte could possibly
matter) we *can* run at 1 MB, and that was the main case I was worrying
about there.  On the other hand, even very early Linux just barely ran
in 4 MB of RAM, and perhaps an alignment restriction of 4 MB (the
non-PAE case) handles even the smallest configurations?  If so we can
probably get away with just disallowing alignment < 2 MB and use your
solution.

>>> I expect we will still want to update kexec to be able to take
>>> advantage of loadtime_size (runtime_size seems like the wrong name).
>> Well, it is the amount of memory the kernel needs during runtime (as
>> opposed to during loading.)  I admit it's not an ideal name, though.  On
>> the other hand, simply calling it kernel_start and kernel_size seemed
>> ambiguous.
> 
> It is the amount of memory we need before a true memory allocator is
> initialized.  Essentially text+data+bss.  How about we call it init_size?
> 
> Perhaps we should have:
> init_size
> best start (As a 64bit field please)
> optimum align  (Or we flip it around)

I did think about that (64 bits), but I came to the conclusion that in
any case were we're supporting loading over 4 GB we need to be fully
relocatable anyway -- plus we need a whole bunch of other protocol
changes.  This is not in itself a reason not to do it, but the size of
the initialized header is limited to just over 127 bytes without a much
bigger change (since the size of the structure has to fit inside a
single signed byte at 0x201).

	-hpa
