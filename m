Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYHDEB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYHDEB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 00:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYHDEBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 00:01:17 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26384 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbYHDEBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 00:01:16 -0400
Date: Mon, 4 Aug 2008 13:00:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: "Wu, Bryan" <Bryan.Wu@analog.com>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
Message-ID: <20080804040025.GA11127@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	"Wu, Bryan" <Bryan.Wu@analog.com>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080728150501.GC16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org> <27552.1217599279@redhat.com> <20080801214448.GA13448@linux-sh.org> <8bd0f97a0808032024x18a31d29tb44ebc6216a2aed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0808032024x18a31d29tb44ebc6216a2aed@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 11:24:21PM -0400, Mike Frysinger wrote:
> On Fri, Aug 1, 2008 at 5:44 PM, Paul Mundt wrote:
> > On Fri, Aug 01, 2008 at 03:01:19PM +0100, David Howells wrote:
> >> Paul Mundt <lethal@linux-sh.org> wrote:
> >> > +    * In some cases (e.g. Hyper-Threading), we want to avoid L1
> >> > +    * evictions by the processes running on the same package. One
> >> > +    * thing we can do is to shuffle the initial stack for them, so
> >> > +    * we give the architecture an opportunity to do so here.
> >> > +    */
> >> >  #ifdef CONFIG_MMU
> >> > -   sp = bprm->p;
> >> > +   sp = arch_align_stack(bprm->p);
> >> >  #else
> >> > -   sp = mm->start_stack;
> >> > +   sp = arch_align_stack(mm->start_stack);
> >>
> >> Ummm...  You're calling arch_align_stack() under NOMMU...  Is that really a
> >> good idea?
> >
> > Not particularly, no.
> >
> >> You can't necessarily move the stack pointer without exiting the allocated
> >> region or shrinking the amount of stack space the executable asked for.  If
> >> you want to do this sort of thing, you need to tell the memory allocator what
> >> you're up to - or at the very least allocate some slack.
> >
> > Yes, that's a good point, and one that probably ought to be documented
> > alongside the initial alignment. I'll send an updated patch.
> 
> fs/binfmt_elf_fdpic.c: In function 'create_elf_fdpic_tables':
> fs/binfmt_elf_fdpic.c:497: error: implicit declaration of function
> 'arch_align_stack'
> make[1]: *** [fs/binfmt_elf_fdpic.o] Error 1
> make: *** [fs] Error 2
> 
> Blackfin lacks a arch_align_stack(x) in asm-blackfin/system.h ... i
> imagine a stub will work for us like every other arch though
> 
> feel like doing that Bryan ?  i'm guessing Paul doesnt want to ... ;)

There's no need, as David pointed out, that was the wrong thing to do for
the nommu case anyways. Here's an updated patch to replace the previous
one:

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 80c1f95..10c6cb8 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -472,9 +472,16 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	int loop;
 	int nr;	/* reset for each csp adjustment */
 
-	/* we're going to shovel a whole load of stuff onto the stack */
 #ifdef CONFIG_MMU
-	sp = bprm->p;
+	/*
+	 * we're going to shovel a whole load of stuff onto the stack
+	 *
+	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
+	 * evictions by the processes running on the same package. One
+	 * thing we can do is to shuffle the initial stack for them, so
+	 * we give the architecture an opportunity to do so here.
+	 */
+	sp = arch_align_stack(bprm->p);
 #else
 	sp = mm->start_stack;
 
@@ -499,20 +506,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 			return -EFAULT;
 	}
 
-#if defined(__i386__) && defined(CONFIG_SMP)
-	/* in some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
-	 * by the processes running on the same package. One thing we can do is
-	 * to shuffle the initial stack for them.
-	 *
-	 * the conditionals here are unneeded, but kept in to make the code
-	 * behaviour the same as pre change unless we have hyperthreaded
-	 * processors. This keeps Mr Marcelo Person happier but should be
-	 * removed for 2.5
-	 */
-	if (smp_num_siblings > 1)
-		sp = sp - ((current->pid % 64) << 7);
-#endif
-
 	sp &= ~7UL;
 
 	/* stack the load map(s) */
