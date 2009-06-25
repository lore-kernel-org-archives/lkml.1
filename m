Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZFYKLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZFYKLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFYKK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:10:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFYKKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:10:55 -0400
Date: Thu, 25 Jun 2009 10:09:54 GMT
From: tip-bot for Johannes Weiner <hannes@cmpxchg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stefani@seibold.net, a.p.zijlstra@chello.nl, hannes@cmpxchg.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu, adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stefani@seibold.net, a.p.zijlstra@chello.nl, hannes@cmpxchg.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de,
       adobriyan@gmail.com, mingo@elte.hu
In-Reply-To: <20090624190835.GA25548@cmpxchg.org>
References: <20090624190835.GA25548@cmpxchg.org>
Subject: [tip:perfcounters/urgent] perf record: Fix filemap pathname parsing in /proc/pid/maps
Message-ID: <tip-76c64c5e4c47b6d28deb3cae8dfa07a93c2229dc@git.kernel.org>
Git-Commit-ID: 76c64c5e4c47b6d28deb3cae8dfa07a93c2229dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 10:09:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76c64c5e4c47b6d28deb3cae8dfa07a93c2229dc
Gitweb:     http://git.kernel.org/tip/76c64c5e4c47b6d28deb3cae8dfa07a93c2229dc
Author:     Johannes Weiner <hannes@cmpxchg.org>
AuthorDate: Wed, 24 Jun 2009 21:08:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 11:35:58 +0200

perf record: Fix filemap pathname parsing in /proc/pid/maps

Looking backward for the first space from the end of a line in
/proc/pid/maps does not find the start of the pathname of the mapped
file if it contains a space.

Since the only slashes we have in this file occur in the (absolute!)
pathname column of file mappings, looking for the first slash in a
line is a safe method to find the name.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090624190835.GA25548@cmpxchg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d7ebbd7..9b899ba 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -306,12 +306,11 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
-			char *execname = strrchr(bf, ' ');
+			char *execname = strchr(bf, '/');
 
-			if (execname == NULL || execname[1] != '/')
+			if (execname == NULL)
 				continue;
 
-			execname += 1;
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(mmap_ev.filename, execname, size);
