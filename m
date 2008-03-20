Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYCTFAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYCTFAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYCTFAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:00:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:19839 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYCTE77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T+efaYVYyzjVLqZRhh+kDtgXj9mp+EWWVcuhyzRtEfnf9WCXfR/V21ECXcKU5NBauRFmo4LPBYbURT5EsIXGlALLuIFq4I0W9ilyQvVUCOsCKodBpixxSwmIMXxzM8vedVV0OGgDcBZv9VfcWZQKMsCvkHm5eHFj0iHoUjnlJZg=
Message-ID: <86802c440803192159y28c186f0p98615e90da5a9345@mail.gmail.com>
Date: Wed, 19 Mar 2008 21:59:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 0/79] smpboot integration
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <47E1EAD6.5080905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059475744092-git-send-email-gcosta@redhat.com>
	 <20080319173533.GA31576@elte.hu>
	 <86802c440803191918y11af1269m39a7c7164f5f7d36@mail.gmail.com>
	 <86802c440803192000x41a1383fxc2b58ed68e2375b7@mail.gmail.com>
	 <86802c440803192032r2aa15a10pb32ef15fcfc693e7@mail.gmail.com>
	 <47E1EAD6.5080905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 9:40 PM, Glauber Costa <gcosta@redhat.com> wrote:
>
> Yinghai Lu wrote:
>  > On Wed, Mar 19, 2008 at 8:00 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >> On Wed, Mar 19, 2008 at 7:18 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >>  > On Wed, Mar 19, 2008 at 10:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  >>  >  >
>  >>  >  >  * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>  >>  >  >
>  >>  >  >  > Testing and bisectability:
>  >>  >  >  >
>  >>  >  >  > The end result was tested in all my hardware (which includes qemu ;-).
>  >>  >  >  > It does not mean it will boot _your_ hardware, but I did my best ;-)
>  >>  >  >  >
>  >>  >  >  > The tree at least compiles in more than 20 randconfigs (for each of
>  >>  >  >  > x86_64 and i386) For i386, each of the subarchitectures was compiled
>  >>  >  >  > at least once. (By compile, I obviously mean, every patch,
>  >>  >  >  > individually)
>  >>  >  >
>  >>  >  >  very nice work! I'll pick it up - and i'm not too worried about
>  >>  >  >  breakages because at 80 patches granularity any problem should be
>  >>  >  >  identifiable in a very finegrained way.
>  >>  >  >
>  >>  >
>  >>  >  it broke 4 sockets quad core above with 64 bit
>  >>  >
>  >>  >  Booting processor 11/15 ip 6000
>  >>  >  Initializing CPU#11
>  >>  >  masked ExtINT on CPU#11
>  >>  >  Calibrating delay using timer specific routine.. 4589.46 BogoMIPS (lpj=9178934)
>  >>  >  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>  >>  >  CPU: L2 Cache: 512K (64 bytes/line)
>  >>  >  CPU 11/f -> Node 2
>  >>  >  CPU: Physical Processor ID: 2
>  >>  >  CPU: Processor Core ID: 3
>  >>  >  CPU11: Quad-Core AMD Opteron(tm) Processor 8356 stepping 03
>  >>  >  checking TSC synchronization [CPU#0 -> CPU#11]: passed.
>  >>  >  Booting processor 12/16 ip 6000
>  >>  >
>  >>  >  looks like local apic id up 4 bit is masked out. so can not start 0x10
>  >>  >  above any more.
>  >>
>  >>  in wakeup_secondary_via_INIT
>  >>  before the patchsets
>  >>  64 bit code:
>  >>
>  >>         /*
>  >>          * Send IPI
>  >>          */
>  >>         apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
>  >>                                 | APIC_DM_INIT);
>  >>
>  >>
>  >>  after patchset
>  >>
>  >>         /* Boot on the stack */
>  >>         /* Kick the second */
>  >>         apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
>  >>
>  >>  So that is wrong! esp for system has ext apic id that is has 8 bits
>  >>  instead of 4 bits.
>  >>
>  >
>  > it seems there is two wakeup_secondary_cpu. one for NMI and one INIT.
>  >
>  > but should have
>  >
>  > #define WAKE_SECONDARY_VIA_INIT
>  >
>  > for x86_64
>  >
>  > but after
>  >
>  > #ifdef CONFIG_X86_64
>  > #undef WAKE_SECONDARY_VIA_NMI
>  > #define WAKE_SECONDARY_VIA_INIT
>  > #endif
>  >
>  > it still doesn't work.
>  >
>  > YH
>  Thanks for the testing Yinghai. I'll take a deeper look as soon as I
>  can. The two routines are provided, since i386 numa-q inits the startup
>  sequence through NMIs. The _VIA_INIT is already defined in x86_64 in the
>  mach-default/ headers.
>
>  What happens exactly? Does it hang indefinitely ? Or just for a while?
>  Also, can you provide the exact commit in which this problem start?
>  (just to be sure)

hang indefinitely.

maybe some apic code merge problem...

YH
