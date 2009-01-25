Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZAYGBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZAYGBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 01:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZAYGBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 01:01:14 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:6517 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZAYGBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 01:01:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N3XkUNU2MVr7+7MPSRbFGJc/yGJLbTyXIAq6DFAakxTTMazFaqt7wWrFMJcIKq7XTK
         JkSM6pE+E25E9ErUy34HveCXOoODC5DOkO9BkVwWk7g53g+eLAxmjDJHUdn/DsoOKZ4a
         kbtQLiwdAzuXOxreaN9LPbVlc5bue41wUqC90=
MIME-Version: 1.0
In-Reply-To: <32272.1232853509@turing-police.cc.vt.edu>
References: <b9df5fa10901231150i1b9ea0f4n14d1cf60a9296a78@mail.gmail.com>
	 <32272.1232853509@turing-police.cc.vt.edu>
Date: Sun, 25 Jan 2009 12:01:12 +0600
Message-ID: <b9df5fa10901242201h75f40e40ic27dfb089dd90fc8@mail.gmail.com>
Subject: Re: [PATCH] audit: Fix compile time warning on kernel/auditsc.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/09, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
>
> Blech.  That's abuse of inline.  Can you find some other, more kernel-y
>  way to address the issue?  (Possibly make it an actual inline up in a .h
>  file, with a #ifdef wrapping around it, or do something matching what's
>  done at the call site (apparently #ifdef'ing code is accepted in that .c
>  file, adding another #ifdef around that function to match all the *other*
>  '#ifdef CONFIG_AUDIT_TREE' would be less ugly than 'inline'.

Hi, Valdis. Thanks for your suggestions. Actually without inline-ing
the warning doesn't resolves. So, as you said I moved
audit_set_auditable function into kernel/audit.h, but not #ifdef
wrapping around it rather #ifdef into it. Since wrapping #ifdef
generates same warning few times more. Here is the patch. If I miss
anything, then please notice.

-----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/audit.h	2009-01-23 18:28:45.000000000 +0600
+++ linux-2.6/kernel/audit.h	2009-01-25 11:50:22.520217272 +0600
@@ -121,6 +121,16 @@ extern struct mutex audit_filter_mutex;
 extern void audit_free_rule_rcu(struct rcu_head *);
 extern struct list_head audit_filter_list[];

+static inline void audit_set_auditable(struct audit_context *ctx)
+{
+#ifdef CONFIG_AUDIT_TREE
+	if (!ctx->prio) {
+		ctx->prio = 1;
+		ctx->current_state = AUDIT_RECORD_CONTEXT;
+	}
+#endif
+}
+
 #ifdef CONFIG_AUDIT_TREE
 extern struct audit_chunk *audit_tree_lookup(const struct inode *);
 extern void audit_put_chunk(struct audit_chunk *);

------
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/auditsc.c	2009-01-23 18:28:45.000000000 +0600
+++ linux-2.6/kernel/auditsc.c	2009-01-25 11:50:25.712731936 +0600
@@ -741,14 +741,6 @@ void audit_filter_inodes(struct task_str
 	rcu_read_unlock();
 }

-static void audit_set_auditable(struct audit_context *ctx)
-{
-	if (!ctx->prio) {
-		ctx->prio = 1;
-		ctx->current_state = AUDIT_RECORD_CONTEXT;
-	}
-}
-
 static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 						      int return_valid,
 						      int return_code)
