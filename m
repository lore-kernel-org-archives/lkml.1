Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYEMQLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYEMQLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYEMQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:11:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653AbYEMQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:11:43 -0400
Date: Tue, 13 May 2008 09:11:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Nickolay Vinogradov <nickolay@protei.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
Message-Id: <20080513091111.bd9437c1.akpm@linux-foundation.org>
In-Reply-To: <je7idyw9ua.fsf@sykes.suse.de>
References: <481E076A.8060302@protei.ru>
	<1210677433.22341.1252875863@webmail.messagingengine.com>
	<48298990.7040705@protei.ru>
	<1210685053.13437.1252892061@webmail.messagingengine.com>
	<20080513135839.GA19291@flint.arm.linux.org.uk>
	<je7idyw9ua.fsf@sykes.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 16:35:25 +0200 Andreas Schwab <schwab@suse.de> wrote:

> Russell King <rmk+lkml@arm.linux.org.uk> writes:
> 
> > On Tue, May 13, 2008 at 03:24:13PM +0200, Alexander van Heukelum wrote:
> >> On Tue, 13 May 2008 16:29:04 +0400, "Nickolay Vinogradov"
> >> <nickolay@protei.ru> said:
> >> > Alexander van Heukelum &#1087;&#1080;&#1096;&#1077;&#1090;:
> >> > 
> >> > > Hi Nickolay,
> >> > > 
> >> > > The change is ok, I guess, but the cast should be a no-op (fls
> >> > > takes an int, which is always 32 bit in linux). What is the problem
> >> > > you are seeing? Does fls64() return a wrong value in some cases? If
> >> > > so, what cpu? Which values?
> >> > > 
> >> > > Why would this be a bug on big endian systems only? There is no
> >> > > pointer magic involved, so the compiler should take care of the
> >> > > casts in a correct way.
> >> > > 
> >> > > Maybe you see a compiler warning? Which compiler version?
> >> > > 
> >> > > (also note that current (development) kernels now have separate
> >> > > versions for 32-bit and 64-bit environments.)
> >> > 
> >> > Because fls() is a macro for asm-arm:
> >> > 
> >> > #define fls(x) \
> >> >          ( __builtin_constant_p(x) ? constant_fls(x) : \
> >> >          ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
> >> > 32-__r; }) )
> >> > 
> >> > We can fix it right here:
> >
> > No.  "fls" is for finding the last set bit in an _int_.  It is not
> > supposed to have random crap passed to it, such as types longer than
> > sizeof(int).
> 
> If you write fls as an (inline) function then the argument is implicitly
> converted.
> 

Yes, and that's what other architectures do.

It's not pretty, but I do think the arm implementation should zap the
upper 32 bits as other architectures do, and as one would expect from
the usual C type conversion rules.

Converting it to a C implementation would be a suitable means...
