Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYKTRSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYKTRSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYKTRRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:17:49 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:53130 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752142AbYKTRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:17:48 -0500
Date: Thu, 20 Nov 2008 17:17:14 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, Naval Saini <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline
	kernel (specifically arm in our case)
Message-ID: <20081120171713.GB27398@linux-mips.org>
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com> <200811201759.01039.nickpiggin@yahoo.com.au> <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com> <200811210025.39568.nickpiggin@yahoo.com.au> <20081120135558.GB24308@linux-mips.org> <20081120152719.GS1617@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120152719.GS1617@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 08:27:19AM -0700, Matthew Wilcox wrote:

> I'm not quite sure why you need kmap_coherent().  If a page is mapped into
> userspace, you can find what address it's mapped to from
> page->mapping->i_mmap and page->index.  OTOH, that's potentially

Even if we know the userspace address of a page we do not necessarily have
a usable mapping for kernel purposes.  The userspace mapping might be r/o
when we need r/w or it might be in another process.  kmap_coherent takes
the job of creating a r/w mapping on a suitable kernel virtual address
that will avoid any aliases.

> page->mapping->i_mmap and page->index.  OTOH, that's potentially
> expensive since you need to grab the spinlock, and unless you have all
> user addresses coherent with each other (like parisc does), you need to
> figure out which process to be coherent with.

Having all userspace addresses of a page across all processes coherent with
each other is the only practicable solution in Linux; at least I don't think
how otherwise and within the currently kernel framework a platform could
sanely handle userspace-userspace aliases.  So we're talking about extending
this to cover userspace-kernelspace aliases.

The original reason for the introduction of kmap_coherent was avoiding
a cache alias in when a multi-threaded process forks.  The issue has been
debated on lkml in 2006 as part of my submission of a patchset under the
subject of "Fix COW D-cache aliasing on fork".  The description is somewhat
lengthy so I omit it here.

One of the ugly parts of kmap_coherent() is that it cannot be used safely
if the page has been marked as dirty by flush_dcache_page(); the callers
know about this and deal with it.

> I know James Bottomley did an experiment (and did an OLS presentation
> ...) on unmapping the entire page cache and greatly expanding the kmap
> area to do just this kind of thing.  I think he even got a speedup.

The speedup is no surprise.

  Ralf
