Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXBNRw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXBNRw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932135AbXBNRw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:52:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1961 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbXBNRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:52:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 09:52:20 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <20070214110419.GC4241@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu>
 <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu>
 <20070214110419.GC4241@flint.arm.linux.org.uk>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Russell King wrote:

> Let me spell it out, since you appear to have completely missed my point.
> 
> At the moment, SKIP_TO_NEXT_ON_STOP is specified to jump a "jump a full
> syslet_uatom number of bytes".
> 
> If we end up with a system call being added which requires more than
> the currently allowed number of arguments (and it _has_ happened before)
> then either those syscalls are not accessible to syslets, or you need
> to increase the arg_ptr array.

I was thinking about this yesterday, since I honestly thought that this 
whole chaining, and conditions, and parameter lists, and argoument passed 
by pointers, etc... was at the end a little clumsy IMO.
Wouldn't a syslet look better like:

long syslet(void *ctx) {
	struct sctx *c = ctx;

	if (open(c->file, ...) == -1)
		return -1;
	read();
	send();
	blah();
	...
	return 0;
}

That'd be, instead of passing a chain of atoms, with the kernel 
interpreting conditions, and parameter lists, etc..., we let gcc 
do this stuff for us, and we pass the "clet" :) pointer to sys_async_exec, 
that exec the above under the same schedule-trapped environment, but in 
userspace. We setup a special userspace ad-hoc frame (ala signal), and we 
trap underneath task schedule attempt in the same way we do now.
We setup the frame and when we return from sys_async_exec, we basically 
enter the "clet", that will return to a ret_from_async, that will return 
to userspace. Or, maybe we can support both. A simple single-syscall exec 
in the way we do now, and a clet way for the ones that requires chains and 
conditions. Hmmm?



- Davide


