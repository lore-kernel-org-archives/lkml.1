Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZG1Qtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZG1Qtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZG1Qti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:49:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbZG1Qth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:49:37 -0400
Date: Tue, 28 Jul 2009 09:49:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090728174213.5e927428@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Alan Cox wrote:
> 
> We don't ignore it.

Yes we do. Look at Ogawa-san's patch. And read my email answer to it.

> What goes in one end comes out the other after tty
> processing (ldisc, echo etc). Reliably. Both the EOF fix and the
> tty->low_latency fix cure that. [The low latency one also provides the
> *exact* same semantics as we had prior to 2.6.31-rc as well]

I agree that the low-latency thing should fix things, and I applied it. 
But I think that Ogawa's patch is fundamentally "correct" at a much higher 
level. Rather than depend on low-latency being set, it just "Does The 
Right Thing(tm)", by making sure that readers never even look at the EOF 
bits etc until they have flushed the tty ldisc state.

> If I understand Ogawa correctly then what emacs thinks is true is quite
> different: Emacs thinks that
> 
> 	write(pty, "data", length)
> 	close(pty)
> 	exit()
> 
> will always ensure that the other end has already got the data before
> close() completes - or to be more exact before the parent receives SIGCLD.

.. and depending on what emacs does with signals and it's select() loop, 
that may actually be _entirely_reasonable_.

Imagine being in 'select()' (or read, for that matter), and getting EINTR 
due to SIGCHLD. What is the correct expectations?

The correct expectation is that the select() (or read()) should have 
returned any data that it saw _before_ it returns EINTR.

		Linus
