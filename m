Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZF3VFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZF3VFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZF3VFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:05:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZF3VFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:05:15 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/3] kprobes: no need to unlock kprobe_insn_mutex
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>
Date: Tue, 30 Jun 2009 17:08:09 -0400
Message-ID: <20090630210809.17851.28781.stgit@localhost.localdomain>
In-Reply-To: <20090630210757.17851.409.stgit@localhost.localdomain>
References: <20090630210757.17851.409.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove needless kprobe_insn_mutex unlocking during safety check in garbage
collection, because if someone releases a dirty slot during safety check
(which ensures other cpus doesn't execute all dirty slots), the safety check
must be fail. So, we need to hold the mutex while checking safety.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
