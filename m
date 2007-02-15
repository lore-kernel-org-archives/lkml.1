Return-Path: <linux-kernel-owner+w=401wt.eu-S1030673AbXBOTHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030673AbXBOTHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030676AbXBOTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:07:23 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40994 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030673AbXBOTHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:07:21 -0500
Date: Thu, 15 Feb 2007 22:04:14 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070215190413.GA23953@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 22:04:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 10:25:37AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > static void syslet_setup(struct syslet *s, int nr, void *arg1...)
> > {
> > 	s->flags = ...
> > 	s->arg[1] = arg1;
> > 	....
> > }
> > 
> > long glibc_async_stat(const char *path, struct stat *buf)
> > {
> > 	/* What about making syslet and/or set of atoms per thread and preallocate 
> > 	 * them when working threads are allocated? */
> > 	struct syslet s;
> > 	syslet_setup(&s, __NR_stat, path, buf, NULL, NULL, NULL, NULL);
> > 	return async_submit(&s);
> > }
> 
> And this is a classic example of potentially totally buggy code.
> 
> Why? You're releasing the automatic variable on the stack before it's 
> necessarily all used!
> 
> So now you need to do a _longterm_ allocation, and that in turn means that 
> you need to do a long-term de-allocation!
> 
> Ok, so do we make the rule be that all atoms *have* to be read fully 
> before we start the async submission (so that the caller doesn't need to 
> do a long-term allocation)?
> 
> Or do we make the rule be that just the *first* atom is copied by the 
> kernel before the async_sumbit() returns, and thus it's ok to do the above 
> *IFF* you only have a single system call?
> 
> See? The example you tried to use to show how "simple" the interface iswas 
> actually EXACTLY THE REVERSE. It shows how subtle bugs can creep in!

So describe what are the requirements (constraints)?

Above example has exactly one syscall in the chain, so it is ok, but
generally it is not correct.

So instead there will be 
s = atom_create_and_add(__NR_stat, path, stat, NULL, NULL, NULL, NULL);
atom then can be freed in the glibc_async_wait() wrapper just before
returning data to userspace.

There are millions of possible ways to do that, but what exactly one
should be used from your point of view? Describe _your_ vision of that path.

Currently generic example is following:
allocate mem
setup complex structure
submit syscall
wait syscall
free mem

the first two can be hidden in glibc setup/startup code, the last one -
in waiting or cleanup entry.

Or it can be this one (just an idea):

glibc_async_stat(path, &stat);

int glibc_async_stat(char *path, struct stat *stat)
{
	struct pthread *p;

	asm ("movl %%gs:0, %0", "=r"(unsigned long)(p));

	atom = allocate_new_atom_and_setup_initial_values();
	setup_atom(atom, __NR_stat, path, stat, ...);
	add_atom_into_private_tree(p, atom);
	return async_submit(atom);
}

glibc_async_wait()
{
	struct pthread *p;

	asm ("movl %%gs:0, %0", "=r"(unsigned long)(p));
	
	cookie = sys_async_wait();
	atom = search_for_cookie_and_remove(p);
	free_atom(atom);
}

Although that cruft might need to be extended...

So, describe how exactly _you_ think it should be implemented with its
pros and cons, so that systemn could be adopted without trying to
mind-read of what is simple and good or complex and really bad.

> 		Linus

-- 
	Evgeniy Polyakov
