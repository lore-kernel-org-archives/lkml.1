Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYGIJYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYGIJYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 05:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYGIJYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 05:24:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:52594 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbYGIJYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 05:24:22 -0400
Subject: Re: AZFS file system proposal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20080709111402.5af92580@mercedes-benz.boeblingen.de.ibm.com>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	 <200807011659.33413.arnd@arndb.de> <1215593918.8970.363.camel@pasglop>
	 <20080709111402.5af92580@mercedes-benz.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 19:23:34 +1000
Message-Id: <1215595414.8970.366.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 11:14 +0200, Maxim Shchetynin wrote:
> Am Wed, 09 Jul 2008 18:58:38 +1000
> schrieb Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> 
> > On Tue, 2008-07-01 at 16:59 +0200, Arnd Bergmann wrote:
> > > I wouldn't hold up merging the file system for this problem, but
> > > until it is solved, the Kconfig entry should probably have
> > > a "depends on PPC".
> > 
> > Better, use an ifdef for powerpc flags, and #else to pgprot_noncached.
> 
> Thank you Ben. Then, how about this?
> 
> azfs_mmap(struct file *file, struct vm_area_struct *vma)
> {
> ...
> ...
> ...
> #ifdef CONFIG_PPC
> 	pgprot_t page_prot;
> #endif
> ...
> ...
> ...
> #ifdef CONFIG_PPC
> 	page_prot = pgprot_val(vma->vm_page_prot);
> 	page_prot |= (_PAGE_NO_CACHE | _PAGE_RW);
> 	page_prot &= ~_PAGE_GUARDED;
> 	vma->vm_page_prot = __pgprot(page_prot);
> #else
> 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> #endif
> ...

I'd rather do

	pgprot_t  prot;

#ifdef CONFIG_PPC
	prot = <whatever>
#else
	prot = pgprot_noncached(...)
#endif
	vma->vm_page_prot = prot;

To limit the number of ifdef's

Cheers,
Ben.


