Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYKRQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYKRQa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYKRQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:30:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35128 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYKRQaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:30:04 -0500
Message-ID: <4922ED4D.8070201@redhat.com>
Date: Tue, 18 Nov 2008 11:29:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] bugfix: pass aggr_kprobe to arch_remove_kprobe
References: <200811140028.mAE0SppC021444@imap1.linux-foundation.org>
In-Reply-To: <200811140028.mAE0SppC021444@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

akpm@linux-foundation.org wrote:
> The patch titled
>      kprobes: support probing module __exit function
> has been added to the -mm tree.  Its filename is
>      kprobes-support-probing-module-__exit-function.patch

I found that one bug was still alive. Here is the bugfix.

Thank you,

Call arch_remove_kprobe() with aggr_kprobe instead of user specific kprobe,
because the user specific kprobe on the gone or reused aggr_kprobe may have
invalid arch_specific_insn.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/kprobes.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: 2.6-rc/kernel/kprobes.c
===================================================================
--- 2.6-rc.orig/kernel/kprobes.c
+++ 2.6-rc/kernel/kprobes.c
@@ -766,14 +766,14 @@ static void __kprobes __unregister_kprob
 {
 	struct kprobe *old_p;

-	if (list_empty(&p->list) || list_is_singular(&p->list)) {
-		if (!list_empty(&p->list)) {
-			/* "p" is the last child of an aggr_kprobe */
-			old_p = list_entry(p->list.next, struct kprobe, list);
-			list_del(&p->list);
-			kfree(old_p);
-		}
+	if (list_empty(&p->list))
 		arch_remove_kprobe(p);
+	else if (list_is_singular(&p->list)) {
+		/* "p" is the last child of an aggr_kprobe */
+		old_p = list_entry(p->list.next, struct kprobe, list);
+		list_del(&p->list);
+		arch_remove_kprobe(old_p);
+		kfree(old_p);
 	}
 }


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


