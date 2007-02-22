Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXBVP3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXBVP3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933098AbXBVP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:29:44 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40798 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932601AbXBVP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:29:42 -0500
Date: Thu, 22 Feb 2007 16:29:38 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/18] Dont leak NT bit into next task
Message-ID: <20070222152938.GP13958@stusta.de>
References: <20070221014413.282048309@mini.kroah.org> <20070221014953.GD3684@kroah.com> <erh57g$oeb$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <erh57g$oeb$1@sea.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:00:15AM +0100, Giuseppe Bilotta wrote:
> On Wednesday 21 February 2007 02:49, Greg KH wrote:
> 
> >  /* frame pointer must be last for get_wchan */
> > -#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> > -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\n\t"
> > +#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> > +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
> 
> No idea if this is a problem or not, but you forgot a \n after popf.

A discussion of this issue is in the thread starting with [1]
(and I'd re-add the \n in -stable kernels with the patch below 
 (stolen from 2.6.16) no matter what happened in Linus' tree).

> Giuseppe "Oblomov" Bilotta

cu
Adrian

[1] http://lkml.org/lkml/2007/1/8/374


commit e02612a14b2b714e9d231d14c91e729f0f168299
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jan 9 03:36:59 2007 +0100

    x86_64: re-add a newline to RESTORE_CONTEXT
    
    RESTORE_CONTEXT lost a newline:
    http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg00559.html
    
    Reported by Steven M. Christey.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>

diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index 7b2c7aa..dacec59 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -21,7 +21,7 @@
 
 /* frame pointer must be last for get_wchan */
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\n\t"
 
 #define __EXTRA_CLOBBER  \
 	,"rcx","rbx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"
