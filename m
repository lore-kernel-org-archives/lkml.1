Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZEEJb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZEEJb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZEEJbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:31:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53494 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZEEJbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:31:50 -0400
Date: Tue, 5 May 2009 11:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090505093134.GA7014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Steven Rostedt (1):
      tracing: fix ref count in splice pages

Stuart Bennett (1):
      tracing: x86, mmiotrace: fix range test


 arch/x86/mm/kmmio.c  |    2 +-
 kernel/trace/trace.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 4f115e0..50dc802 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -87,7 +87,7 @@ static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
 {
 	struct kmmio_probe *p;
 	list_for_each_entry_rcu(p, &kmmio_probes, list) {
-		if (addr >= p->addr && addr <= (p->addr + p->len))
+		if (addr >= p->addr && addr < (p->addr + p->len))
 			return p;
 	}
 	return NULL;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1ce5dc6..a884c09 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3448,6 +3448,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		if (!ref)
 			break;
 
+		ref->ref = 1;
 		ref->buffer = info->tr->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer);
 		if (!ref->page) {
