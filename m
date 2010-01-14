Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033Ab0ANWx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0ANWx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792Ab0ANWxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:53:48 -0500
Received: from kroah.org ([198.145.64.141]:58177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab0ANWwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:52:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 14:48:06 2010
Message-Id: <20100114224806.617287984@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 14:46:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [3/9] kernel/signal.c: fix kernel information leak with print-fatal-signals=1
In-Reply-To: <20100114224848.GA532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -939,7 +939,8 @@ static void print_fatal_signal(struct pt
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
-			__get_user(insn, (unsigned char *)(regs->ip + i));
+			if (get_user(insn, (unsigned char *)(regs->ip + i)))
+				break;
 			printk("%02x ", insn);
 		}
 	}


