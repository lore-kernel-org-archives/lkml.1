Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbZDNEnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbZDNEnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbZDNEnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:43:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55613 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZDNEnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:43:40 -0400
Date: Tue, 14 Apr 2009 14:43:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: origin tree build failure
Message-Id: <20090414144317.026498df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (sparc defconfig) failed like this:

In file included from kernel/panic.c:12:
include/linux/debug_locks.h: In function '__debug_locks_off':
include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'

Caused by commit 9eeba6138cefc0435695463ddadb0d95e0a6bcd2 ("lockdep: warn
about lockdep disabling after kernel taint").  xchg is defined in
asm/system.h on sparc. It looks like asm/atomic.h on 64bit sparc includes
asm/system.h, but not on 32bit.

Dave, arch/sparc/include/asm/atomic_32.h should really include
asm/system.h since xchg is used in there.

I have applied the following patch for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 14 Apr 2009 14:27:09 +1000
Subject: [PATCH] sparc: asm/atomic.h on 32bit should include asm/system.h for xchg

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/atomic_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index ce46597..bb91b12 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -15,6 +15,8 @@
 
 #ifdef __KERNEL__
 
+#include <asm/system.h>
+
 #define ATOMIC_INIT(i)  { (i) }
 
 extern int __atomic_add_return(int, atomic_t *);
-- 
1.6.2.1

