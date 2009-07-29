Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZG2LRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZG2LRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZG2LRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:17:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52164 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753681AbZG2LRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:17:41 -0400
Date: Wed, 29 Jul 2009 12:17:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729121753.41d2dd4b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907281814400.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
	<20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
	<20090728180649.596c5412@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
	<20090728195651.3a402a31@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
	<20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
	<20090729013442.493effa6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281736260.3161@localhost.localdomain>
	<alpine.LFD.2.01.0907281814400.3161@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IOW, the whole argument really hinges on the fact that calling 
> flush_to_ldisc() manually (without any locking) is really not 
> fundamentally any different from the delayed work doing it from a timer. 

Which means the hangup path should be doing a cancel_delayed_work() in
the case where its not resetting the termios as well and since it isn't
you can't actually (fingers crossed) make the problem worse, its merely as
broken as before.

Ok

> And when we _do_ disable the timer, we also make that flush_to_ldisc() 
> function be a no-op, so the "tty_ldisc_halt()" effectively stops both the 
> timer and (conceptually) the manual call case too. 
> 
> So now we have one remaining case, namely the case of the ldisc then being 
> re-initialized and TTY_LDISC is set again. But at that point, calling 
> flush_to_ldisc() had better be ok again, wouldn't you agree?

The ldisc re-init via SETD should be fine as it locks versus hangup
anyway and always has to.

