Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZG2Qjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZG2Qjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZG2Qjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:39:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58799 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754452AbZG2Qjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:39:39 -0400
Date: Wed, 29 Jul 2009 17:39:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729173955.125a7ae0@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907290859230.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
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
	<20090729095923.4ca5ca3e@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907290842420.3161@localhost.localdomain>
	<20090729165513.2a1ccb7c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907290859230.3161@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  		tty_ldisc_deref(ld);
> +		tty_ldisc_halt(tty);
> +		tty_ldisc_wait_idle(tty);

Needs to be
	mutex_lock(&tty->ldisc_mutex);
	if (tty->ldisc)
		....
	}
	mutex_unlock(&tty->ldisc_mutex)

We can't wait for the reference to go away if we hold one, and if we
don't hold one the ldisc reference might go away during the hangup if we
close()

Odds of hitting it minimal however. Or maybe we need a smarter
tty_ldisc_wait_self_idle(ld) ?

