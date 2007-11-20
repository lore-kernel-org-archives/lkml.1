Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbXKTWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbXKTWXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbXKTWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:23:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbXKTWXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:23:07 -0500
Date: Tue, 20 Nov 2007 23:22:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zach Brown <zach.brown@oracle.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
Message-ID: <20071120222227.GH24156@elte.hu>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com> <474331B7.6020802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474331B7.6020802@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> It seems that you're doing the same thing in both cases, except you're 
> now extending it to include other random functionality, which means 
> other things than syslets are suddenly affected.
>
> syslets are arguably a little bit different, since what you're 
> effectively doing there is running a miniature interpreted language in 
> kernel space.  A higher startup overhead should be acceptable, since 
> you're amortizing it over a larger number of calls.  Extending that 
> mechanism suddenly means you HAVE to use that interpreted language 
> message mechanism to access certain system calls, which really does 
> not seem like a good thing neither for performance nor for encouraging 
> sane design of interfaces.

whether that interpreted syslet language survives is still an open 
question - it was extremely ugly when i wrote the first version of it 
and it only got uglier since then :-)

do you suggest that extending the system call calling convention to 
include an arbitrary number of parameters will solve all these API needs 
we have at the moment?

if yes, then a one-shot syslet/async call would in essence be:

	syslet_arg1 ... N, syscall_arg 1 ... M

the same is true for the indirect stuff, we in essence nest syscalls 
inside another syscall:

	sys_indirect arg1 ... N, syscall arg 1 ... M

this all assumes an arbitrarily extendable syscall ABI, which can take 
N+M parameters. Right?

i'm not entirely sure we really want to do this. Nested syscalls would 
have to unpack the arguments and repack them into a kernel-internal call 
format anyway. So there's no performance upside - in fact i can only see 
additional complications.

Why not just pin down the current ABI that there's 6 syscall parameters 
_and not more_? It's totally sensible, and indirection has some minimal 
costs anyway, so copying the nested syscall parameters is a non-issue. 
This is not ad-hoc and when i wrote syslets i actually profiled the 
performance a variable-length calling convention and decided _against_ 
it. Nothing beats the performance of a straight fixd-length copy of 6x4 
(or 6x8) bytes.

The memory access cost argument you mentioned is largely irrelevant and 
inapposite here, this is all passed in on the stack which is well-cached 
in the L1 cache.

	Ingo
