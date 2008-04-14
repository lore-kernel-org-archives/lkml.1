Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbYDNW5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbYDNW5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYDNW50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:57:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbYDNW5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:57:25 -0400
Date: Mon, 14 Apr 2008 15:57:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rossb@google.com (Ross Biro)
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rossb@google.com
Subject: Re: [PATCH 1/2] MM: Make page tables relocatable -- conditional
 flush (rc9)
Message-Id: <20080414155702.ca7eb622.akpm@linux-foundation.org>
In-Reply-To: <20080414163933.A9628DCA48@localhost>
References: <20080414163933.A9628DCA48@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 09:39:33 -0700 (PDT)
rossb@google.com (Ross Biro) wrote:

> These Patches make page tables relocatable for numa, memory
> defragmentation, and memory hotblug.  The potential need to rewalk the
> page tables before making any changes causes a 3% peformance
> degredation in the lmbench page miss micro benchmark.

We're going to need a considerably more detailed description than this,
please.

This is a large patch which is quite intrusive on the core memory
management code.  It appears that there has been close to zero interest
from any MM developers apart from a bit of to-and-fro back in October. 
Probably because nobody can see why the chnges are valuable to them, and
that's probably because you're not telling them!

For starters, what problems does the patchset solve?  People can partially
work that out for themselves if they are sufficiently experienced with the
internals of defrag and hotplug, but it does not hurt at all to spell this out.

Secondly, how does the code work?  What is the overall design?  Any
implementation details or shortcomings or todos which we should know about?


This patchset doesn't apply to the 2.6.26 queue because of the ongoing x86
shell game: the arch/x86/kernel/smp_??.c files were consolidated.

I could fix that up and merge the patches, but I review patches when I
merge them, and these ones would require a lengthy review.  That review
would be much less effective than it would be if I had a complete
description of the design and implementation from its designer and
implementor.

The reason for this is that reviewing code for correctness involves a)
understanding (and approving of) the design then b) attempting to identify
places where the implementation incorrectly implements that design.  But if
the reviewer has to gain his understanding of the design from the
implementation we get into a circularity problem and mistakes can be made.

Generally, where possible, I do think that it's best if the design and
implementation are conveyed in code comments rather than changelog.  That's
more convenient for readers and for reviewers and makes it more likely that
the documentation will remain correct as the code evolves.  But this
patchset adds few comments.

Just one example: I have no way of knowing what led you to choose
down_interruptible() in enter_page_table_relocation_mode().  So people who
read the code two years hence will be wondering the same thing.


Minor notes from a quick scan:

- Must ->page_table_relocation_lock be a semaphore?  mutexes are
  preferred.

- The patch adds a number of largeish inlined functions.  There's rarely
  a need for this, and it can lead to large icache footprint which will, we
  expect, produce slower code.

- The patch adds a lot of macros which look like they could have been
  implemented as inlines.  Inlines are preferred, please.  They look nicer,
  they provide typechecking, they avoid accidental
  multiple-reference-to-arguments bugs and they help to avoid
  unused-variable warnings.

- Doing PAGE_SIZE memcpy under spin_lock_irqsave() might get a bit
  expensive from an interrupt-latency POV.  It could (I think?) result in
  large periods of time where interrupts are almost always disabled, which
  might disrupt some device drivers.

- Why is this code doing spin_lock_irqsave() on page_table_lock?  The
  rest of mm/ doesn't disable IRQs for that lock.  This implies that
  something somewhere is now taking that lock from interrupt context, which
  means that existing code will deadlock.  Unless you converted all those
  sites as well.  Which would be a major change, which would need to be
  documented in big blinking lights in the changelog.

- I haven't checked, but if the code is taking KM_USER0 from interrupt
  context then that would be a bug.  Switching to KM_IRQ0 would fix that.
