Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXIXQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXIXQdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbXIXQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47488 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760651AbXIXQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:27 -0400
Date: Mon, 24 Sep 2007 09:21:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arnd@arndb.de, davem@davemloft.net,
       tglx@linutronix.de, mingo@elte.hu
Subject: [25/50] futex_compat: fix list traversal bugs
Message-ID: <20070924162122.GZ13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="futex_compat-fix-list-traversal-bugs.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arnd Bergmann <arnd@arndb.de>

commit 179c85ea53bef807621f335767e41e23f86f01df in mainline.

The futex list traversal on the compat side appears to have
a bug.

It's loop termination condition compares:

        while (compat_ptr(uentry) != &head->list)

But that can't be right because "uentry" has the special
"pi" indicator bit still potentially set at bit 0.  This
is cleared by fetch_robust_entry() into the "entry"
return value.

What this seems to mean is that the list won't terminate
when list iteration gets back to the the head.  And we'll
also process the list head like a normal entry, which could
cause all kinds of problems.

So we should check for equality with "entry".  That pointer
is of the non-compat type so we have to do a little casting
to keep the compiler and sparse happy.

The same problem can in theory occur with the 'pending'
variable, although that has not been reported from users
so far.

Based on the original patch from David Miller.

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex_compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -61,10 +61,10 @@ void compat_exit_robust_list(struct task
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (upending)
+	if (pending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (compat_ptr(uentry) != &head->list) {
+	while (entry != (struct robust_list __user *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:

-- 
