Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYBDN2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYBDN2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYBDN2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:28:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59569 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753833AbYBDN2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:28:39 -0500
Date: Mon, 4 Feb 2008 14:28:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080204132853.GA4630@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204130156.GA8730@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hmm, code in binfmt_elf is really strange.
> > 
> >         elf_bss += load_bias;
> >         elf_brk += load_bias;
> >         start_code += load_bias;
> >         end_code += load_bias;
> >         start_data += load_bias;
> >         end_data += load_bias;
> > 
> >         /* Calling set_brk effectively mmaps the pages that we need
> >          * for the bss and break sections.  We must do this before
> >          * mapping in the interpreter, to make sure it doesn't wind
> >          * up getting placed where the bss needs to go.
> >          */
> >         retval = set_brk(elf_bss, elf_brk);
> > 
> > ... so we allocate non-randoimzed brk, but later we just overwrite bss 
> > variable with new, shiner and better randomized value... without 
> > unmapping the old one... The code in binfmt_elf.c is really a mess.
> 
> hm, so it seems that it isnt even the randomization that causes the 
> problem - but somehow the randomization code itself is broken, right? 
> 
> Would you be interested in figuring out how to unbreak this? [if not, 
> could you send me the binary?]

Not sure this helps... If I only randomize _end_ of heap, it still
works. If I try to randomize beggining of heap, too, it will not even
start recent binaries :-(.
								Pavel

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 18ed6dd..9afc58f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -980,6 +983,16 @@ #endif
 	}
 
 	loc->elf_ex.e_entry += load_bias;
+
+
+	printk("%d: %x\n", current->pid, elf_brk);
+
+	extern unsigned long 	randomize_range(unsigned long start, unsigned long end, unsigned long len);
+
+	long random = randomize_range(0, 0x200000, 0);
+	elf_brk += random;
+//	elf_bss += random;
+
 	elf_bss += load_bias;
 	elf_brk += load_bias;
 	start_code += load_bias;
@@ -1076,12 +1093,6 @@ #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGE
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
-#ifdef arch_randomize_brk
-	if (current->flags & PF_RANDOMIZE)
-		current->mm->brk = current->mm->start_brk =
-			arch_randomize_brk(current->mm);
-#endif
-
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
