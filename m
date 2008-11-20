Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYKTN4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYKTN4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYKTN4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:56:20 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:47986 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752595AbYKTN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:56:19 -0500
Date: Thu, 20 Nov 2008 13:55:58 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, Naval Saini <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline
	kernel (specifically arm in our case)
Message-ID: <20081120135558.GB24308@linux-mips.org>
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com> <200811201759.01039.nickpiggin@yahoo.com.au> <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com> <200811210025.39568.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811210025.39568.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:25:39AM +1100, Nick Piggin wrote:

> > > - The page is sent to the block layer, which stores into the page. Some
> > >  block devices like 'brd' will potentially store via the kernel linear
> > > map here, and they probably don't do enough cache flushing.
> >
> > btw., if someone is curious, here is another case of what may happen
> > on VIPT systems when someone uses a "virtual" block device (like
> > 'brd') as, heh, a swap :-)
> >
> > http://www.linux-mips.org/archives/linux-mips/2008-11/msg00038.html
> 
> Right... Now I'm lacking knowledge when it comes to devices, but I
> think it is probably reasonable for the block device layer to ensure
> the physical memory is uptodate after it signals request completion.
> 
> That is, there shouldn't be any potentially aliasing dirty lines.
> Block devices which do any writeout via the kernel linear address
> (eg. brd) should do a flush_dcache_page.

It's better to avoid aliases than dealing with them by flushing.  A way to
avoid aliases whenever a page is mapped to userspace, one creates a mapping
at a carefully choosen address that doesn't alias.  On architectures with
software reload TLBs such as MIPS that's very cheap and the entire
cacheflush with all it's associated pains can go away.  Right now MIPS uses
such a mechanism:

  void *kmap_coherent(struct page *page, unsigned long addr);
  void kunmap_coherent(void);

within the architecture private implementation but it could be use beyond
that, probably on all architectures though I know that there would be some
solvable issues on PARISC.  Lightweight, no ordering constraints between
kernel and userspace accesses, so also no locking needed.

Does this look like a possible avenue?

  Ralf
