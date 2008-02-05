Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYBEQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYBEQAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYBEQAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:00:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54326 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbYBEP77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:59:59 -0500
Date: Tue, 5 Feb 2008 16:59:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205155959.GC24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org> <20080205154648.GA24331@elf.ucw.cz> <20080205154953.GA26829@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205154953.GA26829@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 16:49:53, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > > > In my usual dither, I'm rather hoping Arjan will have a clear answer.
> > > 
> > > 
> > > setarch works. If the apps come in source form they need fixing anyway (since I'd not be
> > > surprised of current gcc reorders variables), if not.. we only have 2 cases,
> > > the other case was the build process of emacs (which got fixed 5
> > > years ago).
> > 
> > uemacs ... broken with randomization
> > colums, sss ... local programs, broken with randomization
> > procinfo ... broken, randomization makes it die sooner.
> > mikmod ... broken with randomization
> > bsdsed ... broken with randomization
> > ...
> > Should I test few more?
> 
> just a quick debug question: do they all work if you start them via 
> setarch?

I was actually toggling randomization with 

echo 0|1 > /proc/sys/kernel/randomize_va_space

. Yes, setarch i386 -R /usr/local/bin/uemacs (etc) fixes them, too.
	
What about this?

Heap randomization breaks /lib/libc.so.5.4.33, make it possible to
randomize normal stuff but leave the heap alone.

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 18ed6dd..4b099ea 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1077,7 +1077,7 @@ #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGE
 	current->mm->start_stack = bprm->p;
 
 #ifdef arch_randomize_brk
-	if (current->flags & PF_RANDOMIZE)
+	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1))
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
