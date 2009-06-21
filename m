Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbZFUNKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbZFUNKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZFUNK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:10:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZFUNKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:10:25 -0400
Date: Sun, 21 Jun 2009 13:09:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       lucas.de.marchi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       lucas.de.marchi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Fix vmlinux fallback when running on a different kernel
Message-ID: <tip-c1f47b454ce759d7b13604137a233cad4617e1e8@git.kernel.org>
Git-Commit-ID: c1f47b454ce759d7b13604137a233cad4617e1e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 21 Jun 2009 13:09:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1f47b454ce759d7b13604137a233cad4617e1e8
Gitweb:     http://git.kernel.org/tip/c1f47b454ce759d7b13604137a233cad4617e1e8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 21 Jun 2009 13:58:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 21 Jun 2009 13:58:51 +0200

perf_counter tools: Fix vmlinux fallback when running on a different kernel

Lucas De Marchi reported that perf report and perf annotate
displays mismatching profile if a perf.data is analyzed on
an older kernel - even if the correct vmlinux is specified
via the -k option.

The reason is the fallback path in util/symbol.c:dso__load_kernel():

int dso__load_kernel(struct dso *self, const char *vmlinux,
                     symbol_filter_t filter, int verbose)
{
        int err = -1;

        if (vmlinux)
                err = dso__load_vmlinux(self, vmlinux, filter, verbose);

        if (err)
                err = dso__load_kallsyms(self, filter, verbose);

        return err;
}

dso__load_vmlinux() returns negative on error, but on success it
returns the number of symbols loaded - which confuses the function
to load the kallsyms.

This is normally harmless, as reporting is usually performed on the
same kernel that is analyzed - but if there's a mismatch then we
load the wrong kallsyms and create a non-sensical symbol tree.

The fix is to only fall back to kallsyms on errors.

Reported-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 86e1437..01b62fa 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -629,7 +629,7 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	if (vmlinux)
 		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
 
-	if (err)
+	if (err < 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
 	return err;
