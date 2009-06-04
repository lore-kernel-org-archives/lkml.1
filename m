Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZFDOwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZFDOwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZFDOwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:52:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:60515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbZFDOwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:52:20 -0400
Date: Thu, 4 Jun 2009 14:51:31 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Dont output in color on !tty
Message-ID: <tip-13d0ab5ec29852a6925f612830fa9e822669ece6@git.kernel.org>
Git-Commit-ID: 13d0ab5ec29852a6925f612830fa9e822669ece6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 14:51:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13d0ab5ec29852a6925f612830fa9e822669ece6
Gitweb:     http://git.kernel.org/tip/13d0ab5ec29852a6925f612830fa9e822669ece6
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 15:40:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 15:40:25 +0200

perf_counter tools: Dont output in color on !tty

Dont emit ASCII color characters if the terminal is not a tty,
such as when perf report gets redirected into a file.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/color.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/perf_counter/util/color.c b/Documentation/perf_counter/util/color.c
index a77975d..9a8c20c 100644
--- a/Documentation/perf_counter/util/color.c
+++ b/Documentation/perf_counter/util/color.c
@@ -1,7 +1,7 @@
 #include "cache.h"
 #include "color.h"
 
-int perf_use_color_default = 0;
+int perf_use_color_default = -1;
 
 static int parse_color(const char *name, int len)
 {
@@ -169,10 +169,20 @@ static int color_vfprintf(FILE *fp, const char *color, const char *fmt,
 {
 	int r = 0;
 
-	if (*color)
+	/*
+	 * Auto-detect:
+	 */
+	if (perf_use_color_default < 0) {
+		if (isatty(1) || pager_in_use())
+			perf_use_color_default = 1;
+		else
+			perf_use_color_default = 0;
+	}
+
+	if (perf_use_color_default && *color)
 		r += fprintf(fp, "%s", color);
 	r += vfprintf(fp, fmt, args);
-	if (*color)
+	if (perf_use_color_default && *color)
 		r += fprintf(fp, "%s", PERF_COLOR_RESET);
 	if (trail)
 		r += fprintf(fp, "%s", trail);
@@ -185,6 +195,7 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
 {
 	va_list args;
 	int r;
+
 	va_start(args, fmt);
 	r = color_vfprintf(fp, color, fmt, args, NULL);
 	va_end(args);
