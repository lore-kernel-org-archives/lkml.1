Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZKIMEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZKIMEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZKIMEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:04:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41196 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZKIMEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:04:41 -0500
Date: Mon, 9 Nov 2009 13:04:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091109120445.GC26740@basil.fritz.box>
References: <1257682930-31401-22-git-send-email-ebiederm@xmission.com> <20091108123422.GA9145@flint.arm.linux.org.uk> <m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org> <20091108164855.595ec70d@infradead.org> <m1tyx49y44.fsf@fess.ebiederm.org> <20091108205725.28778016@infradead.org> <m1hbt45kcp.fsf@fess.ebiederm.org> <87ocnc598i.fsf@basil.nowhere.org> <m1my2vyla5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1my2vyla5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 03:45:06AM -0800, Eric W. Biederman wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > ebiederm@xmission.com (Eric W. Biederman) writes:
> >>
> >> The glibc pthread code that uses sysctl has no problems if sys_sysctl
> >> is gone.  It both falls back to reading /proc/sys and it just controls
> >> an optimization and the code works with either result.  Been there,
> >> done that.
> >
> > /proc/sys is much slower than sysctl though. So you made program startup
> > slower.
> 
> Not much slower, but slower. I just measured it in a case that favors
> sysctl and the ration is about 5:2.  Or sysctl is about 2.5x faster.
> About 49usec for open/read/close on proc and 19usec for sysctl.
> In my emulation it is a bit slower than that.

That's not good.

> 
> > Also I agree with Arjan that breaking such a common ABI is not
> > really a good idea. But I think it's enough to only handle
> > common sysctls that are actually used, which are very few.
> 
> Well I haven't broken anything at this point.  I am simply edging
> us to the point when we are close to being able to forget about
> sys_sysctl for good.

I think all-or-nothing that you have right now is a bad trade-off
because it breaks an established interface used by lots of code (glibc)

You should have three states

a) all
b) common ones used by glibc and perhaps a few others only
c) none

I suspect most users would use (b), in fact (c) might be redundant
if (b) is cheap enough (which it should be)
> As for the rest the common number of sysctls with glibc > 2.8 is
> exactly 0.  Which makes compiling out sys_sysctl support sane.
> Especially since we have been throwing a warning for years if
> anyone uses any of the others.

Yes, but people ignore the warning. Perhaps should make it a WARN()
and track it with kernelops?

> 
> > It would be better to simply keep the commonly used binary sysctls
> > as emulation around always (commonly = used by glibc and perhaps
> > added by user printk feedback) That's very cheap because it's just
> > a simple translation and can be done internally cheaper than going
> > through the VFS with a bazillion of locks.
> 
> A micro optimization for code that does not exist.  That is a bad
> trade off.

Hmm? There's plenty of glibc code that uses the binary sysctl.


> Further it is my intention to optimize /proc/sys when I get the
> chance now that we don't have all of the old sysctl baggage holding
> back the code.

The VFS will always be comparably slow I suspect; I'm not sure
you can optimize it that much compared to a fast custom path
(especially handling the kernel version should be really fast)

> Ultimately what drives me most is that people are still accidentally
> adding binary sysctls, which no one uses or tests.  For a recent
> example see:

Yes I agree new binary sysctls should just be deprecated right now.

-Andi
