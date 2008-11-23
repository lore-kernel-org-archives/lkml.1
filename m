Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYKWLI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYKWLI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYKWLIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:08:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:7666 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbYKWLIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B66XPRRIFCEUaTc3KwWc5Z/mJlNZopDCpkiPcq+gAwaDcBXKMF22UZ90NqV/cZmORu
         8WWks5YLUQ+6vMznlyToyLcfhjKslr/fx0wWuRD107rOck37LuRIyOlUu96xxk31eiPz
         5pZjt0pm17Glv4ePthbxfIMRg3LIuSFS0hZ24=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] tracing/stack-tracer: avoid races accessing file
Date: Sun, 23 Nov 2008 13:08:10 +0200
Message-Id: <1227438490-23259-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081123110714.GE30453@elte.hu>
References: <20081123110714.GE30453@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 kernel/trace/trace.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4c3bd82..48d1536 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1470,13 +1470,13 @@ static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 			file = vma->vm_file;
 			vmstart = vma->vm_start;
 		}
+		if (file) {
+			ret = trace_seq_path(s, &file->f_path);
+			if (ret)
+				ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
+		}
 		up_read(&mm->mmap_sem);
 	}
-	if (file) {
-		ret = trace_seq_path(s, &file->f_path);
-		if (ret)
-			ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
-	}
 	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
 		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
 	return ret;
-- 
1.5.6.5

