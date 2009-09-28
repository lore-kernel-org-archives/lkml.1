Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZI1GT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZI1GT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZI1GT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:19:57 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44668 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZI1GT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:19:57 -0400
Date: Mon, 28 Sep 2009 15:19:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rob Landley <rob@landley.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] 2.6.31 kernel built for sh4 doesn't boot under qemu-system-sh4.
Message-ID: <20090928061922.GA6668@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
References: <200909201919.17990.rob@landley.net> <20090925084430.GA14363@linux-sh.org> <200909280111.54976.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909280111.54976.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 01:11:54AM -0500, Rob Landley wrote:
> On Friday 25 September 2009 03:44:30 Paul Mundt wrote:
> > > >trapped io 0xc0000000 overrides mmio 0xb4001000
> > > >trapped io 0xc0001000 overrides mmio 0xb400080c
> >
> > Also, you do not want to be using trapped io with qemu, it is only there
> > to aid broken hardware, and degrades performance under emulation. Boot
> > with the "noiotrap" argument on the kernel command line, documented in
> > Documentation/kernel-parameters.txt.
> 
> Is _that_ why it's so slow?  Thanks.
> 
Yes, you can see more about it here:

http://marc.info/?t=123850681600007&r=1&w=2

This isn't a problem for most platforms, but unfortunately it is for the
one that qemu has chosen to emulate. It would be nice if we had a way to
figure out if we were under emulation from the kernel side, then these
sorts of things can be tuned automatically.

> > > #
> > > # Timer and clock configuration
> > > #
> > > # CONFIG_SH_TIMER_TMU is not set
> > > CONFIG_SH_PCLK_FREQ=60000000
> > > CONFIG_SH_CLK_CPG=y
> > > CONFIG_SH_CLK_CPG_LEGACY=y
> > > # CONFIG_NO_HZ is not set
> > > # CONFIG_HIGH_RES_TIMERS is not set
> > > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> >
> > And here we can see that the TMU option is unset. Fix this up and
> > everything should be fine.
> 
> Yup, that did it.
> 
I suppose we should see about making it impossible to run in to this
situation in the future. I'll see if I can come up with something clever
in Kconfig to make sure at least one gets enabled. 'choice' semantics are
not sufficient, given that many platforms require multiple timers to be
enabled.

> > It's actually quite remarkable how far you
> > made it in the boot process without a timer interrupt.
> 
> Tickless kernels, gotta love 'em. :)
> 
You would have never made it past the delay loop calibration, except for
the fact that we don't use the timer for that, we calculate the value
directly from the clock framework, so there is no 'real' calibration.
