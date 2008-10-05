Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYJEPMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYJEPMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 11:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYJEPLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 11:11:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYJEPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:11:53 -0400
Date: Sun, 5 Oct 2008 08:11:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
Message-ID: <20081005081145.30ba921b@infradead.org>
In-Reply-To: <20081004215225.2444d54b.akpm@linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org>
	<20081004215225.2444d54b.akpm@linux-foundation.org>
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

On Sat, 4 Oct 2008 21:52:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 4 Oct 2008 17:44:33 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > 
> > Details: http://www.kerneloops.org/searchweek.php?search=lock_page
> > 
> > There's quite a few of this BUG, which seems to be an interaction
> > between the "hwclock" program and something in 2.6.27. It's new
> > in .27 and is currently the 8th ranked issue.....
> > 
> > BUG: sleeping function called from invalid context at
> > include/linux/pagemap.h:294 in_atomic():0, irqs_disabled():1
> > INFO: lockdep is turned off.
> > irq event stamp: 0
> > hardirqs last  enabled at (0): [<00000000>] 0x0
> > hardirqs last disabled at (0): [<c042c3a4>]
> > copy_process+0x2e7/0x115e softirqs last  enabled at (0):
> > [<c042c3a4>] copy_process+0x2e7/0x115e softirqs last disabled at
> > (0): [<00000000>] 0x0 Pid: 9591, comm: hwclock Tainted: G        W
> > 2.6.27-0.372.rc8.fc10.i686 #1 [<c0427a53>] __might_sleep+0xd1/0xd6 
> >  [<c0479a8b>] lock_page+0x1a/0x34
> >  [<c0479cfa>] find_lock_page+0x23/0x48
> >  [<c047a215>] filemap_fault+0x9b/0x330
> >  [<c0486493>] __do_fault+0x40/0x2e6
> >  [<c0487d63>] handle_mm_fault+0x2ec/0x6d2
> >  [<c06e8260>] do_page_fault+0x2e5/0x693
> > 
> 
> Looks like `hwclock' disabled interrupts in userspace with sys_iopl()?

static unsigned long   
atomic(const char *name, unsigned long (*op)(unsigned long),
       unsigned long arg)
{
  unsigned long v;
  __asm__ volatile ("cli");
  v = (*op)(arg);
  __asm__ volatile ("sti");
  return v;
} 

looks like it (but only on 32 bit x86, not on 64 bit x86)

> 
> And then it took a pagefault, which is presumably a bug in hwclock.
> 
> That's all a bit antisocial of it.  I guess a suitable quickfix is to
> remove the might_sleep() from lock_page() (which would be a good thing
> from a text size POV anyway).
> 
> But there will of course be other sites which do possibly-sleeping
> operations on the pagefault path.
> 
> Really, it's a bit stupid doing _any_ system calls (and a pagefault is
> a syscall in disguise) with interrupts disabled.  The kernel makes no
> guarantees that we'll honour it.  We could just enable interrupts on
> pagefault entry - that'll teach 'em.

or save - enable - <run handlers> - restore sequence

it's horrible that we allowed this before, and the semantics are very
fuzzy at best, but to go WARN_ON() for it might be a bit too much.

(and yes someone really ought to fix hwclock; it's rather broken)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
