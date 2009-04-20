Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZDTAyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZDTAyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZDTAx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:53:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10945 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZDTAx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:53:56 -0400
X-IronPort-AV: E=Sophos;i="4.40,214,1238976000"; 
   d="scan'208";a="289043361"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 19 Apr 2009 17:53:54 -0700
In-Reply-To: <20090419214602.GA21527@elte.hu> (Ingo Molnar's message of "Sun,
	19 Apr 2009 23:46:02 +0200")
Message-ID: <adaws9gywkd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2009 00:53:55.0028 (UTC) FILETIME=[7AE81940:01C9C152]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Look at the drivers that define their own wrappers:
 > 
 > #ifndef readq
 > static inline unsigned long long readq(void __iomem *addr)
 > {
 >         return readl(addr) | (((unsigned long long)readl(addr + 4)) << 32LL);
 > }
 > #endif
 > 
 > ... it's the obvious 32-bit semantics for reading a 64-bit value 
 > from an mmio address. We made that available on 32-bit too.

But look at, say, drivers/infiniband/hw/amso100/c2.h:

#ifndef readq
static inline u64 readq(const void __iomem * addr)
{
	u64 ret = readl(addr + 4);
	ret <<= 32;
	ret |= readl(addr);

	return ret;
}
#endif

Notice that it reads from addr+4 *before* it reads from addr, rather
than after as in your example (and in fact your example depends on
undefined compiler semantics, since there is no sequence point between
the two operands of the | operator).  Now, I don't know that hardware,
so I don't know if it makes a difference, but the niu example I gave in
my original email shows that given hardware with clear-on-read
registers, the order does very much matter.

In a similar vein, drivers/infiniband/hw/mthca (which I wrote) deals
with hardware that has 64-bit registers, where we can write in two
32-bit chunks, as long as we have the right order and no other writes to
the same page of registers come in between.  So on 32-bit architectures,
the driver must use a spinlock around the pair of 32-bit writes (see
drivers/infiniband/hw/mthca/mthca_doorbell.h for the code).  And the
simple fact is that if that driver used "#ifdef writeq" (instead of "#if
BITS_PER_LONG == 64" as it actually does) then it would be broken on
32-bit x86 right now.

 > > So I would strongly suggest reverting 2c5643b1 since as far as I 
 > > can tell it just sets a trap for subtle bugs that only show up on 
 > > 32-bit x86 [...]

 > Heh. It "only" shows up on the platform that ~80% of all our kernel 
 > testers use? ;-)

Well, most of the drivers using readq()/writeq() are probably driving
"high-end" hardware (InfiniBand, 10G ethernet, "enterprise" SCSI) that
is much more tilted to 64-bit architectures.  But yes, such bugs would
probably be seen quickly -- but the effort to debug "works on x86-64,
fails on x86-32 under high load" bugs is pretty big, given that the
symptoms of non-atomic access to a 64-bit register are probably pretty
mysterious (you can read about how the niu bug I mentioned was fixed --
it took a while to zero in on the root cause).

 > So, are you arguing for a per driver definition of readq/writeq? If 
 > so then that does not make much technical sense. If not ... then 
 > what is your technical point?

Yes, I am arguing for exactly that, because dealing with the semantics
of non-atomic access to 64-bit registers involved low-level knowledge of
the specific hardware being driven.

As it stands 32-bit x86 has readq()/writeq() that are subtly different
subtly different from all other 64-bit architectures, in a way that sets
a booby trap for any driver that uses them.  So yes I stick to my
original point that the commit that added them for 32-bit x86 should be
reverted.

 - R.
