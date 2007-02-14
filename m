Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbXBNKxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbXBNKxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXBNKxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:53:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbXBNKxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:53:41 -0500
Date: Wed, 14 Feb 2007 11:50:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch 06/11] syslets: core, documentation
Message-ID: <20070214105039.GC6801@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu> <20070214103655.GB4241@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214103655.GB4241@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Tue, Feb 13, 2007 at 03:20:42PM +0100, Ingo Molnar wrote:
> > +Arguments to the system call are implemented via pointers to arguments.
> > +This not only increases the flexibility of syslet atoms (multiple syslets
> > +can share the same variable for example), but is also an optimization:
> > +copy_uatom() will only fetch syscall parameters up until the point it
> > +meets the first NULL pointer. 50% of all syscalls have 2 or less
> > +parameters (and 90% of all syscalls have 4 or less parameters).
> > +
> > + [ Note: since the argument array is at the end of the atom, and the
> > +   kernel will not touch any argument beyond the final NULL one, atoms
> > +   might be packed more tightly. (the only special case exception to
> > +   this rule would be SKIP_TO_NEXT_ON_STOP atoms, where the kernel will
> > +   jump a full syslet_uatom number of bytes.) ]
> 
> What if you need to increase the number of arguments passed to a 
> system call later?  That would be an API change since the size of 
> syslet_uatom would change?

the syslet_uatom has a constant size right now, and space for a maximum 
of 6 arguments. /If/ the user knows that a specific atom (which for 
example does a sys_close()) takes only 1 argument, it could shrink the 
size of the atom down by 4 arguments.

[ i'd not actually recommend doing this, because it's generally a 
  volatile thing to play such tricks - i guess i shouldnt have written 
  that side-note in the header file :-) ]

there should be no new ABI issues: the existing syscall ABI never 
changes, it's only extended. New syslets can rely on new properties of 
new system calls. This is quite parallel to how glibc handles system 
calls.

> How do you propose syslet users know about these kinds of ABI issues 
> (including the endian-ness of 64-bit arguments) ?

syslet users would preferably be libraries like glibc - not applications 
- i'm not sure the raw syslet interface should be exposed to 
applications. Thus my current thinking is that syslets ought to be 
per-arch structures - no need to pad them out to 64 bits on 32-bit 
architectures - it's per-arch userspace that makes use of them anyway. 
system call encodings are fundamentally per-arch anyway - every arch 
does various fixups and has its own order of system calls.

but ... i'd not be against having a 'generic syscall layer' though, and 
syslets might be a good starting point for that. But that would 
necessiate a per-arch table of translating syscall numbers into this 
'generic' numbering, at minimum - or a separate sys_async_call_table[].

	Ingo
