Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbYKKTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbYKKTSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYKKTSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:18:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbYKKTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:18:03 -0500
Date: Tue, 11 Nov 2008 11:18:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: rc4-mmotm1110 - Another build error
Message-Id: <20081111111800.a0671f1e.akpm@linux-foundation.org>
In-Reply-To: <7421.1226430297@turing-police.cc.vt.edu>
References: <38231.1226373633@turing-police.cc.vt.edu>
	<20081110194353.1a1f616e.akpm@linux-foundation.org>
	<7421.1226430297@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 14:04:57 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Mon, 10 Nov 2008 19:43:53 PST, Andrew Morton said:
> > On Mon, 10 Nov 2008 22:20:33 -0500 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > gcc --version says:
> > > gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
> > > 
> > > ka-blam number 2:
> > > 
> > >   CC      kernel/audit.o
> > > In file included from include/net/dst.h:15,
> > >                  from include/net/sock.h:57,
> > >                  from kernel/audit.c:54:
> > > include/net/neighbour.h:114: error: braced-group within expression allowed 
> only inside a function
> > > make[1]: *** [kernel/audit.o] Error 1
> > > 
> > > I'm placing bets on patches/align-avoid-evaluating-its-argument-twice.patch
> > > 
> > > Yep, revert that patch, and audit.o compiles again.
> > > 
> > 
> > I hadn't got around to testing that one yet.
> > 
> > So ug.  ALIGN() is used in array sizing and hence has to be a
> > compile-time thing.  But ALIGN(foo, bar()) will call bar() twice.
> > 
> > Now how do we fix that?
> 
> Can we abuse __builtin_constant_p somehow?  Maybe we can make a definition
> something like:
> 
> #define __align_mask(x,mask) (
> 	__builtin_constant_p(mask) ? {
> 		(((x)+(mask))&~(mask)) :
> 		{              \
> 		      typeof(mask) __mask = mask;             \
> 		       (((x) + __mask) & ~__mask);             \
> 		}
> 	})
> 
> If it's a compile-time constant, it's safe to evaluate mask twice.

This seems to compile:

int y;
char x[__builtin_constant_p(1) ? 42 : y + 1];

so yes, that might work.  For this gcc version.  However I suspect that
it would blow up on us.  We keep on having problems with the
__builtin_constant_p() in kmalloc() doing wrong things (with gcc-3.2.x,
iirc).

It'd be worth trying though.

DIV_ROUND_UP() and roundup() are busted too.
