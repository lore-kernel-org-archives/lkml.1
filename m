Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYAYCVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYAYCVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 21:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYAYCVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 21:21:35 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36857 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYAYCVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 21:21:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
References: <1201121530.30671.15.camel@cthulhu.hellion.org.uk>
	<4797E487.8010108@goop.org>
	<1201167544.30671.64.camel@cthulhu.hellion.org.uk>
	<47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org>
	<479913BA.8000506@zytor.com> <47991809.9060903@goop.org>
	<47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org>
	<4799247C.6090008@zytor.com> <20080125002054.GA2059@elf.ucw.cz>
	<47992D0E.2070700@zytor.com>
Date: Thu, 24 Jan 2008 19:16:26 -0700
In-Reply-To: <47992D0E.2070700@zytor.com> (H. Peter Anvin's message of "Thu,
	24 Jan 2008 16:27:58 -0800")
Message-ID: <m1hch2ir9h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Pavel Machek wrote:
>>>>
>>> I just looked at the ACPI suspend code, and it looks like it hacks its own
>>> identity map at runtime.  Pavel, am I reading that code right?
>>
>> Yes, I think so, I believe we do it on both 32 and 64 bit now.
>>
>
> So the background to this... we need an identity map to trampoline at early
> boot, obviously, but we'd like it to not stick around more than necessary.  We
> have zap_low_mappings() now but it's not really sufficient.
>
> Secondary SMP processors need these mappings during trampolining -- 
> presumably including CPU hotplug -- and I'm suspecting it might simply make
> sense to use a separate set of page tables (with both the identity and the
> kernel map) for trampolining and just keep them around.  That way they would be
> usable for ACPI as well.

We already do this on the 64bit side.  We reuse the kernel and the
identity parts from the core kernel page tables but it is actually
a distinct page table.  

x86_64 has not had the identity mappings mapped in any of the
normal page tables since the relocatable kernel support was merged
a while ago.

Only on the 32bit side does this still remain an issue.  I don't know
if what we can do optimization wise there.  Emulating the 64bit code
and having a dedicated top level pgd (as part of the trampoline)
and then a mapping into it the kernel identity mapping and the kernel
mapping (which are the same on 32bit) should work fairly easily.  

It is just a handful of pgd entries, and then in the actual kernel
entry code we reload %cr3 with the appropriate kernel page table
and we should be fine.  No need for an explicit zap there at all.

Eric
