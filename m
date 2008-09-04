Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYIDS1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYIDS1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYIDS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:27:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbYIDS1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:27:33 -0400
Date: Thu, 4 Sep 2008 14:26:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904182637.GP3400@redhat.com>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904175231.GH18288@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 07:52:31PM +0200, Andi Kleen wrote:
> On Thu, Sep 04, 2008 at 01:20:52PM -0400, Don Zickus wrote:
> > On Thu, Sep 04, 2008 at 05:52:17PM +0200, Andi Kleen wrote:
> > > Then if there's a chipset specific NMI driver it could
> > > also check if the chipset raised it. That would be a possible
> > > solution for HP -- they would need to implement such a driver
> > > for their systems with the special watchdog.
> > 
> > The thing with HP's special watchdog timer is that it does _not_ have a
> > chipset specific NMI it is trying to catch.  HP is going on the assumption
> > that _all_ NMIs are /bad/ and they want to catch _every_ NMI, log it, and
> > reboot the system.
> 
> That's my point. If you have drivers which can identify all other
> NMIs then the left over NMIs must come from that watchdog driver.
> So they just need drivers which can do that for their chipsets.

Except their chipsets are _not_ producing NMIs.  They just want to
supercede all the other NMI handlers.  For example if an EDAC NMI came in,
they don't want the EDAC handler to try and recover from it, HP just wants
their NMI watchdog to grab the NMI, log it and reboot.

> 
> It's not race free, but that's simply not possible with the x86
> NMI architecture.

I agree.

> 
> Better would be probably to just configure the watchdog 
> to reboot the system directly on its own. Most other watchdogs
> I'm aware of do that. That's more reliable anyways because the system
> might be wedged enough to not be able to process NMIs anymore.

The trick is they want to log it in a special way (BIOS or NVRAM or
something I forget) before rebooting.

> 
> > 
> > Now obviously NMIs from kgdb and oprofile are not the ones a system should
> > panic on but this breaks HP's assumptions.
> > 
> > So that is part of the problem.  How do you become a catch-all for NMIs in
> > a system, to process as you wish, but ignore all the 'safe' NMIs?
> 
> To be fully reliable: you need a new NMI architecture or move the event
> somewhere else.
> To be reasonable reliable (assuming NMis are not very frequent): you
> need drivers for all NMI sources that can identify them.

Yeah I know.  Originally I thought this would be easy, just replace the
default handler.  But once the mention of kgdb and oprofile using the NMIs
came up, I realized we are almost back to square one. :-(

Cheers,
Don
