Return-Path: <linux-kernel-owner+w=401wt.eu-S1760985AbYB0X6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985AbYB0X6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbYB0X6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:58:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbYB0X6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:58:36 -0500
Date: Thu, 28 Feb 2008 00:58:35 +0100
From: Jan Hubicka <hubicka@ucw.cz>
To: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org,
       zadeck@naturalbridge.com
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline  __attribute__((format (printf,x,y) to statement expression macros
Message-ID: <20080227235835.GA31048@atrey.karlin.mff.cuni.cz>
References: <1204081722.19319.405.camel@localhost> <1204084947.19319.411.camel@localhost> <20080227041316.GA23188@parisc-linux.org> <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com> <1204095249.19319.444.camel@localhost> <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> -static inline void __attribute__((format(printf, 1, 2)))
> -__simple_attr_check_format(const char *fmt, ...)

It would be nice to have a testcase, but I guess it is because GCC can't
inline variadic functions.  The function gets identified as const and
removed as unused by DCE, but this happens later (that is after early
inlining and before real inlining).  GCC 4.0.3 didn't have early inliner
so it is probably where the difference is comming from.

One possibility to handle this side case would be to mark const
functions early during early optimization and only refine it using
Kenny's existing IPA pass that should turn this issue into no-op.

We probably also can simply allow inlining variadic functions not
calling va_start.  I must say that this option appeared to me but I was
unable to think of any sane use case.  This probably is one ;)

Honza
> -{
> -	/* don't do anything, just let the compiler check the arguments; */
> -}
> -
>  int simple_attr_open(struct inode *inode, struct file *file,
>  		     int (*get)(void *, u64 *), int (*set)(void *, u64),
>  		     const char *fmt);
> 
> The text size does become smaller:
> 
>    text    data     bss     dec     hex filename
> 5386111  846328  719560 6951999  6a143f vmlinux.before
> 5386047  846328  719560 6951935  6a13ff vmlinux.after
> 
> gcc 4.0.3 maintains the same text size for both cases, while it appears 
> gcc 4.1.3 and your version, 4.2.2, have this different behavior.
> 
> 		David
