Return-Path: <linux-kernel-owner+w=401wt.eu-S1030478AbXBOScP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030478AbXBOScP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030479AbXBOScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:32:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56183 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030478AbXBOScN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:32:13 -0500
Date: Thu, 15 Feb 2007 10:25:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070215181059.GC20997@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
 <20070215181059.GC20997@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:
> 
> So we just need to describe the way we want to see new interface -
> that's it.

Agreed. Absolutely.

But please keep the kernel interface as part of that. Not just a strange 
and complex kernel interface and then _usable_ library interfaces that use 
the strange and complex one internally. Because if the complex one has no 
validity on its own, it's just (a) a bitch to debug and (b) if we ever 
change any details inside the kernel we'll end up with a lot of subtle 
code where user land creates complex data, and the kernel just reads it, 
and both just (unnecessarily) work around the fact that the other doesn't 
do the straightforward thing.

> Here is a stub for async_stat() - probably broken example, but that does
> not matter - this interface is really easy to change.
> 
> static void syslet_setup(struct syslet *s, int nr, void *arg1...)
> {
> 	s->flags = ...
> 	s->arg[1] = arg1;
> 	....
> }
> 
> long glibc_async_stat(const char *path, struct stat *buf)
> {
> 	/* What about making syslet and/or set of atoms per thread and preallocate 
> 	 * them when working threads are allocated? */
> 	struct syslet s;
> 	syslet_setup(&s, __NR_stat, path, buf, NULL, NULL, NULL, NULL);
> 	return async_submit(&s);
> }

And this is a classic example of potentially totally buggy code.

Why? You're releasing the automatic variable on the stack before it's 
necessarily all used!

So now you need to do a _longterm_ allocation, and that in turn means that 
you need to do a long-term de-allocation!

Ok, so do we make the rule be that all atoms *have* to be read fully 
before we start the async submission (so that the caller doesn't need to 
do a long-term allocation)?

Or do we make the rule be that just the *first* atom is copied by the 
kernel before the async_sumbit() returns, and thus it's ok to do the above 
*IFF* you only have a single system call?

See? The example you tried to use to show how "simple" the interface iswas 
actually EXACTLY THE REVERSE. It shows how subtle bugs can creep in!

		Linus
