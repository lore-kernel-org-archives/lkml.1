Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZKIN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZKIN23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZKIN23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:28:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46255 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZKIN22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:28:28 -0500
Date: Mon, 9 Nov 2009 14:28:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091109132830.GF26740@basil.fritz.box>
References: <m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org> <20091108164855.595ec70d@infradead.org> <m1tyx49y44.fsf@fess.ebiederm.org> <20091108205725.28778016@infradead.org> <m1hbt45kcp.fsf@fess.ebiederm.org> <87ocnc598i.fsf@basil.nowhere.org> <m1my2vyla5.fsf@fess.ebiederm.org> <20091109120445.GC26740@basil.fritz.box> <m1zl6vvpiv.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zl6vvpiv.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 04:41:44AM -0800, Eric W. Biederman wrote:
> >> >> The glibc pthread code that uses sysctl has no problems if sys_sysctl
> >> >> is gone.  It both falls back to reading /proc/sys and it just controls
> >> >> an optimization and the code works with either result.  Been there,
> >> >> done that.
> >> >
> >> > /proc/sys is much slower than sysctl though. So you made program startup
> >> > slower.
> >> 
> >> Not much slower, but slower. I just measured it in a case that favors
> >> sysctl and the ration is about 5:2.  Or sysctl is about 2.5x faster.
> >> About 49usec for open/read/close on proc and 19usec for sysctl.
> >> In my emulation it is a bit slower than that.
> >
> > That's not good.
> 
> Why?

Because it slows down a very common path.

> >
> > a) all
> > b) common ones used by glibc and perhaps a few others only
> > c) none
> >
> > I suspect most users would use (b), in fact (c) might be redundant
> > if (b) is cheap enough (which it should be)
> 
> Next year I expect b == c.

Only if you ignore ABI compatibility.

> 
> If you think we need something better additional patches to sysctl_binary.c
> are welcome.  Just add your custom fast path before the through the
> VFS.

I think sysctl_binary should be just stripped down for common sysctls
(at least with a CONFIG)

> > Hmm? There's plenty of glibc code that uses the binary sysctl.
> 
> Where?  I grepped glibc today.  The only use in a recent glibc is
> in glibc-ports for the support of arm inb/outb.  The only other
> use in older glibc was checking to see if we ran on an SMP kernel.

That older glibc is widely deployed. And it won't go away next year.

> >> Ultimately what drives me most is that people are still accidentally
> >> adding binary sysctls, which no one uses or tests.  For a recent
> >> example see:
> >
> > Yes I agree new binary sysctls should just be deprecated right now.
> 
> Good.  The only way to keep new ones from showing up is to that I know
> of is to move everything into an emulation layer.  I have done the heavy
> lifting there and everything is emulated using the exact same code.

I agree with that.

I just think you should have two flavours of emulation layer:
full and "common sysctls". This can be probably done with the same
code and some strategic ifdefs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
