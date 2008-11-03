Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYKCSEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYKCSEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYKCSEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:04:07 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43073 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbYKCSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:04:05 -0500
Subject: Re: upstream regression (IO-APIC?)
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@suse.cz>
In-Reply-To: <200811031828.07285.bzolnier@gmail.com>
References: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no>
	 <200811021537.24771.bzolnier@gmail.com>
	 <200811022124.24992.bzolnier@gmail.com>
	 <200811031828.07285.bzolnier@gmail.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 03 Nov 2008 10:04:04 -0800
Message-Id: <1225735444.8168.24.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 09:28 -0800, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 02 November 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 02 November 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Thursday 30 October 2008, Robert Hancock wrote:
> > > > Bartlomiej Zolnierkiewicz wrote:
> > > > > The current Linus tree as of commit e946217e4fdaa67681bbabfa8e6b18641921f750
> > > > > is broken for me.  I get either the following panic (see log from qemu below)
> > > > > or lost IRQs on ATA init...  Is this a known issue?
> > > > > 
> > > > > PS The tree that I used before and was supposedly good (sorry, I'm too tired
> > > > > to verify it now) had commit 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 at head.
> > > 
> > > Unfortunately 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 (v2.6.28-rc1)
> > > is also bad.  Bisecting it further was a real pain (i.e. I hit broken
> > > build with x86 irqbalance changes, broken build with netfilter nat
> > > changes and jbd journal problem).  In the end it turned out that 2.6.27
> > > is bad too!  However with 2.6.27 the panic occurs only once per several
> > > attempts and if there is no panic kernel boots normally (no lost IRQs).
> > > 
> > > [...]
> > > 
> > > I finally managed to narrow it down to change making x86 use tsc_khz
> > > for loops_per_jiffy -- commit 3da757daf86e498872855f0b5e101f763ba79499
> > > ("x86: use cpu_khz for loops_per_jiffy calculation").  This approach
> > > seems too simplistic (as I see now Arjan & Pavel expressed concerns
> > > about it back when the patch was posted initially [1][2]).  Also it
> > > would probably be preferred to re-use existing preset_lpj variable
> > > (just like KVM does it for similar purpose [3]) instead of adding a
> > > lpj_tsc one and increasing complexity.
> > 
> > It turned out that I can boot a kernel with different config with
> > HZ == 250 just fine and switching to HZ == 1000 makes it fail.
> > 
> > 
> > Looking into it some more:
> > 
> > HZ == 250 kernel (good):
> > 
> > Calibrating delay loop (skipped), value calculated using timer frequency.. 2986.79 BogoMIPS (lpj=5973580)
> > 
> > HZ == 1000 kernel (bad):
> > 
> > Calibrating delay loop (skipped), using tsc calculated value.. 2990.35 BogoMIPS (lpj=1495176)
> > 
> > HZ == 1000 kernel with hackyfix (good):
> > 
> > Calibrating delay using timer specific routine.. 3016.68 BogoMIPS (lpj=6033376)
> > 
> > 
> > Argggh... lpj is used for udelay() & friends so this bug is quite
> > dangerous (since udelay() & friends are used for hardware delays)...
> 
> It may be not as severe as I initially thought,
> (obviously) the real hardware works fine:
> 
> calibrate_delay_direct(): lpj=1495884
> Calibrating delay loop (skipped), value calculated using timer frequency.. 2990.36 BogoMIPS (lpj=1495183)
> 
> So the issue only affects qemu ATM.
Oh so its on a emulator, something wrong in the timer emulation logic in
qemu ?


> 
> Thanks,
> Bart

