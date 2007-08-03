Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbXHCPw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbXHCPw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXHCPwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:52:21 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:57815 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbXHCPwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:52:19 -0400
Subject: Re: ACPI on Averatec 2370
From: Ben Collins <ben.collins@ubuntu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cal Peake <cp@absolutedigital.net>, Chuck Ebbert <cebbert@redhat.com>,
       Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
	 <46ACD8DB.2020108@googlemail.com>
	 <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
	 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
	 <46B22BDA.8090604@redhat.com>
	 <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
	 <46B23E08.4070106@redhat.com>
	 <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
	 <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 03 Aug 2007 11:52:08 -0400
Message-Id: <1186156328.8105.72.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 14:07 -0700, Linus Torvalds wrote:
> 
> On Thu, 2 Aug 2007, Cal Peake wrote:
> > 
> > Figured I should have sent that right after I hit the send key...
> > 
> > processor	: 0
> > vendor_id	: AuthenticAMD
> > cpu family	: 15
> > model		: 72
> > model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-52
> 
> Sadly, this doesn't show the "extended family" stuff from cpuid.
> 
> So it doesn't show any of the bits we actually care about. Sad.
> 
> That said, the "AMD Turion(tm) 64 X2 Mobile Technology TL-52" _should_ be 
> a REV-F CPU afaik, and it should have thus fallen through to the 
> "ENABLE_C1E_MASK" logic. Afaik that's broken.
> 
> Cal - can you
>  (a) test that forcing a "return 1" from that amd_apic_timer_broken() 
>      function fixes it for you.
>  (b) make that function print out the values it uses for debugging (ie the 
>      xtended family and model numbers, and the MSR_K8_ENABLE_C1E MSR 
>      values)?
> 
> Andi, can you check with your AMD contacts that those bits are correct.. 
> Maybe the "Mobile Technology" things *always* have the broken "Enhanced 
> Halt State", regardless of any MSR settings? That would perhaps be what 
> makes them "Mobile".

This is the same problem I'm seeing (See Subject: Regression in 2.6.22,
clock problems on Turion with 32-bit kernel).

This commit is what we bisected to:

commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:04 2007 -0800

    [PATCH] clockevents: i386 drivers

    Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
    the timer IRQ to call into the PIT/HPET driver's event handler and the
    lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
    timer functionality is delegated to the core framework code and replaces the
    compile and runtime evalution in do_timer_interrupt_hook()

    Use the clockevents broadcast support and implement the lapic_broadcast
    function for ACPI.

    No changes to existing functionality.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

