Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZHKNKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZHKNKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZHKNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:10:19 -0400
Received: from mail2.shareable.org ([80.68.89.115]:44181 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZHKNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:10:18 -0400
Date: Tue, 11 Aug 2009 14:10:09 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: stephane eranian <eranian@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
Message-ID: <20090811131009.GB29354@shareable.org>
References: <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com> <20090809054601.GA26152@shareable.org> <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com> <20090810170338.GA14223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810170338.GA14223@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Agreed, this looks a bit odd. But at least this is documented. From
> man 2 fcntl:
>
> 	By using F_SETSIG with a nonzero value, and setting SA_SIGINFO
> 	for the signal handler (see sigaction(2)), extra information
> 	about I/O events is passed to the handler in a siginfo_t
> 	structure.  If the si_code field indicates the source is
> 	SI_SIGIO, the si_fd field gives the file descriptor associated
> 	with the event.  Otherwise, there is no indication which file
> 	descriptors are pending,
> 
> Not sure if it is safe to change the historical behaviour.

The change in 2.6.12 breaks some code of mine, which uses RT queued
I/O signals on multiple threads but as far as I know it's not used
anywhere now.

In the <= 2.4 era, there were lots of web servers and benchmarks using
queued I/O signals for scalable event-driven I/O, but I don't know of
any implementation who dared do it with multiple threads, except mine.

It was regarded as "beware ye who enter here" territory, which I can
attest to from the long time it took to get it right and the multitude
of kernel bugs and version changes needing to be worked around.

Since 2.6, everyone uses epoll which is much better, except that
occasionally SIGIO comes in handy when an async notification is
required.

So the change in 2.6.12 does break something that probably isn't much
used, but it's too late now.  Occasionally thread-specific SIGIO (or
F_SETSIG) is useful; F_SETOWN_TID makes that nice and clear.

I would drop the pseudo-"bug compatible" behaviour of using negative
tid to mean pid; that's pointless.  I'd also make F_GETOWN return an
error when F_SETOWN_TID has been used, and F_GETOWN_TID return an
error when F_SETOWN has been used.

> (the manpage is not exactly right though, and the comment in
> send_sigio_to_task() is not right too: SI_SIGIO (and, btw,
> SI_QUEUE/SI_DETHREAD) is never used).

Ah, there's another historical change you see.  It was changed in
2.3.21 from SI_SIGIO to POLL_xxx, and si_band started being set at the
same time.  The man page could be updated to reflect that.

(My portable-to-ancient-Linux code checks for si_code == SI_SIGIO, in
which case it has the descriptor but doesn't know what type of event
(pre 2.3.21) so adds it to a poll() set, or checks for si_code ==
POLL_xxx, in which case it ignores the si_code value completely and
looks at si_band for the set of pending events because some patch that
was never mainlined could result in multiple si_band bits set).

-- Jamie
