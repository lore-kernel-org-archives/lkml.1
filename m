Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZG1PsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZG1PsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZG1PsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:48:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbZG1PsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:48:19 -0400
Date: Tue, 28 Jul 2009 08:48:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <87r5w19xsb.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.01.0907280843050.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, OGAWA Hirofumi wrote:
> 
> Just a quick hack though. Is this wrong/unpreferable way?

That seems to be right regardless of any other issues.

> n_tty_read() checks the pending buffer and consume it before
> input_available_p().

Why not move this _inside_ "input_available_p()"? There are only two 
call-sites, and strictly speaking they both want it.

Look at n_tty_poll(), for example:

        if (input_available_p(tty, TIME_CHAR(tty) ? 0 : MIN_CHAR(tty)))
                mask |= POLLIN | POLLRDNORM;
        if (tty->packet && tty->link->ctrl_status)
                mask |= POLLPRI | POLLIN | POLLRDNORM;
        if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
                mask |= POLLHUP;
        if (tty_hung_up_p(file))
                mask |= POLLHUP;

and notice what happens to somebody who uses select/poll when there might 
be pending data that hasn't been handled yet, and the tty has been marked 
TTY_OTHER_CLOSED or hung up. It would return only POLLHUP, and as a 
result, that side would never even try to read the pending data because 
poll implies that there is no data and it's EOF. Which is just wrong.

So _any_ time you check "is there input available?" you should always 
check if there are other buffers. No?

		Linus
