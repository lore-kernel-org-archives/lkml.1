Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZKBQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZKBQUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbZKBQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:20:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:51873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794AbZKBQUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:20:40 -0500
Date: Mon, 2 Nov 2009 16:19:47 GMT
From: tip-bot for Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, jkenisto@us.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091030135310.GA22230@in.ibm.com>
References: <20091030135310.GA22230@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] kprobes: Sanitize struct kretprobe_instance allocations
Message-ID: <tip-4dae560f97fa438f373b53e14b30149c9e44a600@git.kernel.org>
Git-Commit-ID: 4dae560f97fa438f373b53e14b30149c9e44a600
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dae560f97fa438f373b53e14b30149c9e44a600
Gitweb:     http://git.kernel.org/tip/4dae560f97fa438f373b53e14b30149c9e44a600
Author:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
AuthorDate: Fri, 30 Oct 2009 19:23:10 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 17:00:18 +0100

kprobes: Sanitize struct kretprobe_instance allocations

For as long as kretprobes have existed, we've allocated NR_CPUS
instances of kretprobe_instance structures. With the default
value of CONFIG_NR_CPUS increasing on certain architectures, we
are potentially wasting kernel memory.

See http://sourceware.org/bugzilla/show_bug.cgi?id=10839#c3 for
more details.

Use a saner num_possible_cpus() instead of NR_CPUS for
allocation.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: fweisbec@gmail.com
LKML-Reference: <20091030135310.GA22230@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5240d75..1494e85 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1014,9 +1014,9 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * NR_CPUS);
+		rp->maxactive = max(10, 2 * num_possible_cpus());
 #else
-		rp->maxactive = NR_CPUS;
+		rp->maxactive = num_possible_cpus();
 #endif
 	}
 	spin_lock_init(&rp->lock);
