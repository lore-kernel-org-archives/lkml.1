Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYKTTnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYKTTnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYKTTm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:42:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50632 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbYKTTm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:42:56 -0500
Date: Thu, 20 Nov 2008 19:30:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ralf Baechle <ralf@linux-mips.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-fsdevel@vger.kernel.org, Naval Saini <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Message-ID: <20081120193049.GC14686@flint.arm.linux.org.uk>
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com> <200811201759.01039.nickpiggin@yahoo.com.au> <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com> <200811210025.39568.nickpiggin@yahoo.com.au> <20081120135558.GB24308@linux-mips.org> <20081120152719.GS1617@parisc-linux.org> <20081120171713.GB27398@linux-mips.org> <20081120174054.GU1617@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120174054.GU1617@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 10:40:54AM -0700, Matthew Wilcox wrote:
> On Thu, Nov 20, 2008 at 05:17:14PM +0000, Ralf Baechle wrote:
> > On Thu, Nov 20, 2008 at 08:27:19AM -0700, Matthew Wilcox wrote:
> > > I'm not quite sure why you need kmap_coherent().  If a page is mapped into
> > > userspace, you can find what address it's mapped to from
> > > page->mapping->i_mmap and page->index.  OTOH, that's potentially
> > 
> > Even if we know the userspace address of a page we do not necessarily have
> > a usable mapping for kernel purposes.  The userspace mapping might be r/o
> > when we need r/w or it might be in another process.  kmap_coherent takes
> > the job of creating a r/w mapping on a suitable kernel virtual address
> > that will avoid any aliases.
> 
> Ah, I didn't do a good enough job of explaining.  My question was why
> you needed the 'address' argument to kmap_coherent (and thus had a
> different prototype from kmap) instead of just implementing kmap() on
> mips.

Ok, having discussed this with Matthew, I'm beginning to really warm
to the idea of always kmapping page cache accesses.

That nicely means that we never touch the page cache via the kernel
direct mapping, which in turn means we can reduce the amount of RAM
mapped, freeing up space for kmap in the virtual address space.

I think this should work really nicely, and make flush_dcache_page()
almost a no-op for aliasing VIPT caches (on ARM, we still have a
problem with instruction/data cache aliasing, but that's a far easier
issue to solve.)

Ralf: were you saying that you already had an implementation similar
to Matthew's?  As I see it, if you use page->index to determine the
userspace mapping colouring (which we do on ARM) then kmap() already
has access the necessary information to correctly place the page...
