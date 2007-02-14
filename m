Return-Path: <linux-kernel-owner+w=401wt.eu-S1750791AbXBNLEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750791AbXBNLEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 06:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXBNLEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 06:04:49 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4159 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXBNLEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 06:04:48 -0500
Date: Wed, 14 Feb 2007 11:04:19 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
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
Subject: Re: [patch 06/11] syslets: core, documentation
Message-ID: <20070214110419.GC4241@flint.arm.linux.org.uk>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu> <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214105039.GC6801@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:50:39AM +0100, Ingo Molnar wrote:
> * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > On Tue, Feb 13, 2007 at 03:20:42PM +0100, Ingo Molnar wrote:
> > > +Arguments to the system call are implemented via pointers to arguments.
> > > +This not only increases the flexibility of syslet atoms (multiple syslets
> > > +can share the same variable for example), but is also an optimization:
> > > +copy_uatom() will only fetch syscall parameters up until the point it
> > > +meets the first NULL pointer. 50% of all syscalls have 2 or less
> > > +parameters (and 90% of all syscalls have 4 or less parameters).
> > > +
> > > + [ Note: since the argument array is at the end of the atom, and the
> > > +   kernel will not touch any argument beyond the final NULL one, atoms
> > > +   might be packed more tightly. (the only special case exception to
> > > +   this rule would be SKIP_TO_NEXT_ON_STOP atoms, where the kernel will
> > > +   jump a full syslet_uatom number of bytes.) ]
> > 
> > What if you need to increase the number of arguments passed to a 
> > system call later?  That would be an API change since the size of 
> > syslet_uatom would change?
> 
> the syslet_uatom has a constant size right now, and space for a maximum 
> of 6 arguments. /If/ the user knows that a specific atom (which for 
> example does a sys_close()) takes only 1 argument, it could shrink the 
> size of the atom down by 4 arguments.
> 
> [ i'd not actually recommend doing this, because it's generally a 
>   volatile thing to play such tricks - i guess i shouldnt have written 
>   that side-note in the header file :-) ]
> 
> there should be no new ABI issues: the existing syscall ABI never 
> changes, it's only extended. New syslets can rely on new properties of 
> new system calls. This is quite parallel to how glibc handles system 
> calls.

Let me spell it out, since you appear to have completely missed my point.

At the moment, SKIP_TO_NEXT_ON_STOP is specified to jump a "jump a full
syslet_uatom number of bytes".

If we end up with a system call being added which requires more than
the currently allowed number of arguments (and it _has_ happened before)
then either those syscalls are not accessible to syslets, or you need
to increase the arg_ptr array.

That makes syslet_uatom larger.

If syslet_uatom is larger, SKIP_TO_NEXT_ON_STOP increments the syslet_uatom
pointer by a greater number of bytes.

If we're running a set of userspace syslets built for an older kernel on
such a newer kernel, that is an incompatible change which will break.

> > How do you propose syslet users know about these kinds of ABI issues 
> > (including the endian-ness of 64-bit arguments) ?
> 
> syslet users would preferably be libraries like glibc - not applications 
> - i'm not sure the raw syslet interface should be exposed to 
> applications. Thus my current thinking is that syslets ought to be 
> per-arch structures - no need to pad them out to 64 bits on 32-bit 
> architectures - it's per-arch userspace that makes use of them anyway. 
> system call encodings are fundamentally per-arch anyway - every arch 
> does various fixups and has its own order of system calls.
> 
> but ... i'd not be against having a 'generic syscall layer' though, and 
> syslets might be a good starting point for that. But that would 
> necessiate a per-arch table of translating syscall numbers into this 
> 'generic' numbering, at minimum - or a separate sys_async_call_table[].

Okay - I guess the userspace library approach is fine, but it needs
to be documented that applications which build syslets directly are
going to be non-portable.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
