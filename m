Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYKTP1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYKTP1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbYKTP1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:27:38 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55997 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYKTP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:27:37 -0500
Date: Thu, 20 Nov 2008 08:27:19 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, Naval Saini <navalnovel@gmail.com>,
       linux-arch@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, naval.saini@nxp.com,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Message-ID: <20081120152719.GS1617@parisc-linux.org>
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com> <200811201759.01039.nickpiggin@yahoo.com.au> <b647ffbd0811200428u2b41b108ifb02872563c871ab@mail.gmail.com> <200811210025.39568.nickpiggin@yahoo.com.au> <20081120135558.GB24308@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120135558.GB24308@linux-mips.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
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
> 
> within the architecture private implementation but it could be use beyond
> that, probably on all architectures though I know that there would be some
> solvable issues on PARISC.  Lightweight, no ordering constraints between
> kernel and userspace accesses, so also no locking needed.

I'm not quite sure why you need kmap_coherent().  If a page is mapped into
userspace, you can find what address it's mapped to from
page->mapping->i_mmap and page->index.  OTOH, that's potentially
expensive since you need to grab the spinlock, and unless you have all
user addresses coherent with each other (like parisc does), you need to
figure out which process to be coherent with.

I know James Bottomley did an experiment (and did an OLS presentation
...) on unmapping the entire page cache and greatly expanding the kmap
area to do just this kind of thing.  I think he even got a speedup.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
