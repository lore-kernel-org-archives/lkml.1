Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZGJUea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZGJUea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZGJUeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:34:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbZGJUeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:34:22 -0400
Date: Fri, 10 Jul 2009 22:34:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] dma-debug: Fix the overlap() function to be correct
	and readable
Message-ID: <20090710203404.GA4234@elte.hu>
References: <20090710162848.GA26862@elte.hu> <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain> <20090710193110.GA28281@elte.hu> <20090710195157.GA31361@elte.hu> <alpine.LFD.2.01.0907101306000.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907101306000.3352@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 10 Jul 2009, Ingo Molnar wrote:
> > 
> > How about the patch below? Lightly tested.
> >  
> >  	if (!PageHighMem(page)) {
> > -		void *addr = ((char *)page_address(page)) + offset;
> > +		void *addr = (void *)page_address(page) + offset;
> > +
> 
> Why is that 'void *' cast there? page_address() is already a void *.
> 
> Other than that it obviously looks good to me. But I never see my 
> own bugs.

hm, indeed. I distinctly remember page_address() having been 
unsigned long ten years ago.

And yes, i still have a "highmem-2.2.21-A0" patch proving it:

--- linux/include/linux/pagemap.h.orig  Thu Oct  7 14:54:24 1999
+++ linux/include/linux/pagemap.h       Wed Oct 13 02:44:03 1999
@@ -11,12 +11,24 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/list.h>
 
-static inline unsigned long page_address(struct page * page)
+extern inline unsigned long FIXME_page_address(struct page * page)
 {
+       if (PageHIGHMEM(page))
+               BUG();
        return PAGE_OFFSET + ((page - mem_map) << PAGE_SHIFT);

Which, beyond being a rather embarrasing hunk (whose author i wont 
name voluntarily - i'll rather take the 5th), also shows that 
page_address() started out as an unsigned long.

Which got cleaned up for good once we added page->address, instead 
of the above direct calculation.

( Note to self: consider checking the types of core MM facilities 
  somewhat more frequently than every 10 years. )

	Ingo
