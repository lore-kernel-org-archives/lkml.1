Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZGAItp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZGAItp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZGAIt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:49:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbZGAItY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:49:24 -0400
Date: Wed, 1 Jul 2009 08:47:21 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, jkenisto@us.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090630210809.17851.28781.stgit@localhost.localdomain>
References: <20090630210809.17851.28781.stgit@localhost.localdomain>
Subject: [tip:tracing/core] kprobes: No need to unlock kprobe_insn_mutex
Message-ID: <tip-4a2bb6fcc80e6330ca2f2393e98605052cc7780b@git.kernel.org>
Git-Commit-ID: 4a2bb6fcc80e6330ca2f2393e98605052cc7780b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 08:47:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a2bb6fcc80e6330ca2f2393e98605052cc7780b
Gitweb:     http://git.kernel.org/tip/4a2bb6fcc80e6330ca2f2393e98605052cc7780b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 30 Jun 2009 17:08:09 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 10:43:07 +0200

kprobes: No need to unlock kprobe_insn_mutex

Remove needless kprobe_insn_mutex unlocking during safety check
in garbage collection, because if someone releases a dirty slot
during safety check (which ensures other cpus doesn't execute
all dirty slots), the safety check must be fail. So, we need to
hold the mutex while checking safety.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20090630210809.17851.28781.stgit@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/kprobes.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c0fa54b..16b5739 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -237,13 +237,9 @@ static int __kprobes collect_garbage_slots(void)
 {
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos, *next;
-	int safety;
 
 	/* Ensure no-one is preepmted on the garbages */
-	mutex_unlock(&kprobe_insn_mutex);
-	safety = check_safety();
-	mutex_lock(&kprobe_insn_mutex);
-	if (safety != 0)
+	if (check_safety())
 		return -EAGAIN;
 
 	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
