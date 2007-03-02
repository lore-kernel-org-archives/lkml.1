Return-Path: <linux-kernel-owner+w=401wt.eu-S1422820AbXCBDue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820AbXCBDue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXCBDud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:50:33 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:39986 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422820AbXCBDud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:50:33 -0500
Date: Fri, 2 Mar 2007 12:48:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: John Reiser <jreiser@BitWagon.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070302034800.GA12530@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, John Reiser <jreiser@BitWagon.com>,
	Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070301175207.GA849@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301175207.GA849@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 08:52:07PM +0300, Oleg Nesterov wrote:
> > --- a/arch/i386/kernel/sysenter.c~fully-honor-vdso_enabled
> > +++ a/arch/i386/kernel/sysenter.c
> > @@ -22,6 +22,8 @@
> >  #include <asm/msr.h>
> >  #include <asm/pgtable.h>
> >  #include <asm/unistd.h>
> > +#include <asm/a.out.h>
> > +#include <asm/mman.h>
> >
> >  /*
> >   * Should the kernel map a VDSO page into processes and pass its
> > @@ -105,10 +107,25 @@ int arch_setup_additional_pages(struct l
> >  {
> >  	struct mm_struct *mm = current->mm;
> >  	unsigned long addr;
> > +	unsigned long flags;
> >  	int ret;
> >
> > +	switch (vdso_enabled) {
> > +	case 0:  /* none */
> > +		return 0;
> 
> This means we don't initialize mm->context.vdso and ->sysenter_return.
> 
> Is it ok? For example, setup_rt_frame() uses VDSO_SYM(&__kernel_rt_sigreturn),
> sysenter_past_esp pushes ->sysenter_return on stack.
> 
The setup_rt_frame() case is fairly straightforward, both PPC and SH
already check to make sure there's a valid context before trying to use
VDSO_SYM(), I'm not sure why x86 doesn't.

Though I wonder if there's any point in checking binfmt->hasvdso here?
There shouldn't be a valid mm->context.vdso in the !hasvdso case..

Someone else will have to comment on ->sysenter_return.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 arch/i386/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/i386/kernel/signal.c b/arch/i386/kernel/signal.c
index 4f99e87..f778d34 100644
--- a/arch/i386/kernel/signal.c
+++ b/arch/i386/kernel/signal.c
@@ -350,7 +350,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 			goto give_sigsegv;
 	}
 
-	if (current->binfmt->hasvdso)
+	if (current->binfmt->hasvdso && current->mm->context.vdso)
 		restorer = (void *)VDSO_SYM(&__kernel_sigreturn);
 	else
 		restorer = (void *)&frame->retcode;
