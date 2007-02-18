Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXBRVE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXBRVE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXBRVE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:04:59 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:22921 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXBRVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jP8GwOi2mOLgDbRF0GE7UarKe97yKbRRGZiGlZ03MrSdU5T+DRnr06XQin12AfvKc/OOHzDVu4xrA2EPD9kvvETw0feiELrQBwtbJBo9bD69FMvwTZM03ZsDDec8JObl8p6aqTJD3aGRZz0OD8QlbyFq31vLAiY33NUfDKeioTk=
Message-ID: <f2b55d220702181304o460e674bwcbfebe3391425f03@mail.gmail.com>
Date: Sun, 18 Feb 2007 13:04:54 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 05/11] syslets: core code
Cc: "Pavel Machek" <pavel@ucw.cz>, "Ingo Molnar" <mingo@elte.hu>,
       Alan <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0702181223120.27404@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070213142035.GF638@elte.hu>
	 <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
	 <20070214210251.GA15025@elte.hu>
	 <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
	 <20070214215613.56d76257@localhost.localdomain>
	 <20070214223216.GA7616@elte.hu>
	 <Pine.LNX.4.64.0702141656240.7796@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0702141721560.7796@alien.or.mcafeemobile.com>
	 <20070218200145.GD3945@ucw.cz>
	 <Pine.LNX.4.64.0702181223120.27404@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> Clets would execute in userspace, like signal handlers,

or like "event handlers" in cooperative multitasking environments
without the Unix baggage

> but under the special schedule() handler.

or, better yet, as the next tasklet in the chain after the softirq
dispatcher, since I/Os almost always unblock as a result of something
that happens in an ISR or softirq

> In that way chains happens by the mean of
> natural C code, and access to userspace variables happen by the mean of
> natural C code too (not with special syscalls to manipulate userspace
> memory).

yep.  That way you can exploit this nice hardware block called an MMU.

> I'm not a big fan of chains of syscalls for the reasons I
> already explained,

to a kernel programmer, all userspace programs are chains of syscalls.  :-)

> but at least clets (or whatever name) has a way lower
> cost for the programmer (easier to code than atom chains),

except you still have the 80% of the code that is half-assed exception
handling using overloaded semantics on function return values and a
thread-local errno, which is totally unsafe with fibrils, syslets,
clets, and giblets, since none of them promise to run continuations in
the same thread context as the submission.  Of course you aren't going
to use errno as such, but that means that async-ifying code isn't
s/syscall/aio_syscall/, it's a complete rewrite.  If you're going to
design a new AIO interface, please model it after the only standard
that has ever made deeply pipelined, massively parallel execution
programmer-friendly -- IEEE 754.

> and for the kernel (no need of all that atom handling stuff,

you still need this, but it has to be centered on a data structure
that makes request throttling, dynamic reprioritization, and bulk
cancellation practical

> no need of limited cond/jump interpreters in the kernel,

you still need this, for efficient handling of speculative execution,
pipeline stalls, and exception propagation, but it's invisible to the
interface and you don't have to invent it up front

> and no need of nightmare compat code).

compat code, yes. nighmare, no.  Just like kernel FP emulation on any
processor other than an x86.  Unimplemented instruction traps.  x86 is
so utterly the wrong architecture on which to prototype this it isn't
even funny.

Cheers,
- Michael
