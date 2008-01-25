Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYAYCaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYAYCaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 21:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYAYCaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 21:30:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYAYCaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 21:30:11 -0500
Message-ID: <479948A1.7010607@zytor.com>
Date: Thu, 24 Jan 2008 18:25:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201121530.30671.15.camel@cthulhu.hellion.org.uk>	<4797E487.8010108@goop.org>	<1201167544.30671.64.camel@cthulhu.hellion.org.uk>	<47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org>	<479913BA.8000506@zytor.com> <47991809.9060903@goop.org>	<47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org>	<4799247C.6090008@zytor.com> <20080125002054.GA2059@elf.ucw.cz>	<47992D0E.2070700@zytor.com> <m1hch2ir9h.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hch2ir9h.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> We already do this on the 64bit side.  We reuse the kernel and the
> identity parts from the core kernel page tables but it is actually
> a distinct page table.  
> 
> x86_64 has not had the identity mappings mapped in any of the
> normal page tables since the relocatable kernel support was merged
> a while ago.
> 
> Only on the 32bit side does this still remain an issue.  I don't know
> if what we can do optimization wise there.  Emulating the 64bit code
> and having a dedicated top level pgd (as part of the trampoline)
> and then a mapping into it the kernel identity mapping and the kernel
> mapping (which are the same on 32bit) should work fairly easily.  
> 
> It is just a handful of pgd entries, and then in the actual kernel
> entry code we reload %cr3 with the appropriate kernel page table
> and we should be fine.  No need for an explicit zap there at all.
> 

That's pretty much what I figure.  The one issue is that on non-PAE 
32-bit (or if we actually have to deal with unsharable PMDs on PAE 
kernels) then the PGD (PMD) kernel mappings at least formally should 
really be put in sync.  This could be done either by the same code which 
keeps the PGDs of various processes in sync already or on demand; I 
believe my personal preference would be to have all that in the same 
place, since we have to do it anyway, and this is nothing different 
except for the offset.

	-hpa
