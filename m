Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYJERio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYJERio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 13:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYJERig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 13:38:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYJERig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 13:38:36 -0400
Date: Sun, 5 Oct 2008 10:38:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
Message-ID: <20081005103826.6771540a@infradead.org>
In-Reply-To: <20081005102742.de8353b4.akpm@linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org>
	<20081004215225.2444d54b.akpm@linux-foundation.org>
	<20081005081145.30ba921b@infradead.org>
	<20081005102742.de8353b4.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 10:27:42 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > static unsigned long   
> > atomic(const char *name, unsigned long (*op)(unsigned long),
> >        unsigned long arg)
> > {
> >   unsigned long v;
> >   __asm__ volatile ("cli");
> >   v = (*op)(arg);
> >   __asm__ volatile ("sti");
> >   return v;
> > } 
> > 
> > looks like it (but only on 32 bit x86, not on 64 bit x86)
> 
> I suspect this is new in hwclock?  We do a might_sleep() in
> lock_page() in 2.6.25 and in 2.6.26.

this quote was from the F9 hwclock.. which shipped with 2.6.25.
Hum.

> > > Really, it's a bit stupid doing _any_ system calls (and a
> > > pagefault is a syscall in disguise) with interrupts disabled.
> > > The kernel makes no guarantees that we'll honour it.  We could
> > > just enable interrupts on pagefault entry - that'll teach 'em.
> > 
> > or save - enable - <run handlers> - restore sequence
> 
> hwclock is buggy either way - 

not arguing with that ;-)
All code doing cli/sti in userland is buggy period. No excuses possible.

> it's trying to disable interrupts but
> it's calling into the kernel, which will reenable interrupts, thus
> losing any protection which hwclock was trying to attain.
> 
> Plus there's this little thing called "smp".  I bet it doesn't disable
> interrupts on all CPUs.

I get the impression from the code that it really wants a "don't
schedule me out" rather than "this is a lock".
it can do better.
On Alpha it implements a seq-lock kind of thing instead.
(and on x86-64 .. it implements NOTHING)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
