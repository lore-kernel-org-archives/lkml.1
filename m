Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYD0FHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYD0FHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYD0FH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:07:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33001
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYD0FH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:07:26 -0400
Date: Sat, 26 Apr 2008 22:07:26 -0700 (PDT)
Message-Id: <20080426.220726.13692428.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk
Subject: find_new_bit bloat from x86 tree...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, what the heck is this?

commit 64970b68d2b3ed32b964b0b30b1b98518fde388e
Author: Alexander van Heukelum <heukelum@mailshack.com>
Date:   Tue Mar 11 16:17:19 2008 +0100

    x86, generic: optimize find_next_(zero_)bit for small constant-size bitmaps

Thanks for bloating up the inline expansion of this thing on every
architecture that doesn't do __ffs() in a simple sequence of a few
instructions like x86 does.

Now every call that matches your tests gets this turd inline:

static inline unsigned long __ffs(unsigned long word)
{
	int num = 0;

#if BITS_PER_LONG == 64
	if ((word & 0xffffffff) == 0) {
		num += 32;
		word >>= 32;
	}
#endif
	if ((word & 0xffff) == 0) {
		num += 16;
		word >>= 16;
	}
	if ((word & 0xff) == 0) {
		num += 8;
		word >>= 8;
	}
	if ((word & 0xf) == 0) {
		num += 4;
		word >>= 4;
	}
	if ((word & 0x3) == 0) {
		num += 2;
		word >>= 2;
	}
	if ((word & 0x1) == 0)
		num += 1;
	return num;
}

as well as all of that address formation, bit shifting, and masking.

Please revert or make this conditional on something architectures can
opt-in for.

The version actually applied was posted only on linux-kernel, instead
of also CC:'ing linux-arch as previous versions had been.  Nobody
commented on this version other than you Ingo.
