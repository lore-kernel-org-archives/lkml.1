Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0CFVJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:09:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:55175 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0CFVI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:08:59 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267872443.8894.1443.camel@mulgrave.site>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <20100304142704.GB6622@n2100.arm.linux.org.uk>
	 <1267872443.8894.1443.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Mar 2010 08:03:49 +1100
Message-ID: <1267909429.22204.127.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-06 at 16:17 +0530, James Bottomley wrote:
> On a fault in of exec data, we first try to get the page out of the page
> cache.  If it's not present, we put the faulting process to sleep and
> fetch it in from storage.  When we do the read, on the PIO path, the
> kernel alias for the page becomes dirty.  Some time later, we place the
> page into the user space (updating the pte entry that caused a fault).
> At this point, we'll call both flush_icache_page() and
> update_mmu_cache() ... this is where the I/D resolution should be done.
> Since it's after any I/O has occurred, it doesn't matter whether the CPU
> speculatively moved anything in or not.  As long as you flush the kernel
> alias and invalidate the user I and D aliases, we're good to go.  Using
> the page arch flags is really only to optimise this process (defer
> kernel D alias flushing).

Ok, so while flush_icache_page() looks like something we could use
instead of set_pte_at() for the icache flushing, it doesn't answer all
the questions. Off the top of my mind:

- I see the calls to flush_icache_page() in mm/memory.c but I don't see
them next to all set_pte_at() that insert a valid PTE. For example, we
don't flush the icache for anonymous pages. While that might seem like a
good idea, we have been under pressure to "fix" that on powerpc to make
sure there is no stale icache content from another process leaking into
userspace.

- It needs to be done -before- set_pte_at() but I think the code does it
right, only your explanation above makes it unclear :-)

- It doesn't take the PTE pointer as an argument, so here goes our trick
on powerpc of filtering out exec permission rather than flushing when a
page is accessed by a read fault

- We -still- have the problem of tracking whether the icache has been
flushed or not yet for a given physical page on archs with PIPT (or non
aliasing VIPT) like powerpc. Without that tracking, we flush a lot more
than necessary since we'll end up flushing things like glibc text pages
for every process they are mapped into which is totally wasteful. Thus
the idea of using a new PG bit to separate D$ from I$ tracking still
makes sense.

Cheers,
Ben.


