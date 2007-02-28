Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXB1Mcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXB1Mcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXB1Mcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:32:33 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46541 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbXB1Mcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:32:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
	<20070221114737.a09be761.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
	<m1lkiikcth.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702272312580.2632@montezuma.windriver.com>
Date: Wed, 28 Feb 2007 05:28:27 -0700
In-Reply-To: <Pine.LNX.4.64.0702272312580.2632@montezuma.windriver.com> (Zwane
	Mwaikambo's message of "Wed, 28 Feb 2007 00:51:18 -0800 (PST)")
Message-ID: <m1ps7uihzo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane Mwaikambo <zwane@infradead.org> writes:

> Hi Eric,
> 	Thanks for getting this cruft cleaned up. I have a few comments 
> regarding;
>
> handle-irqs-pending-in-irr-during-irq-migration.patch
>
> 1) It relies on checking the IRR, this could race with the corresponding 
> vector bit being set by hardware.

The mostly correct assumption is that because that vector is masked and
has been for a while we should not have a race.

> 2) apic_handle_pending_vector is oddly named since it doesn't actually 
> handle a pending vector but drops it if it has been freed.
>
> 3) It looks complex
>
> So how about the following scheme. Add a check in do_IRQ whether the irq's 
> domain contains the current cpu, if not we free the vector upon handler 
> completion.

  Because that check will leak vector entries.  And after a while the
  box will be unable to migrate irqs, and possible something more
  severe.

Yes.  It is moderately complex.  After receiving a little feedback
like this I have something much simpler and more robust mered into the
current git for 2.6.21.  Which except for my stupid it doesn't compile
on uniprocessor bug should be good.

However it took me 13 patches to come up with something clean and
simple.

Basically I wait until an irq has arrived at the new location until I
free it, and even then I send a lowest priority IPI to land to the cpu in
question before I free it so that if that other cpu has it stuck in the
pending bit that gets processed before the freeing happens.
Even with that I'm still only 99% certain that the last in flight irq before
we reprogrammed it actually made it to a different cpus local apic.   But
there appears to be nothing more that I can do.  I have exhausted every
property I can find.  Added to that is the fact that simply handing the
irq in IRR empirically is sufficient.  So I truly believe in practice
the code in my first patch is sufficient, and what I am doing for 2.6.21
is better simply because it is simpler and much more paranoid and thus
affords us with a bit of margin.  If one irq is delivered to a local
apic you would expect the previous incarnation of that irq to be
delivered to a local apic first...

Honestly I would be completely happy if all that gets back ported is
my stupid patch, that adds:

		if (!disable_apic)
			ack_APIC_irq();

Before
		if (printk_ratelimit())
			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",

In do_IRQ.  That is sufficient in most cases to keep the box from
falling over.  Is obviously correct.  And only emits a scary message.
If that isn't sufficient to give everyone warm fuzzy. I think the
patch under discussion make sense for a backport.  At least it doesn't
change lot so things.

Honestly.  I am happy if I fix this for 2.6.21.  Beyond that I am
happy to offer my advice but I have no expectations of anyone
following it.  Possibly I suffer from giving to complete an answer?

What are the rules that are supposed to govern backports to stable
trees these days anyway?

Eric
