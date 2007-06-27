Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXF0WON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXF0WON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbXF0WN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:13:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbXF0WN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:13:58 -0400
Date: Wed, 27 Jun 2007 15:11:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <Pine.LNX.4.64.0706271310550.5219@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0706271500260.8675@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
 <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706271310550.5219@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Davide Libenzi wrote:
> > 
> > Now, I have good reason to believe that all Intel and AMD CPU's have a 
> > stricter-than-documented memory ordering, and that your spinlock may 
> > actually work perfectly well. But it still worries me. As far as I can 
> > tell, there's a theoretical problem with your spinlock implementation.
> 
> Nice catch ;) But wasn't Intel suggesting in not relying on the old 
> "strict" ordering rules?

Actually, both Intel and AMD engineers have been talking about making the 
documentation _stricter_, rather than looser. They apparently already are 
pretty damn strict, because not being stricter than the docs imply just 
ends up exposing too many potential problems in software that didn't 
really follow the rules.

For example, it's quite possible to do loads out of order, but guarantee 
that the result is 100% equivalent with a totally in-order machine. One 
way you do that is to keep track of the cacheline for any speculative 
loads, and if it gets invalidated before the speculative instruction has 
completed, you just throw the speculation away.

End result: you can do any amount of speculation you damn well please at a 
micro-architectural level, but if the speculation would ever have been 
architecturally _visible_, it never happens!

(Yeah, that is just me in my non-professional capacity of hw engineer 
wanna-be: I'm not saying that that is necessarily what Intel or AMD 
actually ever do, and they may have other approaches entirely).

> IOW shouldn't an mfence always be there? Not only loads could leak up 
> into the wait phase, but stores too, if they have no dependency with the 
> "head" and "tail" loads.

Stores never "leak up". They only ever leak down (ie past subsequent loads 
or stores), so you don't need to worry about them. That's actually already 
documented (although not in those terms), and if it wasn't true, then we 
couldn't do the spin unlock with just a regular store anyway.

(There's basically never any reason to "speculate" stores before other mem 
ops. It's hard, and pointless. Stores you want to just buffer and move as 
_late_ as possible, loads you want to speculate and move as _early_ as 
possible. Anything else doesn't make sense).

So I'm fairly sure that the only thing you really need to worry about in 
this thing is the load-load ordering (the load for the spinlock compare vs 
any loads "inside" the spinlock), and I'm reasonably certain that no 
existing x86 (and likely no future x86) will make load-load reordering 
effects architecturally visible, even if the implementation may do so 
*internally* when it's not possible to see it in the end result.

			Linus
