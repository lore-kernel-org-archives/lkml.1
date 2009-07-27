Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZG0Uwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZG0Uwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZG0Uwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:52:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47578 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474AbZG0Uww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:52:52 -0400
Date: Mon, 27 Jul 2009 21:52:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727215250.034f7d4b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
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
	<alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 12:40:11 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 28 Jul 2009, OGAWA Hirofumi wrote:
> > 
> > If I read that part of emacs correctly, it seems to be assuming the data
> > was already sent to master side if the child process was exited.
> 
> That sounds like a rather obvious assumption.

> Aren't pty's flushing the data at flush() time? Which should be happening 
> when the child process exits and closes the pty slave.

When you close the slave the device all the data has been queued to the
master

> So at what point do we just admit that the commit that caused all this was 
> a buggy pile of sh*t and just revert it?

If we could "just revert it" and get a sane tree I'd have asked you to do
so quite some time ago and readdressed it later.

We can't "just revert it" or I'd have deferred it for the next release. If
you revert it you

- introduce a DoS attack
- break ppp
- introduce a pile of other tty races including at least one where the
  right timings should let you jump through null pointers
- put back all sorts of random obscure hangs caused by all the lock
  violations

and you'll note I pointed out this was a late change I was forced to make
and really didn't want to in the original commit.

Nor can we revert several patches because the ppp stuff means going back
to about 2.6.28 or so for the entire tty layer plus some of the DoS and
null pointer races go back to 2.2 or 2.0 8(.

We can use the two line slightly imperfect quickfix which people reported
does fix their problem and I'm tempted to go with that for 2.6.31 because
it works for the real world cases that matter.

Alan
