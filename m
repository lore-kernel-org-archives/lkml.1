Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZLYUaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZLYUaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZLYUaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:30:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48478 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZLYUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:30:05 -0500
Date: Fri, 25 Dec 2009 21:29:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: stable@kernel.org
Subject: [PATCH] Fix kernel information leak with print-fatal-signals=1
Message-ID: <20091225202956.GA23141@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel information leak with print-fatal-signals=1

When print-fatal-signals is enabled it's possible to dump
any memory reachable by the kernel to the log by simply jumping to
that address from user space. 

Or crash the system if there's some hardware with read
side effects.

The fatal signals handler will dump 16 bytes at the execution 
address, which is fully controlled by ring 3.

In addition when something jumps to a unmapped address there
will be up to 16 additional useless page faults, which might be potentially
slow (and at least is not very efficient)

Fortunately this option is off by default and only there on i386.

But fix it by checking for kernel addresses and also stopping
when there's a page fault.

Stable candidate.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc1-ak/kernel/signal.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/signal.c
+++ linux-2.6.33-rc1-ak/kernel/signal.c
@@ -979,7 +979,8 @@ static void print_fatal_signal(struct pt
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
-			__get_user(insn, (unsigned char *)(regs->ip + i));
+			if (get_user(insn, (unsigned char *)(regs->ip + i)))
+				break;
 			printk("%02x ", insn);
 		}
 	}
