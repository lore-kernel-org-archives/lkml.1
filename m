Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZC0QFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZC0QFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZC0QFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:05:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZC0QFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:05:03 -0400
Date: Fri, 27 Mar 2009 09:02:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mike Galbraith <efault@gmx.de>
cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
In-Reply-To: <1238168777.5969.18.camel@marge.simson.net>
Message-ID: <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>  <200903271435.23116.hpj@urpla.net>  <alpine.LRH.2.00.0903271552080.11064@vixen.sonytel.be> <1238168777.5969.18.camel@marge.simson.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Mike Galbraith wrote:
> > 
> > If you're using the kernel-of-they-day, you're probably using git, and
> > CONFIG_LOCALVERSION_AUTO=y should be mandatory.
> 
> I sure hope it never becomes mandatory, I despise that thing.  I don't
> even do -rc tags.  .nn is .nn until baked and nn.1 appears.

If you're a git user that changes kernels frequently, then enabling 
CONFIG_LOCALVERSION_AUTO is _really_ convenient when you learn to use it.

This is quite common for me:

	gitk v$(uname -r)..

and it works exactly due to CONFIG_LOCALVERSION_AUTO (and because git is 
rather good at figuring out version numbers). It's a great way to say 
"ok, what is in my git tree that I'm not actually running right now".

Another case where CONFIG_LOCALVERSION_AUTO is very useful is when you're 
noticing some new broken behavior, but it took you a while to notice. 
You've rebooted several times since, but you know it worked last Tuesday. 
What do you do?

The thing to do is

	grep "Linux version" /var/log/messages*

and figure out what the good version was, and then do 

	git bisect start
	git bisect good ..that-version..
	git bisect bad v$(uname -r)

and off you go. This is _very_ convenient if you are working with some 
"random git kernel of the day" like I am (and like hopefully others are 
too, in order to get test coverage).

> (would be nice if baked were immediately handed to stable .nn.0 instead
> of being in limbo for a bit, but I don't drive the cart, just tag along
> behind [w. shovel];)

Note that the "v2.6.29[-rcX" part is totally _useless_ in many cases, 
because if you're working past merges, and especially if you end up doing 
bisection, it is very possible that the main Makefile says "2.6.28-rc2", 
but the code you're working on wasn't actually _merged_ until after 
2.6.29. 

In other words, the main Makefile version is totally useless in non-linear 
development, and is meaningful _only_ at specific release times. In 
between releases, it's essentially a random thing, since non-linear 
development means that versioning simply fundamentally isn't some simple
monotonic numbering. And this is exactly when CONFIG_LOCALVERSION_AUTO is 
a huge deal.

(It's even more so if you end up looking at "next" or merging other 
peoples trees. If you only ever track my kernel, and you only ever 
fast-forward - no bisection, no nothing - then the release numbering looks 
"simple", and things like LOCALVERSION looks just like noise).

			Linus
