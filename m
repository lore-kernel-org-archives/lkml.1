Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZJ3ABo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZJ3ABo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZJ3ABo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZJ3ABn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:01:43 -0400
Date: Fri, 30 Oct 2009 00:56:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: cleanup ptrace_init_task()->ptrace_link() path
Message-ID: <20091029235656.GA26438@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

ptrace_init_task() looks confusing, as if we always auto-attach when
"bool ptrace" argument is true, while in fact we attach only if current
is traced.

Make the code more explicit and kill now unused ptrace_link().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 include/linux/ptrace.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- V1/include/linux/ptrace.h~1_PTRACE_INIT_TASK	2009-10-30 00:44:22.000000000 +0100
+++ V1/include/linux/ptrace.h	2009-10-30 00:46:06.000000000 +0100
@@ -105,12 +105,7 @@ static inline int ptrace_reparented(stru
 {
 	return child->real_parent != child->parent;
 }
-static inline void ptrace_link(struct task_struct *child,
-			       struct task_struct *new_parent)
-{
-	if (unlikely(child->ptrace))
-		__ptrace_link(child, new_parent);
-}
+
 static inline void ptrace_unlink(struct task_struct *child)
 {
 	if (unlikely(child->ptrace))
@@ -169,9 +164,9 @@ static inline void ptrace_init_task(stru
 	INIT_LIST_HEAD(&child->ptraced);
 	child->parent = child->real_parent;
 	child->ptrace = 0;
-	if (unlikely(ptrace)) {
+	if (unlikely(ptrace) && (current->ptrace & PT_PTRACED)) {
 		child->ptrace = current->ptrace;
-		ptrace_link(child, current->parent);
+		__ptrace_link(child, current->parent);
 	}
 }
 

