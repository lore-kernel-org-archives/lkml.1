Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZG0VTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZG0VTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZG0VTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:19:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51855 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754596AbZG0VTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:19:45 -0400
Date: Mon, 27 Jul 2009 22:20:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
In-Reply-To: <87skgikjr8.fsf@devron.myhome.or.jp>
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
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > My T60p lenovo laptop. If you can send me a debug prink patch i can redo the
> > test with the patches. I don't know what data i should start collecting so
> > that it make sense. This is the patch i tried
> 
> If I read that part of emacs correctly, it seems to be assuming the data
> was already sent to master side if the child process was exited.

Oops.. that would be rather buggy.

It is true that the data has left the slave. It is not neccessarily true
the data has arrived on the master before the call to close() completes.

We can fake that but what the hell are the semantics if the process on
the master blocks or if both processes each end fill the queue and then
close so no data can be consumed.

> And if it's right, unfortunately, I guess we can't return -EAGAIN in
> this case to preserve behavior.

To avoid the EAGAIN the close needs to block until all queued I/O has
been processed by the ldisc the other end. That's not standards
guaranteed or even what happens with a non pty port, but it is doable
unless you take signals - we can't block signals or it can all deadlock.
