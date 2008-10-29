Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJ2JOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJ2JOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYJ2JOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:14:09 -0400
Received: from kandzendo.ru ([195.178.208.66]:45067 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYJ2JOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:14:07 -0400
Date: Wed, 29 Oct 2008 12:14:05 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, jkosina@suse.cz, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, s0mbre@tservice.net.ru,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081029091405.GA3780@ioremap.net>
References: <20081027113306.5b1d5898@lxorguk.ukuu.org.uk> <20081027183312.GD11494@elte.hu> <20081027193933.GB2590@ioremap.net> <20081027.124848.163119274.davem@davemloft.net> <1225189462.4903.238.camel@marge.simson.net> <20081028103741.GA22319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081028103741.GA22319@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Cooled down? Let's start over the sched vs network fight.

On Tue, Oct 28, 2008 at 11:37:41AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> What's your gut feeling, is that remaining small regression scheduler 
> or networking related?
> 
> i'm cutting the ball in half and i'm passing over one half of it to 
> the networking folks, because your numbers show _huge_ sensitivity in 
> this workload, depending on networking settings:

Sorry for interrupting your conversation, Ingo, but before throwing
a stone one should be clear himself, doesn't it? When you asked to
test -tip tree and it was showed it regressed about 20 MB/s in my
test against the last tweaks you suggested, -tip still was merged and no
work on this issue was performed. Now previous tweaks (nohrticks and
nobalalance, and although hrticks are now disabled, performance did not
return to the vanilla .27 with tweaks) do not help anymore, so
apparently there is additional problem.

So for the reference:
vanilla 27	: 347.222
no TSO/GSO	: 357.331
no hrticks	: 382.983
no balance	: 389.802
4403b4 commit	: 361.184
dirty_ratio-50	: 361.086
no-sched-tweaks	: 361.367

So scheduler _does_ regress even right now when this thread is being
discussed.

Now let's return to the network. Ilpo Järvinen showed a nasty modulo
operation in the fast path which David thinks on how to resolve it, but
it happend that this change was introduced back in 2005, and although
some naive change allows to increase performance upto 370 MB/s, i.e. it
gained us 2.5%, this was never accounted in previous changes.

So, probably, if we revert -tip merge to vanilla .27, add nohrtick patch
and nobalance tweak _only_, and apply naive TSO patch we could bring
system to 400 MB/s. Note, that .22 has 479.82 and .23 454.36 MB/s.

-- 
	Evgeniy Polyakov
