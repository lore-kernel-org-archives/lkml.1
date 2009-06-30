Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbZF3X3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbZF3X3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbZF3X3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:29:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbZF3X3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:29:05 -0400
Date: Tue, 30 Jun 2009 23:28:49 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630230141.182536873@samba.org>
References: <20090630230141.182536873@samba.org>
Subject: [tip:perfcounters/urgent] perf report: Add hypervisor dso
Message-ID: <tip-fb9c818873a788c5c01c9868cc6050df96e2c7df@git.kernel.org>
Git-Commit-ID: fb9c818873a788c5c01c9868cc6050df96e2c7df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:28:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb9c818873a788c5c01c9868cc6050df96e2c7df
Gitweb:     http://git.kernel.org/tip/fb9c818873a788c5c01c9868cc6050df96e2c7df
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 09:00:49 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 01:25:20 +0200

perf report: Add hypervisor dso

Add a dso for hypervisor samples. We don't get any symbol
information on the ppc64 hypervisor but this at least gives
us a high level summary of the time spent in there.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <20090630230141.182536873@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 88e88c5..3f5d8ea 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -121,6 +121,7 @@ typedef union event_union {
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 static struct dso *vdso;
+static struct dso *hypervisor_dso;
 
 static void dsos__add(struct dso *dso)
 {
@@ -202,6 +203,11 @@ static int load_kernel(void)
 
 	dsos__add(vdso);
 
+	hypervisor_dso = dso__new("[hypervisor]", 0);
+	if (!hypervisor_dso)
+		return -1;
+	dsos__add(hypervisor_dso);
+
 	return err;
 }
 
@@ -640,7 +646,8 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
-			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
+			self->dso == kernel_dso ? 'k' :
+			self->dso == hypervisor_dso ? 'h' : '.', self->sym->name);
 	} else {
 		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
@@ -963,6 +970,9 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 			}
 
 			switch (context) {
+			case PERF_CONTEXT_HV:
+				dso = hypervisor_dso;
+				break;
 			case PERF_CONTEXT_KERNEL:
 				dso = kernel_dso;
 				break;
@@ -1275,6 +1285,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	} else {
 		show = SHOW_HV;
 		level = 'H';
+
+		dso = hypervisor_dso;
+
 		dprintf(" ...... dso: [hypervisor]\n");
 	}
 
