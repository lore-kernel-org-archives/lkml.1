Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab0CKOmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:42:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:35513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0CKOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:42:13 -0500
Date: Thu, 11 Mar 2010 14:39:40 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sachinp@in.ibm.com, ananth@in.ibm.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <4B9667AB.9050507@redhat.com>
References: <4B9667AB.9050507@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes: Calculate the index correctly when freeing the out-of-line execution slot
Message-ID: <tip-83ff56f46a8532488ee364bb93a9cb2a59490d33@git.kernel.org>
Git-Commit-ID: 83ff56f46a8532488ee364bb93a9cb2a59490d33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:39:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83ff56f46a8532488ee364bb93a9cb2a59490d33
Gitweb:     http://git.kernel.org/tip/83ff56f46a8532488ee364bb93a9cb2a59490d33
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 9 Mar 2010 10:22:19 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 14:06:16 +0100

kprobes: Calculate the index correctly when freeing the out-of-line execution slot

>From : Ananth N Mavinakayanahalli <ananth@in.ibm.com>

When freeing the instruction slot, the arithmetic to calculate
the index of the slot in the page needs to account for the total
size of the instruction on the various architectures.

Calculate the index correctly when freeing the out-of-line
execution slot.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <4B9667AB.9050507@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index fa034d2..0ed46f3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -259,7 +259,8 @@ static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
 	struct kprobe_insn_page *kip;
 
 	list_for_each_entry(kip, &c->pages, list) {
-		long idx = ((long)slot - (long)kip->insns) / c->insn_size;
+		long idx = ((long)slot - (long)kip->insns) /
+				(c->insn_size * sizeof(kprobe_opcode_t));
 		if (idx >= 0 && idx < slots_per_page(c)) {
 			WARN_ON(kip->slot_used[idx] != SLOT_USED);
 			if (dirty) {
