Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZFAXDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZFAXDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZFAXDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:03:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZFAXDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:03:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
In-Reply-To: Oleg Nesterov's message of  Tuesday, 2 June 2009 00:32:41 +0200 <20090601223241.GA26788@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
	<20090601184608.6379440c@lxorguk.ukuu.org.uk>
	<20090601182305.GA16372@redhat.com>
	<20090601203845.B010DFC3C7@magilla.sf.frob.com>
	<20090601223241.GA26788@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090601230210.C0B15FC3C7@magilla.sf.frob.com>
Date: Mon,  1 Jun 2009 16:02:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think ->real_blocked is a good choice, we have to add more checks
> to the signal sending path. Note that currenly it is only checked under
> sig_fatal() && !SIGNAL_GROUP_EXIT.

No, you're right.  It's not a good idea.

> Perhaps it is easier to change dump_write() to clear TIF_SIGPENDING
> unless fatal_signal_pending(),

That is almost a separate subject, really.  Having i/o calls' waits wrongly
interrupted and then clearing TIF_SIGPENDING just seems goofy to me.  It
might not be just the ->write call, it might affect filp_open or dump_seek
or whatever.  It makes no sense to me to take the approach of fiddling
after doing the wrong thing.  Just don't do the wrong thing to begin with.

That means clear TIF_SIGPENDING and don't let it be set again by a signal
that is not meant to abort the core dump.  Why do anything but that?

It's almost certain that recalc_sigpending_tsk won't be called once dumping
has started.  But there is the possibility of recalc_sigpending_and_wake
via cancel_freezing, at least.  Seems safer to make recalc_sigpending_tsk
robust in this case.


Thanks,
Roland
