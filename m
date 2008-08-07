Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYHGX1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYHGX1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYHGX1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:27:32 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34450 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbYHGX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:27:31 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Zachary Amsden <zach@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808071603330.3462@nehalem.linux-foundation.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B6A5C.8030400@kernel.org>
	 <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>
	 <489B6E83.7000202@kernel.org>
	 <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com>
	 <489B7470.5030408@kernel.org>
	 <alpine.LFD.1.10.0808071533100.3462@nehalem.linux-foundation.org>
	 <489B7DFE.5010402@kernel.org>
	 <alpine.LFD.1.10.0808071603330.3462@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 16:26:11 -0700
Message-Id: <1218151571.20178.384.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 16:08 -0700, Linus Torvalds wrote:
> 
> On Thu, 7 Aug 2008, H. Peter Anvin wrote:
> >
> > Just moving it down by 4 MB doesn't help, since the VMI guys want as much as
> > 64 MB, which is half the standard vmalloc area and hence too much address
> > space lost.  We can't put it at the bottom of the vmalloc area, since that
> > boundary is not fixed, either.
> 
> Yeah, ok. Since this is a 32-bit only issue, 64MB is actually a fair chunk
> of our already limited virtual space.
> 
> > The one remaining fixed boundary in the machine is the kernel-userspace
> > boundary.  Hence moving the 1:1 area up by one PDE unit and sticking the
> > fixmap area in that region.
> 
> Yeah, ok, but I'd be more nervous about the validation issues there. There
> might be a lot of code that assumes that TASK_SIZE is the start of the 1:1
> area. It does sound like a good approach, it just makes me worry about the
> test coverage.

Well, here's an idea from outer space.  The fixmap can't possibly be
used until it's got a backing page table and initial mappings installed.
One can imagine a world where references to the fixmap are left as
unresolved, and then those unresolved symbols are linked to the fixmap
area when it gets set up in the kernel page table.  Voilla!

The requisite foodling required to massage various gcci and lds into
compliance with this scheme, not to mention the required module loading
changes might be a bit of headache, and even then, I'm not sure that gcc
will be smart enough to allow all the required relocations to generate
optimal code.

But the upshot would be the potential for dynamic registration of fixmap
areas, yet still keeping direct pointers into the thing, and also
removing all the ifdefs from the fixmap definitions for the various
platform specific fixmap pages.  Just leave dangling references to some
fixed bad address (fixmap_hole) for things unused.  And even allow
kernel modules to register new fixmap types!

All it requires is a well thought out strategy for naming fixmap pages
and then two sprinkles of linker magic.  You could even randomize the
non-randomized VDSO location at boot-time.  Whee!

Zach

