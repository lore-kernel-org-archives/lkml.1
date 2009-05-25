Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbZEYELq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbZEYELq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 00:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZEYELi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 00:11:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZEYELh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 00:11:37 -0400
Date: Mon, 25 May 2009 06:10:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
Message-ID: <20090525041057.GD9396@elte.hu>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu> <4A14447E.9060607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A14447E.9060607@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Since they are not performance critical, then why doesnt Xen catch the 
>> IO-APIC accesses, and virtualizes the device?
>>
>> If you want to hook into the IO-APIC code at such a low level, why  
>> dont you hook into the _hardware_ API - i.e. catch those setup/routing 
>> modifications to the IO-APIC space. No Linux changes are needed in that 
>> case.
>>   
>
> Yes, these changes aren't for a performance reason.  It's a case 
> where a few lines change in Linux saves many hundreds or thousands 
> of lines change in Xen.
>
> Xen doesn't have an internal mechanism for emulating devices via 
> pagefaults (that's generally handled by a qemu instance running as 
> part of a guest domain), so there's no mechanism to map and 
> emulate the io-apic.  Putting such support into Xen would mean 
> adding a pile of new infrastructure to support this case.

Note that this design problem has been created by Xen, 
intentionally, and Xen is now suffering under those bad technical 
choices made years ago. It's not Linux's problem.

The whole Xen design is messed up really: you have taken off bits of 
the Linux kernel you found interesting, turned them into a 
micro-kernel in essence and renamed it to 'Xen'.

But drivers and proper architecture is apparently boring (and 
fragile and hard and expensive to write and support in a 
micro-kernel setup) so you came up with this DOM0 piece of cr*p that 
ties Linux to Xen even closer (along an _ABI_), where Linux does 
most of the real work while Xen still stays 'separate' on paper.

Xen isnt actually useful _at all_ without Linux/DOM0. Without Dom0 
Xen is slow and native hardware support within Xen is virtually 
non-existent, as you point out above.

This is proof that you should have done all that work within Linux - 
instead of duplicating a lot of code.

> Unlike the mtrr discussion, where the msr read/write ops would 
> allow us to emulate the mtrr within the Xen-specific parts of the 
> kernel, the io-apic ops are just accessed via normal memory writes 
> which we can't hook, so it would have to be done within Xen.
>
> The other thing I thought about was putting a hook in the Linux 
> pagefault handler, so we could emulate the ioapic at that level.  
> But putting a hook in a very hot path to avoid code changes in a 
> cold path doesn't make any sense.  (Same applies to doing PF 
> emulation within Xen; that's an even hotter path than Linux's.)

We already have various page fault notifiers, you could reuse them 
if you wanted to.

Anyway, i'll pull the IO-APIC driver-ization changes if it's 
complete, thorough and clean, because that will obviously help Linux 
too. But the influx of paravirt overhead slowing down the native 
kernel has to stop really.

	Ingo
