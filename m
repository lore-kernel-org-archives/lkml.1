Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbYD1Llw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbYD1Llw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbYD1Lln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:41:43 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:15906 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763309AbYD1Llm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:41:42 -0400
Date: Mon, 28 Apr 2008 13:41:05 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       heukelum@fastmail.fm
Subject: Re: find_new_bit bloat from x86 tree...
Message-ID: <20080428114104.GA28348@mailshack.com>
References: <20080426.220726.13692428.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.220726.13692428.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 28 Apr 2008 13:41:21 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.10; VDF: 7.0.3.220; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:07:26PM -0700, David Miller wrote:
> Ingo, what the heck is this?
> 
> commit 64970b68d2b3ed32b964b0b30b1b98518fde388e
> Author: Alexander van Heukelum <heukelum@mailshack.com>
> Date:   Tue Mar 11 16:17:19 2008 +0100
> 
>     x86, generic: optimize find_next_(zero_)bit for small constant-size bitmaps
> 
> Thanks for bloating up the inline expansion of this thing on every
> architecture that doesn't do __ffs() in a simple sequence of a few
> instructions like x86 does.
> 
> Now every call that matches your tests gets this turd inline:
> 
> static inline unsigned long __ffs(unsigned long word)
> {
> 	int num = 0;
> 
> #if BITS_PER_LONG == 64
> 	if ((word & 0xffffffff) == 0) {
> 		num += 32;
> 		word >>= 32;
> 	}
> #endif
> 	if ((word & 0xffff) == 0) {
> 		num += 16;
> 		word >>= 16;
> 	}
> 	if ((word & 0xff) == 0) {
> 		num += 8;
> 		word >>= 8;
> 	}
> 	if ((word & 0xf) == 0) {
> 		num += 4;
> 		word >>= 4;
> 	}
> 	if ((word & 0x3) == 0) {
> 		num += 2;
> 		word >>= 2;
> 	}
> 	if ((word & 0x1) == 0)
> 		num += 1;
> 	return num;
> }
> 
> as well as all of that address formation, bit shifting, and masking.
> 
> Please revert or make this conditional on something architectures can
> opt-in for.

Alternatively, implement __ffs out of line? Like:

static inline unsigned long __ffs(unsigned long word)
{
	return generic___ffs(word);
}

And a generic___ffs implemented in lib/ffs.c?

If __ffs is too big to be inlined it should not be inlined. That
is a generic problem and has nothing to do with this patch, IMHO.

Greetings,
	Alexander

> The version actually applied was posted only on linux-kernel, instead
> of also CC:'ing linux-arch as previous versions had been.  Nobody
> commented on this version other than you Ingo.
