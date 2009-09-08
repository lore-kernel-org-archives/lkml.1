Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZIHQxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZIHQxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZIHQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZIHQxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:53:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC PATCH tracing/kprobes] kprobes: Call vmalloc_sync_all() for
	avoiding in-kernel paging on kprobes
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 08 Sep 2009 12:54:38 -0400
Message-ID: <20090908165438.24437.40931.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <4A99E8CB.1040600@redhat.com>
References: <4A99E8CB.1040600@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call vmalloc_sync_all() before registering new kprobes and using new
instruction buffers to sync page table entries of the pages on where
kprobes data structure and instruction buffers are.
With this patch, kprobes can avoid in-kernel on-demand paging on these
kprobes, and it allows kprobes to put probes on page-fault path.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 kernel/kprobes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 00d01b0..7cc8266 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
+#include <linux/vmalloc.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -191,6 +192,7 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 		kfree(kip);
 		return NULL;
 	}
+	vmalloc_sync_all();	/* Prohibit on-demand kernel paging on kprobe */
 	INIT_LIST_HEAD(&kip->list);
 	list_add(&kip->list, &kprobe_insn_pages);
 	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
@@ -724,6 +726,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 	}
 	preempt_enable();
 
+	vmalloc_sync_all();	/* Prohibit on-demand kernel paging on kprobe */
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
