Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZCMJec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZCMJec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZCMJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:34:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:47660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZCMJeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:34:21 -0400
Date: Fri, 13 Mar 2009 09:33:29 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49BA23D9.1050900@cn.fujitsu.com>
References: <49BA23D9.1050900@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] ftrace: avoid double-free of dyn_ftrace
Message-ID: <tip-b00f0b6dc1773b4c8f538503247da050b5ea631b@git.kernel.org>
Git-Commit-ID: b00f0b6dc1773b4c8f538503247da050b5ea631b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 09:33:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b00f0b6dc1773b4c8f538503247da050b5ea631b
Gitweb:     http://git.kernel.org/tip/b00f0b6dc1773b4c8f538503247da050b5ea631b
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 13 Mar 2009 17:14:01 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 10:25:06 +0100

ftrace: avoid double-free of dyn_ftrace

If dyn_ftrace is freed before ftrace_release(), ftrace_release()
will free it again and make ftrace_free_records wrong.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "Steven Rostedt ;" <rostedt@goodmis.org>
LKML-Reference: <49BA23D9.1050900@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d33d306..26c45aa 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -356,7 +356,8 @@ void ftrace_release(void *start, unsigned long size)
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e))
+		if ((rec->ip >= s) && (rec->ip < e) &&
+		    !(rec->flags & FTRACE_FL_FREE))
 			ftrace_free_rec(rec);
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
