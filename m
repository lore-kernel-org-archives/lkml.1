Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXCFKxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXCFKxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965830AbXCFKxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:53:33 -0500
Received: from www.osadl.org ([213.239.205.134]:39026 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964930AbXCFKxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:53:31 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Daniel Hecht <dhecht@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45ED2C82.3080008@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 11:59:34 +0100
Message-Id: <1173178774.24738.311.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 00:55 -0800, Zachary Amsden wrote:
> > a proper CE device also has the added bonus of making high-res timers 
> > guests work automatically. It should be simple: just pass it through to 
> > your hypervisor, a hyper-CE-device, like a hyper-clocksource device has 
> > essentially no guest-side complexity.
> >   
> 
> It is not so simple.  In theory it works great.  In reality, the i386 
> implementation is completely hardwired to work the way hardware works, 
> and breaking the clockevent code out of the deep ties to the APIC is 
> extremely non-trivial.  We tried, and could not accomplish it for 2.6.21 
> because the hrtimers integration was complex, and introduced many bugs 
> for us.

Why is this so non-trivial ? All you have to do is _NOT_ register
PIT/HPET/APIC timers and register a per CPU hyper-CE-device instead,
which uses the hypervisor timer emulation instead of real hardware.

clockevents breaks the hardwired assumptions of the old timer code and
allows you to remove _ALL_ the hardwired hackery in vmitimer.c, i.e.
stuff like

       /* Disable PIT. */
        outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */

> We worked around this by keeping NO_IDLE_HZ support, which now 
> you deprecated.  So now we are using NO_HZ without a hyper-CE device, 
> and it is working fine.  We understand the benefits of moving to the CE 
> model - but it cannot be done overnight.

This is ugly as hell. NO_HZ enables the dyntick functions in idle(),
irq_enter() and irq_exit() so the clockevents code is actually invoked.
I have not looked close enough why this does work at all.

I have the feeling that "working fine" means something like "does not
explode".

We really want to fix this now instead of pushing some not know why it
works hack into the kernel.

	tglx


