Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZDNJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZDNJQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZDNJQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:16:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56451 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZDNJQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:16:00 -0400
Date: Tue, 14 Apr 2009 11:15:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] lockdep: warn about lockdep disabling after kernel taint,
	fix
Message-ID: <20090414091538.GI27003@elte.hu>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414144317.026498df.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (sparc defconfig) failed like this:
> 
> In file included from kernel/panic.c:12:
> include/linux/debug_locks.h: In function '__debug_locks_off':
> include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'
> 
> Caused by commit 9eeba6138cefc0435695463ddadb0d95e0a6bcd2 ("lockdep: warn
> about lockdep disabling after kernel taint").  xchg is defined in
> asm/system.h on sparc. It looks like asm/atomic.h on 64bit sparc includes
> asm/system.h, but not on 32bit.
> 
> Dave, arch/sparc/include/asm/atomic_32.h should really include
> asm/system.h since xchg is used in there.
> 
> I have applied the following patch for today.

I dont think Sparc is at fault here - system.h is where we 
historically provided xchg() from. Then as atomic.h was introduced 
and extended, some architectures (x86 amongst them) gradually 
migrated their definition of xchg() into atomic.h and related helper 
headers. (while still making it available for system.h)

This opened up the path for someone eventually only including 
asm/atomic.h from generic code and breaking the architectures that 
only provide it via system.h. So i've queued up the fix below - this 
should address the problem on Sparc and s390.

So moving it to atomic.h does make sense - but that's no excuse for 
breaking the build. Sorry about this!

	Ingo

------------->
>From f99a7c31f427f8f783c7b1379755f91b59acaf72 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 14 Apr 2009 11:03:12 +0200
Subject: [PATCH] lockdep: warn about lockdep disabling after kernel taint, fix

Impact: build fix

Stephen Rothwell reported that the Sparc build broke:

 In file included from kernel/panic.c:12:
 include/linux/debug_locks.h: In function '__debug_locks_off':
 include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'

due to:

 9eeba61: lockdep: warn about lockdep disabling after kernel taint

There is some inconsistency between architectures about where exactly
xchg() is defined. Most have it in system.h but also in atomic.h (which
is arguably the more logical point for it). Some, such as Sparc only
have it in asm/system.h and not available via asm/atomic.h.

Use the widest set of headers in debug_locks.h and also include asm/system.h.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/debug_locks.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 493dedb..29b3ce3 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <asm/atomic.h>
+#include <asm/system.h>
 
 struct task_struct;
 
