Return-Path: <linux-kernel-owner+w=401wt.eu-S935505AbZLQB2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935505AbZLQB2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763675AbZLQBU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:56 -0500
Received: from kroah.org ([198.145.64.141]:48107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763680AbZLQBUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.755651686@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [67/90] sparc64: Fix stack debugging IRQ stack regression.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 166e553a575f09485f6d0df8a1ef3c5991f7d953 ]

Commit 4f70f7a91bffdcc39f088748dc678953eb9a3fbd
(sparc64: Implement IRQ stacks.) has two bugs.

First, the softirq range check forgets to subtract STACK_BIAS
before comparing with %sp.  Next, on failure the wrong label
is jumped to, resulting in a bogus stack being loaded.

Reported-by: Igor Kovalenko <igor.v.kovalenko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/lib/mcount.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/sparc/lib/mcount.S
+++ b/arch/sparc/lib/mcount.S
@@ -64,8 +64,9 @@ mcount:
 2:	 sethi		%hi(softirq_stack), %g3
 	or		%g3, %lo(softirq_stack), %g3
 	ldx		[%g3 + %g1], %g7
+	sub		%g7, STACK_BIAS, %g7
 	cmp		%sp, %g7
-	bleu,pt		%xcc, 2f
+	bleu,pt		%xcc, 3f
 	 sethi		%hi(THREAD_SIZE), %g3
 	add		%g7, %g3, %g7
 	cmp		%sp, %g7
@@ -75,7 +76,7 @@ mcount:
 	 * again, we are already trying to output the stack overflow
 	 * message.
 	 */
-	sethi		%hi(ovstack), %g7		! cant move to panic stack fast enough
+3:	sethi		%hi(ovstack), %g7		! cant move to panic stack fast enough
 	 or		%g7, %lo(ovstack), %g7
 	add		%g7, OVSTACKSIZE, %g3
 	sub		%g3, STACK_BIAS + 192, %g3


