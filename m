Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYG0Xpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYG0Xpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 19:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYG0Xpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 19:45:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34565 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYG0Xpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 19:45:33 -0400
Date: Mon, 28 Jul 2008 09:45:31 +1000
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Chandru <chandru@in.ibm.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-ID: <20080727234529.GM6175@verge.net.au>
References: <20080726092519.GA4341@elte.hu> <20080726031034.82e2feef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726031034.82e2feef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 03:10:34AM -0700, Andrew Morton wrote:
> On Sat, 26 Jul 2008 11:25:19 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > please apply before -rc1.
> > 
> > 	Ingo
> > 
> > ----------->
> > >From 72db7cba50b6a05825f8a287f74002cc38f04fb7 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Sat, 26 Jul 2008 11:22:33 +0200
> > Subject: [PATCH] crashdump: fix undefined reference to `elfcorehdr_addr'
> > 
> > fix build bug introduced by 95b68dec0d5 "calgary iommu: use the first
> > kernels TCE tables in kdump":
> > 
> >  arch/x86/kernel/built-in.o: In function `calgary_iommu_init':
> >  (.init.text+0x8399): undefined reference to `elfcorehdr_addr'
> >  arch/x86/kernel/built-in.o: In function `calgary_iommu_init':
> >  (.init.text+0x856c): undefined reference to `elfcorehdr_addr'
> >  arch/x86/kernel/built-in.o: In function `detect_calgary':
> >  (.init.text+0x8c68): undefined reference to `elfcorehdr_addr'
> >  arch/x86/kernel/built-in.o: In function `detect_calgary':
> >  (.init.text+0x8d0c): undefined reference to `elfcorehdr_addr'
> >
> > make elfcorehdr_addr a generally available symbol.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  include/linux/crash_dump.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> > index 6cd39a9..025e4f5 100644
> > --- a/include/linux/crash_dump.h
> > +++ b/include/linux/crash_dump.h
> > @@ -8,7 +8,13 @@
> >  #include <linux/proc_fs.h>
> >  
> >  #define ELFCORE_ADDR_MAX	(-1ULL)
> > +
> > +#ifdef CONFIG_PROC_VMCORE
> >  extern unsigned long long elfcorehdr_addr;
> > +#else
> > +static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> > +#endif
> > +
> >  extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
> >  						unsigned long, int);
> >  extern const struct file_operations proc_vmcore_operations;
> 
> spose that'll fix it.  But it seems odd that is_kdump_kernel() will
> return false if CONFIG_PROC_VMCORE=n, CONFIG_CRASH_DUMP=y.  I mean,
> it's still a crashdump kernel, is it not?

Perhaps is_kdump_kernel() ought to be renamed kernel_has_vmcore().

To my mind, is_kdump_kernel() should really look something like this:

#ifdef CONFIG_CRASH_DUMP
static inline int is_kdump_kernel(void) { return 1; }
#else
static inline int is_kdump_kernel(void) { return 0; }
#endif

But that can probably just be handled by any relevant code
using CONFIG_CRASH_DUMP as necessary.



-- 
Horms

