Return-Path: <linux-kernel-owner+w=401wt.eu-S965470AbXBGGt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbXBGGt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXBGGtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:49:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470AbXBGGtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:49:25 -0500
Date: Tue, 6 Feb 2007 22:49:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
Message-Id: <20070206224914.f1da7019.akpm@linux-foundation.org>
In-Reply-To: <20070207062934.GA11967@linux-sh.org>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
	<20070207062934.GA11967@linux-sh.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 15:29:34 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> On Tue, Feb 06, 2007 at 10:15:47PM -0800, David Rientjes wrote:
> > Extracts the page table entry walker from the smaps-specific code in
> > fs/proc/task_mmu.c.  This will be used later for clearing the reference
> > bits on pages to measure the number of pages accessed over a time period
> > through /proc/pid/smaps.
> > 
> I like the general idea of this patch set, however..

David didn't really spell out the rationale.  Userspace people ask "how
much memory is my application using".  For system planning and such.  We
don't know, really.  So the approach taken here is to nuke all the
referenced bits and to then monitor them coming back over time.

Obviously it doesn't work very well if the page scanner is doing things,
but one hopes that when someone is instrumenting their application they'll
ensure that sufficient memory is available to prevent this inaccuracy.

The other part of the question is of course pagecache.  Hopefully /proc/pid/io
will suffice for that, probably in combination with /proc/sys/vm/drop_caches.

I don't really have a sense for how much stuff we want to put into the kernel
to support this sort of thing.  The proposed patches are, I think, minimal.
Perhaps it needs more.  If so, opinions are solicited before we go and add
(and hence be forced to maintain) this new interface.

> > Since the PTE walker is now extracted from the smaps code,
> > smaps_pte_func() is invoked for each PTE in the VMA.  Its behavior is
> > identical to the existing implementation, except it is slightly slower
> > because each PTE now invokes a function call.
> > 
> Perhaps this is something that needs to be looked at more closely and
> made more generic? There are many ranged page table walkers that aren't
> so performance critical that the function call cost would cause too much
> pain. ioremap_page_range() comes to mind, and there's bound to be others.
> This would also help people to get the pte map/unmap right, which seems
> to pop up from time to time as well..

That's what Paul Davies' patches are aimed at:

http://marc.theaimsgroup.com/?l=linux-mm&m=115276500100695&w=2

I promised Paul that I'd take a serious look at those patches next time
they pop up.   It would be good if others could help out in that.
