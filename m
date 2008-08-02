Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYHBCVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYHBCVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYHBCVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:21:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58969 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYHBCVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:21:37 -0400
Message-ID: <4893C42A.60803@cn.fujitsu.com>
Date: Sat, 02 Aug 2008 10:19:22 +0800
From: zhangxiliang <zhangxiliang@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       viro@zeniv.linux.org.uk, Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the kernel panic of audit_filter_task when key field
 is set
References: <4892F063.1080109@cn.fujitsu.com>
In-Reply-To: <4892F063.1080109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Fix the kernel panic of audit_filter_task when AUDIT_PERM or AUDIT_FILETYPE field is set

When calling audit_filter_task(), it calls audit_filter_rules() with audit_context is NULL.
If the AUDIT_PERM or AUDIT_FILETYPE field is set, audit_match_perm() or audit_match_filetype() will use ctx->xx.
But the ctx is NULL in this condition, so kernel will panic.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 kernel/auditsc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 012c94e..29b6964 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -243,6 +243,8 @@ static inline int open_arg(int flags, int mask)
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
+	if(!ctx)
+		return 0;
 	unsigned n = ctx->major;
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
@@ -284,6 +286,8 @@ static int audit_match_filetype(struct audit_context *ctx, int which)
 {
 	unsigned index = which & ~S_IFMT;
 	mode_t mode = which & S_IFMT;
+	if(!ctx)
+		return 0;
 	if (index >= ctx->name_count)
 		return 0;
 	if (ctx->names[index].ino == -1)


zhangxiliang said the following on 2008-08-01 19:15:
> When calling audit_filter_task(), it calls audit_filter_rules() with audit_context is NULL.
> If the key field is set, the result in audit_filter_rules() will be set to 1 and 
> ctx->filterkey will be set to key.
> But the ctx is NULL in this condition, so kernel will panic.
> 
> Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
> ---
>  kernel/auditsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 4699950..012c94e 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -610,7 +610,7 @@ static int audit_filter_rules(struct task_struct *tsk,
>  		if (!result)
>  			return 0;
>  	}
> -	if (rule->filterkey)
> +	if (rule->filterkey && ctx)
>  		ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
>  	switch (rule->action) {
>  	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit
> 
> 
> 

