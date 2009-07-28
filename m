Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZG1KVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZG1KVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZG1KVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:21:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45792 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431AbZG1KV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:21:27 -0400
Date: Tue, 28 Jul 2009 11:22:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728112203.7b70adba@lxorguk.ukuu.org.uk>
In-Reply-To: <87r5w19xsb.fsf@devron.myhome.or.jp>
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
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 14:33:40 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> And if it's right, unfortunately, I guess we can't return -EAGAIN in
> >> this case to preserve behavior.
> >
> > To avoid the EAGAIN the close needs to block until all queued I/O has
> > been processed by the ldisc the other end. That's not standards
> > guaranteed or even what happens with a non pty port, but it is doable
> > unless you take signals - we can't block signals or it can all deadlock.
> 
> Just a quick hack though. Is this wrong/unpreferable way?
> 
> n_tty_read() checks the pending buffer and consume it before
> input_available_p().

That won't change the fact that the process could have exited. You can
fix the -ENXIO reporting that way (and it is basically what the
EOFPENDING/EOF patch did), but the only way I can see to fix the
assumption that the process exit means all the data is in the ldisc the
other end ready to use is to actually to make the close() path block -
but with some kind of limits to prevent deadlocks.

Given the assumptions in emacs are wrong, low_latency fixes the real
world cases and we are standards compliant perhaps we are trying too
hard ?

