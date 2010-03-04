Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0CDQcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:32:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:48451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab0CDQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:32:11 -0500
Date: Thu, 4 Mar 2010 16:31:29 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mathieu.desnoyers@efficios.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@efficios.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100304033850.3819.74590.stgit@localhost6.localdomain6>
References: <20100304033850.3819.74590.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] x86: Issue at least one memory barrier in stop_machine_text_poke()
Message-ID: <tip-e5a11016643d1ab7172193591506d33a844734cc@git.kernel.org>
Git-Commit-ID: e5a11016643d1ab7172193591506d33a844734cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:31:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5a11016643d1ab7172193591506d33a844734cc
Gitweb:     http://git.kernel.org/tip/e5a11016643d1ab7172193591506d33a844734cc
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 3 Mar 2010 22:38:50 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 11:39:21 +0100

x86: Issue at least one memory barrier in stop_machine_text_poke()

Fix stop_machine_text_poke() to issue smp_mb() before exiting
waiting loop, and use cpu_relax() for waiting.

Changes in v2:
 - Don't use ACCESS_ONCE().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <20100304033850.3819.74590.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c41f13c..e0b8770 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -595,8 +595,8 @@ static int __kprobes stop_machine_text_poke(void *data)
 		wrote_text = 1;
 	} else {
 		while (!wrote_text)
-			smp_rmb();
-		sync_core();
+			cpu_relax();
+		smp_mb();	/* Load wrote_text before following execution */
 	}
 
 	flush_icache_range((unsigned long)tpp->addr,
