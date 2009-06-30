Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZF3X3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZF3X3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbZF3X2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:28:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:60495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688AbZF3X2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:28:30 -0400
Date: Tue, 30 Jun 2009 23:28:11 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630230140.904782938@samba.org>
References: <20090630230140.904782938@samba.org>
Subject: [tip:perfcounters/urgent] perf top: Move skip symbols to an array
Message-ID: <tip-2ab52083ffc057014e502cf3473adc41436922fa@git.kernel.org>
Git-Commit-ID: 2ab52083ffc057014e502cf3473adc41436922fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:28:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ab52083ffc057014e502cf3473adc41436922fa
Gitweb:     http://git.kernel.org/tip/2ab52083ffc057014e502cf3473adc41436922fa
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 09:00:46 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 01:25:19 +0200

perf top: Move skip symbols to an array

Move the list of symbols we skip into an array, making it
easier to add new ones.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <20090630230140.904782938@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5c29655..731ec6d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -286,11 +286,22 @@ static void *display_thread(void *arg)
 	return NULL;
 }
 
+/* Tag samples to be skipped. */
+char *skip_symbols[] = {
+	"default_idle",
+	"cpu_idle",
+	"enter_idle",
+	"exit_idle",
+	"mwait_idle",
+	NULL
+};
+
 static int symbol_filter(struct dso *self, struct symbol *sym)
 {
 	static int filter_match;
 	struct sym_entry *syme;
 	const char *name = sym->name;
+	int i;
 
 	if (!strcmp(name, "_text") ||
 	    !strcmp(name, "_etext") ||
@@ -302,13 +313,12 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 		return 1;
 
 	syme = dso__sym_priv(self, sym);
-	/* Tag samples to be skipped. */
-	if (!strcmp("default_idle", name) ||
-	    !strcmp("cpu_idle", name) ||
-	    !strcmp("enter_idle", name) ||
-	    !strcmp("exit_idle", name) ||
-	    !strcmp("mwait_idle", name))
-		syme->skip = 1;
+	for (i = 0; skip_symbols[i]; i++) {
+		if (!strcmp(skip_symbols[i], name)) {
+			syme->skip = 1;
+			break;
+		}
+	}
 
 	if (filter_match == 1) {
 		filter_end = sym->start;
