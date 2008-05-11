Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYEKNnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYEKNnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYEKNnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:43:41 -0400
Received: from www.tglx.de ([62.245.132.106]:47507 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbYEKNnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:43:40 -0400
Date: Sun, 11 May 2008 15:43:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: better msleep for drivers
In-Reply-To: <20080511110124.GA24187@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0805111408440.3197@apollo.tec.linutronix.de>
References: <20080511110124.GA24187@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Sun, 11 May 2008, Andi Kleen wrote:
> Someone asked if there is a msleep using hrtimers that is more accurate
> than jiffies/msecs for external drivers. There is hrtimer nanosleep,
> but it is currently not exported. It can be reimplemented using hrtimer_start
> etc. which are exported, but that seems rather clumpsy.
> 
> Is there any reason such an obvious function is not exported? 

Well, there was not yet a request / requirement for it.

> Ok I guess right now nobody in tree is using it. But that seems wrong.  
> Perhaps we should have a (exported) usleep_blocking() wrapper or somesuch for 
> that case?  
> 
> I suspect that a lot of drivers could make use of it. Just from grepping we 
> have a lot of msleep(1)s in drivers and I suspect a lot of those would 
> actually like to delay shorter than one jiffie.

Depends, lots of them are just the kind of "lets delay it a bit" with
no real requirement to be accurate. I agree that there are use cases
which could benefit from a more precise sleep facility than msleep
actually is, but we need to have a careful eye on the possible abuse
of such an interface.

> One argument against it would be that it makes them more difficult to test 
> because behavior will differ between hrtimer enabled and disabled systems. 

That's what other in tree hrtimer users already face today. scheduler,
networking and the user space interfaces. So that should be not a too
big problem as the hrtimer infrastructure guarantees that the timer
does not expire early whether highres is enabled or not. It's just
less finegrained with highres=off and that's just the same as we have
right now with msleep().

> Still longer term I suppose there's really no way around having accurate
> sleep functions and it's probably better to start testing earlier than later.

No objections, but we should not do that with a stupid msleep
replacement interface; instead we should expose a flexible in kernel
variant of hrtimer_nanosleep() which lets the user utilize
ABS/REL_TIME and the different clocks. A msleep helper can be built on
top of this very easily.

Thanks,
	tglx
