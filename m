Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441Ab0ANWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0ANWgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144Ab0ANWgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:36:11 -0500
Received: from kroah.org ([198.145.64.141]:60589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab0ANW2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/52] kernel/signal.c: fix kernel information leak with print-fatal-signals=1
Date: Thu, 14 Jan 2010 14:27:04 -0800
Message-Id: <1263508051-7868-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-24-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

commit b45c6e76bc2c72f6426c14bed64fdcbc9bf37cb0 upstream.

When print-fatal-signals is enabled it's possible to dump any memory
reachable by the kernel to the log by simply jumping to that address from
user space.

Or crash the system if there's some hardware with read side effects.

The fatal signals handler will dump 16 bytes at the execution address,
which is fully controlled by ring 3.

In addition when something jumps to a unmapped address there will be up to
16 additional useless page faults, which might be potentially slow (and at
least is not very efficient)

Fortunately this option is off by default and only there on i386.

But fix it by checking for kernel addresses and also stopping when there's
a page fault.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/signal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6705320..4d0658d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -939,7 +939,8 @@ static void print_fatal_signal(struct pt_regs *regs, int signr)
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
-			__get_user(insn, (unsigned char *)(regs->ip + i));
+			if (get_user(insn, (unsigned char *)(regs->ip + i)))
+				break;
 			printk("%02x ", insn);
 		}
 	}
-- 
1.6.6

