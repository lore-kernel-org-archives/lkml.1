Return-Path: <linux-kernel-owner+w=401wt.eu-S934709AbYBUWfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbYBUWfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbYBUWe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:34:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51624 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753AbYBUWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:34:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ian Campbell <ijc@hellion.org.uk>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	<20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	<20080215202336.GE26034@mail.oracle.com>
	<1203274161.27987.6.camel@localhost.localdomain>
	<20080218104025.GA15899@ca-server1.us.oracle.com>
	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	<47BBDA20.8030105@zytor.com>
	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	<47BCA275.7000504@goop.org>
	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>
	<47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>
Date: Thu, 21 Feb 2008 15:04:08 -0700
In-Reply-To: <47BDEB57.5040203@zytor.com> (H. Peter Anvin's message of "Thu,
	21 Feb 2008 13:21:27 -0800")
Message-ID: <m14pc26k6f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> Ian Campbell wrote:
>>> I'll see if I can track down where the page is getting used and have a
>>> go at getting in there first. It must be pretty early to be allocated
>>> already when dmi_scan_machine gets called.
>>>
>>> It's possible that the domain builder might have already allocated a PT
>>> at this address. I haven't checked but I think currently the domain
>>> builder always puts PT pages after the kernel so hopefully it's only a
>>> theoretical problem.
>>>
>>
>> Yes, it does.  And presumably the early pagetable builder is guaranteed to
>> avoid special memory like the DMI space.  But the bug definitely seems to be a
>> result of the DMI code trying to make a RW mapping of a pagetable page, so
>> something is amiss there.
>>
>> Ooh, sleazy hack idea: make DMI always map RO, so even if it does get a
>> pagetable it causes no complaint...  A bit awkward, since there doesn't seem
>> to be an RO form of early_ioremap.
>>
>>> Another option I was thinking of was a command line option to disable
>>> DMI, which (maybe) isn't terribly useful in itself but it introduces an
>>> associated variable to frob with. That's similar to how the TSC was
>>> handled in the past (well, the opposite since TSC was forced on).
>>>
>>
>> Yep, that would work too.
>>
>> Still curious about why a pagetable page is ending up in that range though.
>> Seems like it shouldn't be possible, since we shouldn't be allowed to allocate
>> from those pages, at least until the DMI probe has happened...  Unless the
>> early allocator is only excluded from e820 reserved pages, which would cause a
>> problem on systems which don't reserve the DMI space...  HPA?
>>
>
> I thought the problem was a Xen-provided pagetable from before Linux started?

The immediate symptom was that we have a page table at the address we
are doing the DMI probe.  Xen does not allow pages tables to be mapped
read-write so early_ioremap get into trouble.

We have a mystery:
- Why did the Xen domain builder or the linux kernel use 0xf0000 - 0x10000
  for a page table.

  It should be possible to instrument the early linux page allocation
  and see what page pages linux is using to see who is doing weird
  things.

We have possible solutions.
- Add a read-only flag to early_ioremap for use by our table scans.
- Don't do a DMI scan in the case of Xen.
- Fix the Xen domain builder.

My inclination is that we disable the fruitless DMI scan in the case
Xen, or we get the Xen domain builder fixed.

If Xen is going to increasingly look like a normal X86 BIOS we should
let the DMI scan run and be put the burden on Xen to keep things
looking like a normal x86 machine.  If Xen is not going to look more
like a normal x86 machine we can say oh, that is nice, it's Xen so
don't bother doing things that will cause problems.

In this case can we confirm that the domain builder is using those
early 64k as pages for a page table, and then educate it that not
allowing OS access to those pages is a little silly.

All of that said.  For DMI tables other early tables we should not
be writing to them anyway so learning to use read-only maps may be
the right solution.  If the reason Xen was complaining was that
we were accessing an area that was not page tables but instead
should only be mapped read-only I would have a lot of sympathy
with that.  As mapping areas that are architecturally ROMs read-write
is silly.

So guys can you please finish the root cause and really see why there
is a page table page at in 64K ROM BIOS area?

Eric
