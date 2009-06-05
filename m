Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZFENXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZFENXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZFENWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:22:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:59072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZFENWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:22:36 -0400
Date: Fri, 5 Jun 2009 13:22:07 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Display user/kernel differentiator
Message-ID: <tip-8edd4286f99f78fe07fe9196e69d5643da86cada@git.kernel.org>
Git-Commit-ID: 8edd4286f99f78fe07fe9196e69d5643da86cada
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 13:22:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8edd4286f99f78fe07fe9196e69d5643da86cada
Gitweb:     http://git.kernel.org/tip/8edd4286f99f78fe07fe9196e69d5643da86cada
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 5 Jun 2009 14:13:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 14:13:18 +0200

perf report: Display user/kernel differentiator

Before:

    25.96%  copy_user_generic_string
    15.23%  two_op
    15.19%  one_op
     6.92%  enough_duration
     1.23%  alloc_pages_current
     1.14%  acpi_os_read_port
     1.08%  _spin_lock

After:

    25.96%  [k] copy_user_generic_string
    15.23%  [.] two_op
    15.19%  [.] one_op
     6.92%  [.] enough_duration
     1.23%  [k] alloc_pages_current
     1.14%  [k] acpi_os_read_port
     1.08%  [k] _spin_lock

The '[k]' differentiator is a quick clue that it's a kernel symbol,
without having to bring in the full dso column.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 9783d1e..ca303fd 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -504,7 +504,7 @@ sort__comm_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_comm = {
-	.header 	= "         Command",
+	.header		= "         Command",
 	.cmp		= sort__comm_cmp,
 	.collapse	= sort__comm_collapse,
 	.print		= sort__comm_print,
@@ -569,10 +569,12 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	if (verbose)
 		ret += fprintf(fp, "%#018llx  ", (__u64)self->ip);
 
-	if (self->sym)
-		ret += fprintf(fp, "%s", self->sym->name);
-	else
+	if (self->sym) {
+		ret += fprintf(fp, "[%c] %s",
+			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
+	} else {
 		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
+	}
 
 	return ret;
 }
@@ -586,9 +588,9 @@ static struct sort_entry sort_sym = {
 static int sort__need_collapse = 0;
 
 struct sort_dimension {
-	char *name;
-	struct sort_entry *entry;
-	int taken;
+	char			*name;
+	struct sort_entry	*entry;
+	int			taken;
 };
 
 static struct sort_dimension sort_dimensions[] = {
