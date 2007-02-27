Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXB0Uag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXB0Uag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXB0Uag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:30:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38131 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXB0Uae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:30:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<20070216124117.GB4218@elte.hu>
	<1171833885.3261.208.camel@laptopd505.fenrus.org>
	<1171844753.5644.174.camel@localhost.localdomain>
Date: Tue, 27 Feb 2007 13:29:11 -0700
In-Reply-To: <1171844753.5644.174.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Mon, 19 Feb 2007 11:25:53 +1100")
Message-ID: <m1abyzl4yw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A quick update.  I did some work on this and have some observations.

- Every back end irq implementation seems to have a different name for
  the structure that describes irqs.  So picking struct irq which is
  different from everything seems to make sense.  At the very least
  a empty struct irq can be embedded in the architecture specific
  irq description structure and we can use container_of to get back
  to it.

- The name struct irq conflicts with a spurious definition in
  include/pcmcia/cs.h, but otherwise is fine.  So it probably makes
  sense to use.

- Updating all of the drivers is going to be a pain for precisely the
  reason we need to update the drivers.  irq numbers are not handled
  at all cleanly.  In attempting just a few conversions I have seen
  irq number stashed in everything for a u8 to a u64.  I have seen
  all values <= 0 thrown out as invalid.

  So we have a decade or more of accumulated inconsistencies and it is
  getting painful to work with.  Changing the type to something that
  won't support all of the old hacks should help cleanup the code.

- Because drivers are not consistent in their handling of irq numbers 
  whatever path I take to a conversion each patch needs to be thought
  about instead of just performed.  So I'm going to have to double
  the API so a gradual conversion is possible. 

- Converting the genirq code to use struct irq_desc pointers
  throughout (instead of unsigned int irq) is straight forward and
  mindless.  Though it is tedious.  Like I expected the drivers to be
  :(

  So it looks like all I need to do to convert the genirq backend is
  to break the work up into small enough patches that each patch is
  obviously correct.  Then compiling on the different architectures
  can just serve as a spot check, not as absolutely required step
  during the code conversion.

- The converted genirq code was short and easier to follow.  Mostly
  because I got to kill all of the if (irq >= NR_IRQS) tests...
  Null pointer dereferences are your friends!

- The are only 3 or 4 arrays of size NR_IRQS in non-architecture code
  and I have patches in my queue to kill them, so that isn't too bad.

- All of the drivers that handle irqs need to be touched because one
  of the parameters to the irq handler is the interrupt number.  So
  that needs to be converted.  



So I think the path should be:

* Kill the arrays of size NR_IRQS in non-arch code.

* Add a variation of the API in interrupt.h that uses
  "struct irq *irq" instead of "unsigned int irq"
  
  Probably replacing request_irq with irq_request or something
  trivial like that.

  This will need to touch all of different irq implementation back
  ends, but only very lightly.

* Convert the generic irq code to use struct irq * everywhere it
  current uses "unsigned int irq".

* Start on the conversions of drivers and subsystems picking on
  the easy ones first :)

* Adding for_each_irq_desc() and similar helpers to the generic
  irq code.

* Add support in the generic irq code for architectures that don't
  have a giant array of irqs.  

* Convert x86_64 and i386 to dynamically allocate their irqs.
  Routines using the old interfaces will be no longer O(1) more
  likely O(N). So will be slow but request_irq and free_irq are
  no where near the fast path so it doesn't matter.  enable_irq
  and disable_irq are the only cases that might matter and they
  occur rarely enough fixing the drivers that matter should not
  be a problem.

* Ultimately finish converting all of the drivers and remove the
  compatibility cruft.

I will look at getting things started and some patches into -mm
sometime next month.

Eric


