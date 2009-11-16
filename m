Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZKPHBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZKPHBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 02:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZKPHBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 02:01:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38057 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZKPHBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 02:01:14 -0500
Date: Mon, 16 Nov 2009 18:01:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: tip tree build failure (Was: linux-next: tip tree build
 warning)
Message-Id: <20091116180118.aa1bf1e4.sfr@canb.auug.org.au>
In-Reply-To: <20091116162503.7f083c3a.sfr@canb.auug.org.au>
References: <20091116162503.7f083c3a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, 16 Nov 2009 16:25:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> arch/x86/kernel/apic/apic.c: In function 'calibrate_APIC_clock':
> arch/x86/kernel/apic/apic.c:650: warning: format '%ld' expects type 'long int', but argument 2 has type 'u32'
> 
> Introduced by commit 23af368e9a904f59256c27d371ce223d6cee0430
> ("clockevents: Use u32 for mult and shift factors").

Unfortunately, this produces this error on sparc64 (since they use -Werror
in arch/sparc) (sparc64 defconfig build):

arch/sparc/kernel/time_64.c: In function 'time_init':
arch/sparc/kernel/time_64.c:851: error: format '%lx' expects type 'long unsigned int', but argument 2 has type 'u32'

I applied the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 16 Nov 2009 17:54:47 +1100
Subject: [PATCH] sparc: fix printk for change of variable type

The clockevent mult field became a u32.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/time_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index da1218e..63f73ae 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -847,7 +847,7 @@ void __init time_init(void)
 	sparc64_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &sparc64_clockevent);
 
-	printk("clockevent: mult[%lx] shift[%d]\n",
+	printk("clockevent: mult[%ux] shift[%d]\n",
 	       sparc64_clockevent.mult, sparc64_clockevent.shift);
 
 	setup_sparc64_timer();
-- 
1.6.5.2


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
