Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbXE0JEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbXE0JEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 05:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXE0JEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 05:04:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33958 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXE0JEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 05:04:43 -0400
Date: Sun, 27 May 2007 11:05:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Indan Zupancic <indan@nul.nu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070527090542.GA18399@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru> <20070521151139.GA1929@uranus.ravnborg.org> <4498.81.207.0.53.1180181244.squirrel@secure.samage.net> <200705261802.08573.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705261802.08573.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 06:02:08PM +0200, Andi Kleen wrote:
> On Saturday 26 May 2007 14:07:24 Indan Zupancic wrote:
> 
> > 
> > Did the patches reach 2.6.22-rc3 yet?
> 
> No.
> 
> > 
> > If they did, then the following warnings might need fixing:
> 
> There is already one patch queued for it. But actually in my experience I cannot
> remember a single real bug showed by these warnings. All were false positives
> and there are always more of them.
> 
> Maybe it would be best to disable these warnings again; not much good 
> seems to come from them.
We recently had one bug releated to cpu* functions that was caused by wrong
section handling.
The whole purpose with __init and friends are the possibility to drop
the .init.text (+ .init.data) section when the kernel is up and running.

So if we have:

void __init deep_init()
{
	not_so_deep_init();
}

void not_so_deep_init()
{
	not_deep_init();
}

void __init not_deep_init()
{
	...;
}

Then without the warnings we would never drop not_so_deep_init().
So the warnigns serve two purposes:

1) highlight places where something ought to be marked __init but is not done so.
2) highlight places where we have a potential dangerous reference from .text to .init.text

While proposng to drop the warnings people refer to case: 2) and totally forbet about case 1).
For the actual case with mtrr we had a situation where we merged two patches.
So one was the right fix but the next was the wrong fix. So we ended up with some inconsistent
code which we were lucky that the build pointed out so we could get it fixed.

My objective is to kill all false positives 2.6.23 and that is doable.
There are some tricky thing to address in non x86 architectures - like a pending issue in sparc64
for instance.

So section mismatch warnings are more about catching sloopy usage of __init than it is to
catch potential kernel oopesen. But the latter is a nice side effect that is appreciated.

	Sam
