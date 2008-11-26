Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYKZXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYKZXDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYKZXDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:03:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYKZXDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:03:05 -0500
Date: Wed, 26 Nov 2008 15:02:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: pavel@suse.cz, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_evaluate_integer broken by design
Message-Id: <20081126150224.947c18d4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811261729550.3895@localhost.localdomain>
References: <20081125110508.GA1943@elf.ucw.cz>
	<20081126132050.cecb170b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811261729550.3895@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 17:37:29 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:

> 
> 
> > > Now I know why I had strange "scheduling in atomic" problems:
> > > acpi_evaluate_integer() does malloc(..., irqs_disabled() ? GFP_ATOMIC
> > > : GFP_KERNEL)... which is (of course) broken.
> > 
> > That is kinda weird.  When did this all start happening?
> 
> > > There's no way to reliably tell if we need GFP_ATOMIC or not from
> > > code, this one for example fails to detect spinlocks held.
> 
> > Len, this looks like 2.6.28 material.  But given the poor quality of
> > the changelog it is hard to be sure about this.  Why isn't everyone
> > seeing these warnings?  What did Pavel do to provoke these alleged
> > warnings?  Nobody knows...
> 
> I don't know know why pavel sees this and nobody else --
> maybe something unusual he's doing with suspend?
> 
> The reason that the ACPI code is littered with bogus
> irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
> is because, like boot, resume starts life with interrupts off.

yes, suspend's disabling of interrupts causes problems all over the place.

If we really do need to inspect global state to handle this, it would
be much better to create a new

bool resume_is_running_so_you_cant_sleep;

and to test that.  Something which is clear, highly specific and which
cannot be accidentally triggered via other means.

> I would prefer that resume and boot handle this the same way,
> with system_state.  However, a few years ago when I suggested
> using system_state for resume, Andrew thought that was a very
> bad idea.  Andrew, do you still feel that way?

yep.  We've had problems in the past with system_state, where people add
new states, and old code breaks.  Plus as we add more dependencies on
system_state, that reduces our ability to add new states and makes it
harder to alter (ie: fix) system_state transitions, etc.  Just run
away!

As I said above, if we have a piece of code which wants to know when a
separate piece of code is in a particualr state, it is better to add a
new state flag just for that application, rather than trying to infer
things from the heavily overloaded system_state.


Obviously, it is even better to do neither.  It is a basic and
oft-reoccurring design mistake for a low-level piece of code to
hardwire its GFP_foo decision.  The gfp_t should be passed in from the
callers, all the way down the chain from the top-level code which
actually knows what state this thread of control is in.

> -Len
> 
> ps. I'll put this particular fix in my tree now.

bewdy.  It's a good change.
