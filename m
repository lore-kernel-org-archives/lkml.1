Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZAIK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZAIK1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZAIK11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:27:27 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:26987 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbZAIK10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:27:26 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20081231093356.GD32239@wotan.suse.de>
References: <20081218211543.GB10681@wotan.suse.de>
	 <20081229151731.2a2c5a02.akpm@linux-foundation.org>
	 <20081230040118.GA27679@wotan.suse.de> <20081230061344.GA28281@elte.hu>
	 <20081230102831.GB3189@wotan.suse.de> <m1bput4766.fsf@frodo.ebiederm.org>
	 <20081231015452.GC32239@wotan.suse.de> <m13ag44t20.fsf@frodo.ebiederm.org>
	 <20081231093356.GD32239@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 10:24:58 +0000
Message-Id: <1231496698.27350.49.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=Qzbw8KkqQomFq0D8k-EA:9 a=Q8tsD2oNcYoOjqq9BUgA:7 a=edMSyE67rOT9kOGT8qcmZRUi36YA:4 a=eqxxFxNu-gsA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Jeremy to CC

On Wed, 2008-12-31 at 10:33 +0100, Nick Piggin wrote:
> 
> > >> Ditching the swapper_pg_fixmap has some problems.
> > >> 
> > >> This appears to break early_printk to a usb debug port, which 
> > >> calls set_fixmap_nocache and expects the mapping to last.
> > >> 
> > >> This looks like it will have problems with Xen and other 
> > >> environments where we come in with a pre-populated page table,
> > >> possibly unmapping something important.
> > >
> > > My patch copies the early fixmap mappings to the new page table.

> > > Isn't this enough?
> > 
> > I'm not certain.  Xen can get really finicky if you mess with it's
> > pre-established mappings.  Which is one of the reasons why we 
> > preserve the current mappings.  It was a real struggle to find a 
> > solution that worked for everything last time we had a PAE problem,
> > and apparently we failed to test with large numbers of cpus in the
> > config.
> > 
> > So please excuse me if I'm leery of a quick fix, to code that is 
> > obviously insufficiently clean to do what needs to be done 
> > intentionally.
> 
> Well we should just ask the Xen people whether it will work or not.
> Why wouldn't it? Xen has to be able to cope with kernel mappings
> coming and going.

I think it should be fine from Xen's PoV since one_page_table_init()
correctly uses paravirt_alloc_pte() and set_pte() does the right thing
under Xen.

BTW, I needed this fixlet since set_pte takes a pte_t not a pteval_t,
otherwise:
  CC      arch/x86/mm/init_32.o
[...]arch/x86/mm/init_32.c: In function 'page_table_range_init':
[...]arch/x86/mm/init_32.c:188: error: incompatible type for argument 2 of 'set_pte'

diff -r cf59aba1694f arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c	Fri Jan 09 10:13:31 2009 +0000
+++ b/arch/x86/mm/init_32.c	Fri Jan 09 10:16:38 2009 +0000
@@ -185,7 +185,7 @@
 				newpte = one_page_table_init(pmd);
 				BUG_ON(lastpte + PTRS_PER_PTE != newpte);
 				for (i = 0; i < PTRS_PER_PTE; i++) {
-					set_pte(newpte + i, pte_val(*(pte + i)));
+					set_pte(newpte + i, *(pte + i));
 				}
 				pte = lastpte;
 			}

-- 
Ian Campbell
Current Noise: Firebird - Needle In The Groove

"Now we'll have to kill you."
		-- Linus Torvalds

