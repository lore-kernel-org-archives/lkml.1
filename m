Return-Path: <linux-kernel-owner+w=401wt.eu-S1751420AbXBPMLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbXBPMLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXBPMLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:11:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46161 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbXBPMLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:11:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] killing the NR_IRQS arrays.
Date: Fri, 16 Feb 2007 05:10:46 -0700
Message-ID: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Looking at irq handling in the kernel from a generic perspective I
see two problems.

- There are a huge number of possible interrupt sources but in
  practice very few of them are used.  So we need a large
  irq_desc[NR_IRQS] array that mostly goes unused.  If we try for
  tighter pacing we get into all kinds of weird issues with irq
  remaping and confusing human beings and sometimes the code.

  Even with a large enough NR_IRQS we still get weird issues of
  allocating and freeing elements in the array which is just needless
  complexity.

- When dealing with interrupts we have no universal value that means
  we don't have an irq.  Inside the arch code we have to do
  something different then in drivers because 0 is valid interrupt and
  even at the level of drivers there are cases where the type is made
  int irq and negative numbers are used.

So I propose we remove all assumptions from the code that we actually
have an array of irqs.  That will allow for irq_desc to be dynamically
allocated instead of statically allocated saving memory and reducing
kernel complexity.

To do this I believe will require a s/unsigned int irq/struct irq_desc *irq/
throughout the entire kernel.  Getting the arch specific code and the
generic kernel infrastructure fixed and ready for that change looks
like a pain but pretty doable.

Getting the drivers changed actually looks to be pretty straight
forward it will just be a very large mechanical change.  We change the
type where of variables where appropriate and every once in a while
introduce an irq_nr(irq) to get the actual irq number for the places
that care (ISA or print statements).

Beyond that I did a quick test compile with just the interrupt.h and
pci.h changed and big chunks of the drivers compiled without errors.
Other drivers had more issues that mostly looked like they had an
internal irq number variable that needed updating.

I think we can make this change fairly smoothly if before the code is
merged into Linus's tree we have a patchset prepared with a all of the
core infrastructure changes and a best effort at all of the driver
changes.  Then early some merge window we merge the patchset, and
fixup the drivers that were missed.

Andrew, Linus if you think this is a horrible idea I clearly cannot
pull this off, but if not I will start working up patches for 2.6.22
or more likely 2.6.23.

I expect the most it makes sense to aim for 2.6.22 are the genirq
changes so the internal arch code is passing struct irq_desc
everywhere internally. 

Hopefully with this I can get the irq code in a shape where you don't
have to have been staring at the code for years to make sense of.

Eric
