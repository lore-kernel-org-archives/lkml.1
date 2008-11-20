Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYKTQet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYKTQet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYKTQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:34:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33558 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYKTQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:34:40 -0500
Date: Thu, 20 Nov 2008 16:30:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-fsdevel@vger.kernel.org, Naval Saini <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Message-ID: <20081120163052.GA5385@flint.arm.linux.org.uk>
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com> <200811201759.01039.nickpiggin@yahoo.com.au> <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com> <200811210025.39568.nickpiggin@yahoo.com.au> <20081120135558.GB24308@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120135558.GB24308@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:55:58PM +0000, Ralf Baechle wrote:
> It's better to avoid aliases than dealing with them by flushing.  A way to
> avoid aliases whenever a page is mapped to userspace, one creates a mapping
> at a carefully choosen address that doesn't alias.  On architectures with
> software reload TLBs such as MIPS that's very cheap and the entire
> cacheflush with all it's associated pains can go away.  Right now MIPS uses
> such a mechanism:
> 
>   void *kmap_coherent(struct page *page, unsigned long addr);
>   void kunmap_coherent(void);

Yes, we effectively already do that for our copy_user_highpage/
clear_user_highpage (note: we really want to override both of those
functions, not just one as the code in include/linux/highmem.h is
currently setup.  And I wish that V4L didn't use the non-highmem
clear_user_page() call...)

Why?  On ARM, we're starting to support highmem on VIVT and VIPT, and
having *_user_highpage() kmap, and then have the *_user_page() setup
yet another mapping for VIPT caches is just silly.

Which reminds me that I need to get a patch to make clear_user_highpage()
overridable out on the relevent lists...

> within the architecture private implementation but it could be use beyond
> that, probably on all architectures though I know that there would be some
> solvable issues on PARISC.  Lightweight, no ordering constraints between
> kernel and userspace accesses, so also no locking needed.

The "no locking needed" depends.  If we're going to be asking drivers
to copy use such an interface in order to copy data into page cache
pages, you can't have two drivers calling it from interrupt context
without some form of locking.

Nor if you're SMP and you don't have the mappings setup per-CPU.

However, as davem has said in the past, the result of a device reading
or writing the page cache should result in the same conditions no
matter how the read or write is actually done.  That's only common
sense.  So ensuring that device PIO accesses are done with the same
cache colour as userspace results in a difference between PIO and DMA,
one which could potentially bite if we end up reading from the kernel
mapping of those pages first.

If we extend the argument that "everything must be the same cache colour"
then we need cache colouring when allocating page cache pages - since
page cache pages are part of the kernel direct mapped memory, their
colour is already fixed from the time that you've setup the initial
kernel memory mappings.  In ARMs case of an aliasing VIPT cache, that
means that VA [13:12] must equal PA [13:12] for every single mapping
no matter where...

That would be nice, since we don't then have to worry about aliases
between kernel and userspace anymore, so we don't have to play these
remapping games in kernel space. ;)
