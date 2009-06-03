Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZFCSfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZFCSfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFCSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:35:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:50435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZFCSf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:35:27 -0400
Date: Wed, 3 Jun 2009 18:33:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Refine capture printout
Message-ID: <tip-021e9f476511ebe23d7f45854a52dfe74c09b6ee@git.kernel.org>
Git-Commit-ID: 021e9f476511ebe23d7f45854a52dfe74c09b6ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 18:33:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  021e9f476511ebe23d7f45854a52dfe74c09b6ee
Gitweb:     http://git.kernel.org/tip/021e9f476511ebe23d7f45854a52dfe74c09b6ee
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 19:27:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 19:27:19 +0200

perf record: Refine capture printout

Print out the number of bytes captured, and the (estimated) number of
events the output file contains.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   34 +++++++++++++++++++--------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index fa62525..efa2eb4 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -67,6 +67,8 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 static long events;
 static struct timeval last_read, this_read;
 
+static __u64 bytes_written;
+
 static void mmap_read(struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
@@ -114,28 +116,34 @@ static void mmap_read(struct mmap_data *md)
 		buf = &data[old & md->mask];
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
+
 		while (size) {
 			int ret = write(output, buf, size);
-			if (ret < 0) {
-				perror("failed to write");
-				exit(-1);
-			}
+
+			if (ret < 0)
+				die("failed to write");
+
 			size -= ret;
 			buf += ret;
+
+			bytes_written += ret;
 		}
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
+
 	while (size) {
 		int ret = write(output, buf, size);
-		if (ret < 0) {
-			perror("failed to write");
-			exit(-1);
-		}
+
+		if (ret < 0)
+			die("failed to write");
+
 		size -= ret;
 		buf += ret;
+
+		bytes_written += ret;
 	}
 
 	md->prev = old;
@@ -467,8 +475,14 @@ static int __cmd_record(int argc, const char **argv)
 			ret = poll(event_array, nr_poll, 100);
 	}
 
-
-	fprintf(stderr, "[ perf record: Captured and wrote %ld events. ]\n", events);
+	/*
+	 * Approximate RIP event size: 24 bytes.
+	 */
+	fprintf(stderr,
+		"[ perf record: Captured and wrote %.3f MB %s (~%lld events) ]\n",
+		(double)bytes_written / 1024.0 / 1024.0,
+		output_name,
+		bytes_written / 24);
 
 	return 0;
 }
