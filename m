Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0CBO7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:59:00 -0500
Received: from www.tglx.de ([62.245.132.106]:44508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab0CBO66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:58:58 -0500
Date: Tue, 2 Mar 2010 15:58:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH -v2 2/2] genericirq: change ack/mask in irq_chip to take
 irq_desc instead of irq
In-Reply-To: <m1ljei5n9q.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1003021522340.4245@localhost.localdomain>
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org> <m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org> <m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org> <m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>
 <m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org> <4B7CAADD.2060000@kernel.org> <m1mxz6v4pm.fsf@fess.ebiederm.org> <4B83781B.20307@kernel.org> <4B837930.2050907@kernel.org> <m1ljei5n9q.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
> > will have
> > void            (*ack)(struct irq_desc *desc);
> > void            (*mask)(struct irq_desc *desc);
> > void            (*mask_ack)(struct irq_desc *desc);
> > void            (*unmask)(struct irq_desc *desc);
> > void            (*eoi)(struct irq_desc *desc);
> >
> > so for sparseirq with raidix tree, we don't call extra
> > irq_to_desc, and could use desc directly
> 
> Overall this looks pretty decent.  This look pretty complete.
> How many platforms did you manage to compile test this on?
> 
> I have found a couple of issues (see below).
> 
> A few times you change a bit more than is necessary which is a bit
> spooky in a patch this far ranging.
> 
> Reading through this patch to review it took an uncomfortably long
> time.

And you didn't even catch all problem spots.

While I like the idea, I really hate the convert wholesale approach.

      303 files changed, 3127 insertions(+), 2191 deletions(-)

is fine for a sed script renaming action, but definitely _not_ for
patches which require semantical changes to the affected code.

The right way to do that is 

  1) add new function pointers, which take irq_desc as their argument

  2) make the generic code use them when the old function pointer is
     NULL

  3) convert the irq_chip implementations one by one with separate
     patches

  4) Remove the old function pointers and switch the generic code
     fully over to use the new ones

Yes, it's more work, but it's less error prone and easier to review,
as the maintainers just have to look at the patch which affects their
particular area.

Thanks,

	tglx
