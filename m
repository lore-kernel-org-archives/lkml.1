Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZG2TIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZG2TIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZG2TIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:08:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZG2TIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:08:09 -0400
Date: Wed, 29 Jul 2009 12:07:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090729173955.125a7ae0@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907291147570.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
 <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain> <20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <20090729013442.493effa6@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281736260.3161@localhost.localdomain> <20090729095923.4ca5ca3e@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907290842420.3161@localhost.localdomain>
 <20090729165513.2a1ccb7c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907290859230.3161@localhost.localdomain> <20090729173955.125a7ae0@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Jul 2009, Alan Cox wrote:
> 
> Odds of hitting it minimal however. Or maybe we need a smarter
> tty_ldisc_wait_idle(ld) ?

Just adding the ldisc_mutex around the call sounds like the simplest 
solution. 

That said, looking at the callers of tty_ldisc_wait_idle(), it looks like 
we have other similar problems already in tty_ldisc_release(), which also 
calls it without holding the lock, both for the "self" case and then 
recursively for o_tty.

Moving the mutex_lock() up a bit in tty_ldisc_release() looks like the 
trivial solution, although I suspect there are any deadlock issues there 
(ie refs that won't go away because we hold the lock and the thing we are 
waiting for needs the lock to release the ldisc!).

So making tty_ldisc_wait_idle() more careful adn work without the lock 
would definitely be the safer thing to do. Requiring the lock looks 
potentially pretty dangerous.

		Linus
