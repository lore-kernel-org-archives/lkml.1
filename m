Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXKGEeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXKGEeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXKGEef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:34:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47912
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbXKGEee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:34:34 -0500
Date: Tue, 06 Nov 2007 20:34:33 -0800 (PST)
Message-Id: <20071106.203433.144763156.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-arch@vger.kernel.org, bernd@bzed.de, joy@entuzijast.net,
       fabbione@ubuntu.com, arnd@arndb.de
Subject: Fix for sparc64 cpu hangs.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Bernd, Josip, and Fabio, I think I finally nailed this
  cpu hang bug we were all seeing on sparc64.  ]

[FUTEX]: Fix address computation in compat code.

compat_exit_robust_list() computes a pointer to the
futex entry in userspace as follows:

	(void __user *)entry + futex_offset

'entry' is a 'struct robust_list __user *', and
'futex_offset' is a 'compat_long_t' (typically a 's32').

Things explode if the 32-bit sign bit is set in futex_offset.

Type promotion sign extends futex_offset to a 64-bit value before
adding it to 'entry'.

This triggered a problem on sparc64 running 32-bit applications which
would lock up a cpu looping forever in the fault handling for the
userspace load in handle_futex_death().

Compat userspace runs with address masking (wherein the cpu zeros out
the top 32-bits of every effective address given to a memory operation
instruction) so the sparc64 fault handler accounts for this by
zero'ing out the top 32-bits of the fault address too.

Since the kernel properly uses the compat_uptr interfaces, kernel side
accesses to compat userspace work too since they will only use
addresses with the top 32-bits clear.

Because of this compat futex layer bug we get into the following loop
when executing the get_user() load near the top of handle_futex_death():

1) load from address '0xfffffffff7f16bd8', FAULT
2) fault handler clears upper 32-bits, processes fault
   for address '0xf7f16bd8' which succeeds
3) goto #1

I want to thank Bernd Zeimetz, Josip Rodin, and Fabio Massimo Di Nitto
for their tireless efforts helping me track down this bug.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 00b5726..8089e7e 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -76,11 +76,16 @@ void compat_exit_robust_list(struct task_struct *curr)
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
 		 */
-		if (entry != pending)
-			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
-				return;
+		if (entry != pending) {
+			void __user *uaddr;
+			compat_uptr_t base;
+
+			base = ptr_to_compat(entry);
+			uaddr = compat_ptr(base + futex_offset);
 
+			if (handle_futex_death(uaddr, curr, pi))
+				return;
+		}
 		if (rc)
 			return;
 		uentry = next_uentry;
