Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXJECpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXJECpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 22:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJECpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 22:45:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbXJECpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 22:45:00 -0400
Date: Thu, 4 Oct 2007 19:44:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickens <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
Message-Id: <20071004194432.9b3353c2.akpm@linux-foundation.org>
In-Reply-To: <470596C4.8060804@goop.org>
References: <470596C4.8060804@goop.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 18:43:32 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> David's change 10a8d6ae4b3182d6588a5809a8366343bc295c20, "i386: add
> ptep_test_and_clear_{dirty,young}" has introduced an SMP race which
> affects the Xen pv-ops backend.

y'know, I think I think it's been several years since I saw a report of an
honest to goodness, genuine SMP race in core kernel.  We used to be
infested by them, but the term has fallen into disuse.  Interesting, but
OT.

> It seems to me that there are a few ways to fix this:
> 
>    1. Use asm-generic/pgtable.h when CONFIG_PARAVIRT is enabled.  This
>       will clearly work, but is pretty blunt.
>    2. Make test_and_clear_pte_flags a new paravirt-op, which can be
>       implemented in Xen as a hypercall, and as a raw test_and_clear_bit
>       for everyone else.  The downside is adding yet another pv-op.
>    3. Restructure the pagetable setup code so that the mm is not added
>       to the prio tree until after arch_dup_mmap has been called (and
>       the converse for exit_mmap).  This is arguably cleaner, but I
>       haven't looked to see how much trouble this would be.
> 
> Thoughts anyone?  Does making the pagetables visible "early" cause
> problems for anyone else?

I expect that 2) has the maximum niceness*suitable-for-2.6.23 product.

That's if you actually care much about kernel.org major releases - do many
people run kernel.org kernels on Xen?  If "not many" then we could perhaps
do something more elaborate for 2.6.23.1.  But adding ever more pvops as
core kernel evolves was always expected.
