Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0CIPWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:22:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0CIPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:22:27 -0500
Message-ID: <4B9667AB.9050507@redhat.com>
Date: Tue, 09 Mar 2010 10:22:19 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Sachin Sant <sachinp@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH -tip][URGENT] kprobes: Calculate the index correctly when
 freeing the out-of-line execution slot.
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From : Ananth N Mavinakayanahalli <ananth@in.ibm.com>

When freeing the instruction slot, the arithmetic to calculate the index
of the slot in the page needs to account for the total size of the
instruction on the various architectures.

Calculate the index correctly when freeing the out-of-line execution slot.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Sachin Sant <sachinp@in.ibm.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
Index: linux-8mar/kernel/kprobes.c
===================================================================
--- linux-8mar.orig/kernel/kprobes.c	2010-03-08 17:10:33.000000000 +0530
+++ linux-8mar/kernel/kprobes.c	2010-03-08 17:12:12.000000000 +0530
@@ -259,7 +259,8 @@
 	struct kprobe_insn_page *kip;
 
 	list_for_each_entry(kip, &c->pages, list) {
-		long idx = ((long)slot - (long)kip->insns) / c->insn_size;
+		long idx = ((long)slot - (long)kip->insns) /
+				(c->insn_size * sizeof(kprobe_opcode_t));
 		if (idx >= 0 && idx < slots_per_page(c)) {
 			WARN_ON(kip->slot_used[idx] != SLOT_USED);
 			if (dirty) {
-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
