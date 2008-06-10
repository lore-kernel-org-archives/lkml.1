Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYFJW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYFJW5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYFJW5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:57:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYFJW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:57:30 -0400
Message-ID: <484F0343.70105@redhat.com>
Date: Tue, 10 Jun 2008 18:42:11 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH][BUGFIX] kprobes: fix error checking of batch registration
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error checking routine to catch an error which occurs in
first __register_*porbe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: David Miller <davem@davemloft.net>
---
I found this bug when fixing batch-registration test program.
This patch can be apply to both of 2.6.26-rc2-mm1 and 2.6.26-rc5.

 kernel/kprobes.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: 2.6.26-rc2-mm1/kernel/kprobes.c
===================================================================
--- 2.6.26-rc2-mm1.orig/kernel/kprobes.c
+++ 2.6.26-rc2-mm1/kernel/kprobes.c
@@ -699,8 +699,9 @@ static int __register_kprobes(struct kpr
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
 		ret = __register_kprobe(kps[i], called_from);
-		if (ret < 0 && i > 0) {
-			unregister_kprobes(kps, i);
+		if (ret < 0) {
+			if (i > 0)
+				unregister_kprobes(kps, i);
 			break;
 		}
 	}
@@ -776,8 +777,9 @@ static int __register_jprobes(struct jpr
 			jp->kp.break_handler = longjmp_break_handler;
 			ret = __register_kprobe(&jp->kp, called_from);
 		}
-		if (ret < 0 && i > 0) {
-			unregister_jprobes(jps, i);
+		if (ret < 0) {
+			if (i > 0)
+				unregister_jprobes(jps, i);
 			break;
 		}
 	}
@@ -920,8 +922,9 @@ static int __register_kretprobes(struct
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
 		ret = __register_kretprobe(rps[i], called_from);
-		if (ret < 0 && i > 0) {
-			unregister_kretprobes(rps, i);
+		if (ret < 0) {
+			if (i > 0)
+				unregister_kretprobes(rps, i);
 			break;
 		}
 	}
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


