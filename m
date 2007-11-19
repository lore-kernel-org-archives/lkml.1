Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXKSSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXKSSWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXKSSVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:21:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41882 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXKSSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:21:33 -0500
Date: Mon, 19 Nov 2007 10:18:08 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/26] Fix compat futex hangs.
Message-ID: <20071119181808.GC15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-compat-futex-hangs.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
[FUTEX]: Fix address computation in compat code.

[ Upstream commit: 3c5fd9c77d609b51c0bab682c9d40cbb496ec6f1 ]

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
addresses with the top 32-bit clear.

Because of this compat futex layer bug we get into the following loop
when executing the get_user() load near the top of handle_futex_death():

1) load from address '0xfffffffff7f16bd8', FAULT
2) fault handler clears upper 32-bits, processes fault
   for address '0xf7f16bd8' which succeeds
3) goto #1

I want to thank Bernd Zeimetz, Josip Rodin, and Fabio Massimo Di Nitto
for their tireless efforts helping me track down this bug.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex_compat.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -29,6 +29,15 @@ fetch_robust_entry(compat_uptr_t *uentry
 	return 0;
 }
 
+static void __user *futex_uaddr(struct robust_list *entry,
+				compat_long_t futex_offset)
+{
+	compat_uptr_t base = ptr_to_compat(entry);
+	void __user *uaddr = compat_ptr(base + futex_offset);
+
+	return uaddr;
+}
+
 /*
  * Walk curr->robust_list (very carefully, it's a userspace list!)
  * and mark any locks found there dead, and notify any waiters.
@@ -61,18 +70,23 @@ void compat_exit_robust_list(struct task
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
+	if (pending) {
+		void __user *uaddr = futex_uaddr(pending,
+						 futex_offset);
+		handle_futex_death(uaddr, curr, pip);
+	}
 
 	while (entry != (struct robust_list __user *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
 		 */
-		if (entry != pending)
-			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
+		if (entry != pending) {
+			void __user *uaddr = futex_uaddr(entry,
+							 futex_offset);
+			if (handle_futex_death(uaddr, curr, pi))
 				return;
+		}
 
 		/*
 		 * Fetch the next entry in the list:

-- 
