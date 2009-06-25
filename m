Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZFYUVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZFYUVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFYUV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:21:29 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:34372 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZFYUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=jmKi3mfUh3NVlRSnK8ZbpX0KAHZQlOlw9kZpy72LN9QxLWK7JyqwrMdo1p5UWqt85y
         ne5XYguPaXU9OZnwmiGmUJwuK5s+/eIxOUNY4aXR7lerkSGTRvPFcyMRoMaVUn8xH1V8
         jdnHDeEMG57cbyqScAP7zROUtVo5LIgEqKn8E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounter: fix unhandled io return value
Date: Thu, 25 Jun 2009 22:21:27 +0200
Message-Id: <1245961287-5327-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building latest perfcounter fails on the following error:

cc1: warnings being treated as errors
builtin-record.c: In function ‘create_counter’:
builtin-record.c:451: erreur: ignoring return value of ‘read’, declared with attribute warn_unused_result
make: *** [builtin-record.o] Erreur 1

Just check if we successfully read the perf file descriptor.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-record.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 798a56d..d18546f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -448,7 +448,10 @@ try_again:
 		}
 	}
 
-	read(fd[nr_cpu][counter], &read_data, sizeof(read_data));
+	if (read(fd[nr_cpu][counter], &read_data, sizeof(read_data)) == -1) {
+		perror("Unable to read perf file descriptor\n");
+		exit(-1);
+	}
 
 	perf_header_attr__add_id(h_attr, read_data.id);
 
-- 
1.6.2.3

