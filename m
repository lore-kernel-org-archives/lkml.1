Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXB1Jws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXB1Jws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXB1Jws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:52:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXB1Jwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:52:47 -0500
Date: Wed, 28 Feb 2007 10:45:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070228094522.GA17716@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.8 required=5.9 tests=BAYES_00,RISK_FREE autolearn=no SpamAssassin version=3.0.3
	0.2 RISK_FREE              BODY: Risk free.  Suuurreeee....
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > my current thinking is that special-purpose (non-programmable, 
> > static) APIs like aio_*() and lio_*(), where every last cycle of 
> > performance matters, should be implemented using syslets - even if 
> > it is quite tricky to write syslets (which they no doubt are - just 
> > compare the size of syslet-test.c to threadlet-test.c). So i'd move 
> > syslets into the same category as raw syscalls: pieces of the raw 
> > infrastructure between the kernel and glibc, not an exposed API to 
> > apps. [and even if we keep them in that category they still need 
> > quite a bit of API work, to clean up the 32/64-bit issues, etc.]
> 
> Why can't aio_* be implemented with *simple* (or parallel/unrelated) 
> syscall submit w/out the burden of a complex, limiting and heavy API

there are so many variants of what people think 'asynchronous IO' should 
look like - i'd not like to limit them. I agree that once a particular 
syslet script becomes really popular, it might (and should) in fact be 
pushed into a separate system call.

But i also agree that a one-shot-syscall sys_async() syscall could be 
done too - for those uses where only a single system call is needed and 
where the fetching of a single uatom would be small but nevertheless 
unnecessary overhead. A one-shot async syscall needs to get /8/ 
parameters (the syscall nr is the seventh parameter and the return code 
of the nested syscall is the eighth). So at least two parameters will 
have to be passed in indirectly and validated, and 32/64-bit compat 
conversions added, etc. anyway!

The copy_uatom() assembly code i did is really fast so i doubt there 
would be much measurable performance difference between the two 
solutions. Plus, putting the uatom into user memory allows the caching 
of uatoms - further dilluting the advantage of passing in the values per 
register. The whole difference should be on the order of 10 cycles, so 
this really isnt a high prio item in my view.

> Now that chains of syscalls can be way more easily handled with 
> clets^wthreadlets, why would we need the whole syslets crud inside?

no, threadlets dont really solve the basic issue of people wanting to 
'combine' syscalls, avoid the syscall entry overhead (even if that is 
small), and the desire to rely on kthread->kthread context switching 
which is even faster than uthread->uthread context-switching, etc. 
Furthermore, syslets dont really cause any new problem. They are almost 
totally orthogonal, isolated, and cause no wide infrastructure needs.

as long as syslets remain a syscall-level API, for the measured use of 
the likes of glibc and libaio (and not exposed in a programmable manner 
to user-space), i see no big problem with them at all. They can also be 
used without them having any classic pthread user-state (without linking 
to libpthread). Think of it like the raw use of clone(): possible and 
useful in some cases, but not something that a typical application would 
do. This is a 'raw syscall plugins' thing, to be used by those 
user-space entities that use raw syscalls: infrastructure libraries. Raw 
syscalls themselves are tied to the platform, are not easily used in 
some cases, thus almost no application uses them directly, but uses the 
generic functions glibc exposes.

in the long run, sys_syslet_exec(), were it not to establish itself as a 
widely used interface, could be implemented purely from user-space too 
(say from the VDSO, at much worse performance, but the kernel would stay 
backwards compatible with the syscall), so there's almost no risk here. 
You dont like it => dont use it. Meanwhile, i'll happily take any 
suggestion to make the syslet API more digestable.

	Ingo
