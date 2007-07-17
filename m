Return-Path: <linux-kernel-owner+w=401wt.eu-S937310AbXGQXyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937310AbXGQXyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbXGQXyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:54:35 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:49297 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608AbXGQXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:54:34 -0400
Date: Wed, 18 Jul 2007 00:54:17 +0100
From: Ben Dooks <ben@fluff.org>
To: David Miller <davem@davemloft.net>
Cc: viro@ftp.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, avi@qumranet.com
Subject: Re: [PATCH] smp_call_function_single() should be a macro on UP
Message-ID: <20070717235417.GA18459@fluff.org.uk>
References: <20070717212946.GP21668@ftp.linux.org.uk> <20070717.144042.41636155.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717.144042.41636155.davem@davemloft.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 02:40:42PM -0700, David Miller wrote:
> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Tue, 17 Jul 2007 22:29:46 +0100
> 
> > ... or we end up with header include order problems from hell.
> > E.g. on m68k this is 100% fatal - local_irq_enable() there
> > wants preempt_count(), which wants task_struct fields, which
> > we won't have when we are in smp.h pulled from sched.h.
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> I was going to fix the sparc64/UP build fallout by
> adding linux/kernel.h include to linux/smp.h but that
> definitely would not handle this m68k case at all.

This has broken _all_ ARM builds, due to using WARN_ON()
in this header. Warn on needs <asm/bug.h> and this is
needs <linux/kernel.h> to make it compile cleanly on ARM
which is unfortuantely what we where trying to avoid in
the first place?

This patch fixes the compile on ARM, but moves the
includes out of the CONFIG_SMP block.

diff -urpN -X linux-2.6.22-git9/Documentation/dontdiff linux-2.6.22-git9/include/linux/smp.h linux-2.6.22-git9-fix1/include/linux/smp.h
--- linux-2.6.22-git9/include/linux/smp.h	2007-07-18 00:40:45.000000000 +0100
+++ linux-2.6.22-git9-fix1/include/linux/smp.h	2007-07-18 00:43:24.000000000 +0100
@@ -7,15 +7,17 @@
  */
 
 #include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+
 #include <asm/system.h>
+#include <asm/bug.h>
 
 extern void cpu_idle(void);
 
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
-#include <linux/kernel.h>
-#include <linux/compiler.h>
 #include <linux/thread_info.h>
 #include <asm/smp.h>
 


-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
