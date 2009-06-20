Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZFTABu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZFTABu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 20:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZFTABm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 20:01:42 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:44449 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZFTABl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 20:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=SoxnEhaAwZbZg1+gu44tqHiTxdtZJrSkeo8JjtQlbOERPiamPyw9Ge//aUt6mn2xF0
         UuBRbtS/qLsIQ1J43KFyEAVJgKvofjGnZ64Dq3jtUee+yKemEmZhU9AcK9MAUz4HQTZP
         y2L/DvE7Aw1S8371sqvzBw6lzrtyhZQdlnmtM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounter: handle some IO return values
Date: Sat, 20 Jun 2009 02:01:40 +0200
Message-Id: <1245456100-5477-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building perfcounter tools raises the following warnings
(treated as errors):

builtin-record.c: In function ‘atexit_header’:
builtin-record.c:464: erreur: ignoring return value of ‘pwrite’, declared with attribute warn_unused_result
builtin-record.c: In function ‘__cmd_record’:
builtin-record.c:503: erreur: ignoring return value of ‘read’, declared with attribute warn_unused_result

builtin-report.c: In function ‘__cmd_report’:
builtin-report.c:1403: erreur: ignoring return value of ‘read’, declared with attribute warn_unused_result

This patch handles these IO return values.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-record.c |    9 +++++++--
 tools/perf/builtin-report.c |    5 ++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e2cebc0..d7ebbd7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -461,7 +461,8 @@ static void atexit_header(void)
 {
 	file_header.data_size += bytes_written;
 
-	pwrite(output, &file_header, sizeof(file_header), 0);
+	if (pwrite(output, &file_header, sizeof(file_header), 0) == -1)
+		perror("failed to write on file headers");
 }
 
 static int __cmd_record(int argc, const char **argv)
@@ -500,7 +501,11 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!file_new) {
-		read(output, &file_header, sizeof(file_header));
+		if (read(output, &file_header, sizeof(file_header)) == -1) {
+			perror("failed to read file headers");
+			exit(-1);
+		}
+
 		lseek(output, file_header.data_size, SEEK_CUR);
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index de1b978..5eb5566 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1400,7 +1400,10 @@ static int __cmd_report(void)
 		exit(0);
 	}
 
-	read(input, &file_header, sizeof(file_header));
+	if (read(input, &file_header, sizeof(file_header)) == -1) {
+		perror("failed to read file headers");
+		exit(-1);
+	}
 
 	if (sort__has_parent &&
 	    !(file_header.sample_type & PERF_SAMPLE_CALLCHAIN)) {
-- 
1.6.2.3

