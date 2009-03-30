Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbZC3VeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbZC3VeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZC3VeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:34:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873AbZC3VeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:34:03 -0400
Date: Mon, 30 Mar 2009 14:32:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: linux-kernel@vger.kernel.org, dmitri.vorobiev@movial.com
Subject: Re: [PATCH 3/3] Restrict definition of a static function in
 kernel/auditsc.c
Message-Id: <20090330143239.cfc76a54.akpm@linux-foundation.org>
In-Reply-To: <1237412967-20754-3-git-send-email-dmitri.vorobiev@movial.com>
References: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
	<1237412967-20754-2-git-send-email-dmitri.vorobiev@movial.com>
	<1237412967-20754-3-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 23:49:27 +0200
Dmitri Vorobiev <dmitri.vorobiev@movial.com> wrote:

> The function 'audit_set_auditable' in kernel/auditsc.c is called
> only when the CONFIG_AUDIT_TREE option is set. Therefore, the
> following warning may be produced:
> 
> kernel/auditsc.c:745: warning: 'audit_set_auditable' defined but not used
> 
> This patch fixes the warning by moving the function definition under an
> appropriate preprocessor construct.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
> ---
>  kernel/auditsc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 8cbddff..bac40d0 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -741,6 +741,7 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
>  	rcu_read_unlock();
>  }
>  
> +#ifdef CONFIG_AUDIT_TREE
>  static void audit_set_auditable(struct audit_context *ctx)
>  {
>  	if (!ctx->prio) {
> @@ -748,6 +749,7 @@ static void audit_set_auditable(struct audit_context *ctx)
>  		ctx->current_state = AUDIT_RECORD_CONTEXT;
>  	}
>  }
> +#endif
>  
>  static inline struct audit_context *audit_get_context(struct task_struct *tsk,
>  						      int return_valid,

I already fixed this with the (IMO superior) patch below.

The patch was sent to the audit maintainers on Feb 11 and was resent on
March 4 and was both times ignored, along with the other two audit
patches I sent.

Bugger it, I'm fed up with this.  I'll merge them myself.



From: Andrew Morton <akpm@linux-foundation.org>

kernel/auditsc.c:745: warning: 'audit_set_auditable' defined but not used

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/auditsc.c~kernel-auditscc-fix-warning kernel/auditsc.c
--- a/kernel/auditsc.c~kernel-auditscc-fix-warning
+++ a/kernel/auditsc.c
@@ -364,6 +364,15 @@ static int grow_tree_refs(struct audit_c
 	ctx->tree_count = 31;
 	return 1;
 }
+
+static void audit_set_auditable(struct audit_context *ctx)
+{
+	if (!ctx->prio) {
+		ctx->prio = 1;
+		ctx->current_state = AUDIT_RECORD_CONTEXT;
+	}
+}
+
 #endif
 
 static void unroll_tree_refs(struct audit_context *ctx,
@@ -741,14 +750,6 @@ void audit_filter_inodes(struct task_str
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
_

