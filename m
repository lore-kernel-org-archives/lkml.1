Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZHQRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZHQRJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZHQRJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:09:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbZHQRJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:09:34 -0400
Date: Mon, 17 Aug 2009 19:05:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
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
Message-ID: <20090817170514.GA15907@redhat.com>
References: <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com> <20090809054601.GA26152@shareable.org> <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com> <20090810170338.GA14223@redhat.com> <20090811131009.GB29354@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811131009.GB29354@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply.

And I am a bit confused.

On 08/11, Jamie Lokier wrote:
>
> Oleg Nesterov wrote:
> > Agreed, this looks a bit odd. But at least this is documented. From
> > man 2 fcntl:
> >
> > 	By using F_SETSIG with a nonzero value, and setting SA_SIGINFO
> > 	for the signal handler (see sigaction(2)), extra information
> > 	about I/O events is passed to the handler in a siginfo_t
> > 	structure.  If the si_code field indicates the source is
> > 	SI_SIGIO, the si_fd field gives the file descriptor associated
> > 	with the event.  Otherwise, there is no indication which file
> > 	descriptors are pending,
> >
> > Not sure if it is safe to change the historical behaviour.
>
> The change in 2.6.12 breaks some code of mine, which uses RT queued
> I/O signals on multiple threads but as far as I know it's not used
> anywhere now.
>
> In the <= 2.4 era, there were lots of web servers and benchmarks using
> queued I/O signals for scalable event-driven I/O, but I don't know of
> any implementation who dared do it with multiple threads, except mine.
>
> It was regarded as "beware ye who enter here" territory, which I can
> attest to from the long time it took to get it right and the multitude
> of kernel bugs and version changes needing to be worked around.
>
> Since 2.6, everyone uses epoll which is much better, except that
> occasionally SIGIO comes in handy when an async notification is
> required.
>
> So the change in 2.6.12 does break something that probably isn't much
> used, but it's too late now.

So, you seem to agree we should not change this odd behaviour?

> Occasionally thread-specific SIGIO (or
> F_SETSIG) is useful; F_SETOWN_TID makes that nice and clear.

Great. If you agree with F_SETOWN_TID, could you look at the next
Peter's patch

	"[PATCH 3/2 -v4] fcntl: F_[SG]ETOWN_EX"
	http://marc.info/?l=linux-kernel&m=124956452125468

and ack it?

> I would drop the pseudo-"bug compatible" behaviour of using negative
> tid to mean pid; that's pointless.

done,

> I'd also make F_GETOWN return an
> error when F_SETOWN_TID has been used,

This is not trivial, F_GETOWN can't return the error. A negative
result means PIDTYPE_PGID.

> and F_GETOWN_TID return an
> error when F_SETOWN has been used.

F_GETOWN_EX does this even better.

Oleg.

