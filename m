Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0CCVVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:21:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab0CCVU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:20:58 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] x86: Issue at least one memory barrier in
	stop_machine_text_poke().
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>
Date: Wed, 03 Mar 2010 16:27:04 -0500
Message-ID: <20100303212703.25645.50986.stgit@localhost6.localdomain6>
In-Reply-To: <20100303212656.25645.48466.stgit@localhost6.localdomain6>
References: <20100303212656.25645.48466.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix stop_machine_text_poke() to issue smp_mb() before exiting waiting
loop. Also, use ACCESS_ONCE() to check a flag according to Mathieu's
comment.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
---

 arch/x86/kernel/alternative.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 635e4f4..3236a11 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -596,9 +596,9 @@ static int __kprobes stop_machine_text_poke(void *data)
 		smp_wmb();	/* Make sure other cpus see that this has run */
 		wrote_text = 1;
 	} else {
-		while (!wrote_text)
-			smp_rmb();
-		sync_core();
+		while (!ACCESS_ONCE(wrote_text))
+			cpu_relax();
+		smp_mb();	/* Load wrote_text before following execution */
 	}
 
 	flush_icache_range((unsigned long)tpp->addr,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
