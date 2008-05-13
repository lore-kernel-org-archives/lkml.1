Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYEMN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYEMN7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbYEMN7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:59:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYEMN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:59:10 -0400
Date: Tue, 13 May 2008 14:58:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Nickolay Vinogradov <nickolay@protei.ru>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
Message-ID: <20080513135839.GA19291@flint.arm.linux.org.uk>
References: <481E076A.8060302@protei.ru> <1210677433.22341.1252875863@webmail.messagingengine.com> <48298990.7040705@protei.ru> <1210685053.13437.1252892061@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210685053.13437.1252892061@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 03:24:13PM +0200, Alexander van Heukelum wrote:
> On Tue, 13 May 2008 16:29:04 +0400, "Nickolay Vinogradov"
> <nickolay@protei.ru> said:
> > Alexander van Heukelum &#1087;&#1080;&#1096;&#1077;&#1090;:
> > 
> > > Hi Nickolay,
> > > 
> > > The change is ok, I guess, but the cast should be a no-op (fls
> > > takes an int, which is always 32 bit in linux). What is the problem
> > > you are seeing? Does fls64() return a wrong value in some cases? If
> > > so, what cpu? Which values?
> > > 
> > > Why would this be a bug on big endian systems only? There is no
> > > pointer magic involved, so the compiler should take care of the
> > > casts in a correct way.
> > > 
> > > Maybe you see a compiler warning? Which compiler version?
> > > 
> > > (also note that current (development) kernels now have separate
> > > versions for 32-bit and 64-bit environments.)
> > 
> > Because fls() is a macro for asm-arm:
> > 
> > #define fls(x) \
> >          ( __builtin_constant_p(x) ? constant_fls(x) : \
> >          ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
> > 32-__r; }) )
> > 
> > We can fix it right here:

No.  "fls" is for finding the last set bit in an _int_.  It is not
supposed to have random crap passed to it, such as types longer than
sizeof(int).

If you're going to pass long long (64-bit) arguments to fls, and then
cast them to a u32, you're truncating the value, and you'll get the
wrong answer if bit 33 or greater is set.  If you don't actually care
about the upper bits, don't pass a 64-bit quantity to fls().

If you want to use fls with a long long, use fls64 instead.  Or for top
marks, use a u64 and fls64.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
