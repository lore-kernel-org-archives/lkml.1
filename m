Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZBDUdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZBDUdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZBDUc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:32:57 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:55726 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZBDUc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:32:56 -0500
Date: Wed, 4 Feb 2009 21:32:51 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Shane Hathaway <shane@hathawaymix.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
cc: Daolong Wang <ahlongxp@gmail.com>,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>, Am?rico Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
In-Reply-To: <alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be>
Message-ID: <Pine.LNX.4.64.0902042115530.25136@anakin>
References: <20090115194033.GA10926@hack.private>
 <20090116124158.4364e269.akpm@linux-foundation.org> <200901170328.15178.rob@landley.net>
 <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>
 <20090119152104.GC6432@c2.user-mode-linux.org>
 <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com>
 <49753063.8040007@hathawaymix.org> <alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Geert Uytterhoeven wrote:
> On Mon, 19 Jan 2009, Shane Hathaway wrote:
> > Daolong Wang wrote:
> > > On Mon, Jan 19, 2009 at 11:21 PM, Jeff Dike <jdike@addtoit.com> wrote:
> > >> On Sun, Jan 18, 2009 at 02:23:46PM +0800, Daolong Wang wrote:
> > >>> I can confirm this link error.
> > >> In what environment?  I see no problems here.
> > 
> > I can also confirm this link error.  The problem occurs when compiling
> > either 2.6.28.1 or 2.6.27.12; I didn't try anything earlier.  The patch
> > suggested at this beginning of this thread did solve the link problem
> > and the resulting kernel ran for several hours.  However, I think the
> > patch is still probably incorrect.
> > 
> > I'm going to repost what I said in another message I sent today, this
> > time with a wider audience:
> > 
> > The problem is that the name "sigprocmask" is getting renamed to
> > "kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
> > that name gets mangled into "sys_kernel_sigprocmask" by the
> > SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.
> > 
> > So, instead of the patch suggested earlier, I added the following line
> > to arch/um/sys-i386/sys_call_table.S:
> > 
> > #define sys_sigprocmask sys_kernel_sigprocmask
> > 
> > This made it compile and link correctly.  Look at the symbols generated
> > by the compile of signal.c to see what I mean:
> > 
> > # nm kernel/signal.o | grep sigprocmask
> > 0000008f r __kstrtab_kernel_sigprocmask
> > 00000040 r __ksymtab_kernel_sigprocmask
> > 00001ea6 T kernel_sigprocmask
> > 00002d67 T sys_kernel_sigprocmask
> > 00001faf T sys_rt_sigprocmask
> > 
> > Unfortunately, it's a mystery to me that others haven't run into this
> > before.  My host environment is RHEL 4 inside some kind of chroot.
> 
> I've just started seeing this problem with some 2.6.29-rc3 kernel...
> 
> Before, I did not have this problem with various 2.6.28-rc8 and 2.6.29-rc1
> kernels (and several older versions I don't remember).
> 
> Given 2.6.29-rc1 works for me and 2.6.28.1 fails for you, I'm inclined to
> believe 2.6.28 is OK. I'll give it a try...
> 
> BTW, I'm using CentOS 5.2.

Following up from home...

Indeed, 2.6.28 works, 2.6.28.1 doesn't.

According to git bisect, it got introduced by the system call security fixes
(CVE-2009-0029), more specifically by this part:

| commit fe7c0d987fb2cce464d29eec9dfcca6296b5eed7
| Author: Heiko Carstens <heiko.carstens@de.ibm.com>
| Date:   Wed Jan 14 14:14:06 2009 +0100
| 
|     System call wrappers part 04
|     
|     commit b290ebe2c46d01b742b948ce03f09e8a3efb9a92 upstream.
|     
|     Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
|     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
| 
| --- a/kernel/signal.c
| +++ b/kernel/signal.c
| @@ -2425,8 +2424,8 @@ sys_sigpending(old_sigset_t __user *set)
|  /* Some platforms have their own version with special arguments others
|     support only sys_rt_sigprocmask.  */
|  
| -asmlinkage long
| -sys_sigprocmask(int how, old_sigset_t __user *set, old_sigset_t __user *oset)
   ^^^^^^^^^^^^^^^
| +SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, set,
                   ^^^^^^^^^^^
| +		old_sigset_t __user *, oset)
|  {
|  	int error;
|  	old_sigset_t old_set, new_set;

Hence it allows sigprocmask to be redefined to kernel_sigprocmask by the C
preprocessor...

This got backported to 2.6.27.12 as well, confusing people who ran post-2.6.27
development kernels and never noticed the problem (including Jeff and me)...

It showed up in a "development" kernel in 2.6.29-rc2 only.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
