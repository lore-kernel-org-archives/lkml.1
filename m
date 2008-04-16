Return-Path: <linux-kernel-owner+w=401wt.eu-S1764361AbYDPNz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764361AbYDPNz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYDPNzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:55:49 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:22748 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYDPNzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:55:48 -0400
Date: Wed, 16 Apr 2008 15:55:08 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix find_next_bit breakage on ppc and powerpc
Message-ID: <20080416135508.GA16439@mailshack.com>
References: <1208191719.12568.1247788911@webmail.messagingengine.com> <20080416125724.GC6304@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080416125724.GC6304@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 16 Apr 2008 15:55:23 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.6; VDF: 7.0.3.174; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc (and ppc) have their have some code in their bitops.h
which used to be exacly the same as asm-generic/bitops/find.h.
Include this header instead.

This should also fix the compile problems due to the generic
find_next_bit changes. Those were fixed by Thomas Gleixner in
asm-generic/bitops/find.h earlier.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Wed, Apr 16, 2008 at 02:57:24PM +0200, Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > Hello Thomas,
> > 
> > I see Ingo has applied three fixes to the x86-tree:
> >     find_first_bit() ppc fix
> >     powerpc: fix powerpc build
> >     find_next_bit() fix
> > 
> > Could you please give some insight in what went wrong with
> > ppc and powerpc?
> > 
> > "find_first_bit() ppc fix" disables the use of find_first_bit
> > for every user of GENERIC_FIND_NEXT_BIT=y. It replaces it by a
> > macro to call find_next_bit with offset=0. It should be possible
> > for an arch to use GENERIC_FIND_NEXT_BIT=y and implement 
> > find_first_bit by itself.
> > 
> > "powerpc: fix powerpc build" removes the private 'implementation'
> > of asm-generic/bitops/find.h. It seems correct code to me. What
> > was the problem here? If it is duplicate declarations, then
> > I would suggest putting #ifndef GENERIC_FIND_NEXT_BIT around
> > them.
> > 
> > "find_next_bit() fix" changes asm-generic/bitops/find.h to
> > declare find_next_bit only if CONFIG_GENERIC_FIND_NEXT_BIT=n.
> > That is indeed a good change. It would be better if this
> > file disappeared completely, though.
> 
> we had trouble making ppc64 defconfig build fine with your bitops 
> changes applied (Thomas might still have the build failure logs). The 
> fixes are ad-hoc band-aids to get it to build. We used crosscompilers to 
> build on ppc64.

Hello,

Yeah, I reproduced the breakage on x86 by putting an #include
<asm-generic/bitops/find.h> in asm-x86/bitops.h. It's complaining
a lot, then. Sorry about that breakage. I should have put more
thought in the possibility of breakage due to that header file
(I did look at it, but I thought it was harmless).

Thomas' "find_next_bit() fix" is certainly needed and correct.
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>.

Could you/Thomas try the following on top of that fix? (i.e., with
"find_next_bit() fix" and "find_first_bit() ppc fix" removed?)
I think it should work then.

Architectures that use CONFIG_GENERIC_FIND_NEXT_BIT=y and include
asm-generic/bitops/find.h should be able to switch to the generic
find_first_bit implementation by setting GENERIC_FIND_FIRST_BIT=y
in asm-$ARCH/Kconfig and removing the #include <asm-generic/bitops/find.h>
from their asm-$ARCH/bitops.h.

Greetings,
	Alexander

 include/asm-powerpc/bitops.h |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index 2fc0c45..e2dbb53 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -318,23 +318,8 @@ static __inline__ unsigned long __fls(unsigned long x)
 	return __ilog2(x);
 }
 #include <asm-generic/bitops/fls64.h>
-
 #include <asm-generic/bitops/hweight.h>
-
-#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
-unsigned long find_next_zero_bit(const unsigned long *addr,
-				 unsigned long size, unsigned long offset);
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit-number of the first set bit, not the number of the byte
- * containing a bit.
- */
-#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
-unsigned long find_next_bit(const unsigned long *addr,
-			    unsigned long size, unsigned long offset);
+#include <asm-generic/bitops/find.h>
 
 /* Little-endian versions */
 
