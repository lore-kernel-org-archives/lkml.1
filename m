Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZG1Qmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZG1Qmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZG1Qmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:42:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46789 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbZG1Qmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:42:39 -0400
Date: Tue, 28 Jul 2009 17:42:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728174213.5e927428@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 08:49:29 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 28 Jul 2009, Alan Cox wrote:
> > 
> > Given the assumptions in emacs are wrong, low_latency fixes the real
> > world cases and we are standards compliant perhaps we are trying too
> > hard ?
> 
> Alan, I really don't understand why you seem to argue _for_ bad code, and 
> not just fixing it. You seem to think that it's ok to leave stuff in 
> buffers and ignore it, just because the other end might have exited. 
> 
> That seems disingenious and stupid. Why argue for crap?

We don't ignore it. What goes in one end comes out the other after tty
processing (ldisc, echo etc). Reliably. Both the EOF fix and the
tty->low_latency fix cure that. [The low latency one also provides the
*exact* same semantics as we had prior to 2.6.31-rc as well]

If I understand Ogawa correctly then what emacs thinks is true is quite
different: Emacs thinks that

	write(pty, "data", length)
	close(pty)
	exit()

will always ensure that the other end has already got the data before
close() completes - or to be more exact before the parent receives SIGCLD.

Unfortunately as both ends could do

	write(pty, "enough to fill all the buffers but not block")
	close(pty)

at the same time it doesn't strike me as a good idea because it will
deadlock.

Ogawa's latest experiment is actually quite interesting which is to also
run the ldisc processing off the back of the user context. Unfortunately
that breaks assorted assumptions in the kernel because the
close/hangup/ldisc change paths believe that if they kill the work queue
for feeding data into the ldisc then the ldisc will stop receiving
data. It believes that therefore the ldisc will not do things like call
the write method to echo data back to a device which has gone away, which
generally involves jumping through null pointers.

So to be clear: WE DO NOT LOSE DATA.


