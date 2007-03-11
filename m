Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbXCKAmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbXCKAmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 19:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXCKAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 19:42:55 -0500
Received: from gw.goop.org ([64.81.55.164]:42862 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXCKAmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 19:42:54 -0500
Message-ID: <45F35088.7020607@goop.org>
Date: Sat, 10 Mar 2007 16:42:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Use of absolute timeouts for oneshot timers
References: <45F33697.4000000@goop.org> <1173568491.24738.1194.camel@localhost.localdomain>
In-Reply-To: <1173568491.24738.1194.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> It's simply enforced in NO_HZ, HIGHRES mode as we operate in absolute
> time, which is read back from the clocksource, even if we use a relative
> value for real hardware clock event devices to program the next event.
> We calculate the delta between the absolute event and now. So we never
> get an accumulating error.
>
> What problem are you observing ?

Actually, two things.  There was the unexpected pauses during boot,
which is trivially fixable by not using the Xen periodic timer, and
using the single-shot fallback.

But I'm making the more general observation that if you use an absolute
rather than relative time to set the single-shot timeout, then you have
to deal with a long-term cumulative drift between the kernel's monotonic
time and the hypervisor's monotonic time.  This can happen even if your
clocksource is derived directly from the hypervisor monotonic time,
because running ntp will warp the kernel's time, and so it will drift
with respect to the hypervisor clock.  You can only avoid this by 1) not
allowing adjtime, or 2) making those same adjtime warps to the
hypervisor time.  Neither of these is a good general solution.

Therefore, the only useful way to set a single-shot timer is by using
relative rather than absolute time, and making sure the delta not too
large.  The guest and hypervisor may (and in general, will) have
drifting clocks, but the error will never be too large to deal with.

    J
