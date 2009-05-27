Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbZE0Q2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbZE0Q2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbZE0Q2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:28:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZE0Q2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hklO5aokxzDH9msVJMzNMn+1FQZYU1etY4FfMb6QYXJ7xdpGPLliO1TNb8chWgn4m6
         GI6hE1BLeQwSRD8FIfISE7mWl20lYmWFGiY/MEPAOGGAqlPVPZfwd+ouz9elEU3r1mbh
         NA4KKjjM2k1OqXFd1orn38iWdPoS+I818fW5g=
Date: Wed, 27 May 2009 20:28:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090527162840.GA30529@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-18-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:55:12AM +0400, Alexey Dobriyan wrote:
> +static int task_struct_restorer(void *_tsk_ctx)
> +{
> +	struct task_struct_restore_context *tsk_ctx = _tsk_ctx;
> +	struct kstate_image_task_struct *i = tsk_ctx->i;
> +	struct kstate_context *ctx = tsk_ctx->ctx;
> +	/* In the name of symmetry. */
> +	struct task_struct *tsk = current, *real_parent;
> +	int rv;
> +
> +	pr_debug("%s: ENTER tsk %p/%s\n", __func__, tsk, tsk->comm);
> +
> +	write_lock_irq(&tasklist_lock);
> +	real_parent = ctx->init_tsk->nsproxy->pid_ns->child_reaper;
> +	tsk->real_parent = tsk->parent = real_parent;
> +	list_move_tail(&tsk->sibling, &tsk->real_parent->sibling);
							 ^^^^^^^
> +	write_unlock_irq(&tasklist_lock);

Eek, what a stupid bug here


commit 2c4b5f5d606a1892b702d95a0e4d29f207685381
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed May 27 20:21:59 2009 +0400

    C/R: fix stupid bug in reparenting
    
    Child process should be added to ->children list of course
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/kernel/kstate/kstate-task.c b/kernel/kstate/kstate-task.c
index 9ed5a19..6df7d25 100644
--- a/kernel/kstate/kstate-task.c
+++ b/kernel/kstate/kstate-task.c
@@ -490,7 +490,7 @@ static int task_struct_restorer(void *_tsk_ctx)
 		real_parent = tmp->o_obj;
 	}
 	tsk->real_parent = tsk->parent = real_parent;
-	list_move_tail(&tsk->sibling, &tsk->real_parent->sibling);
+	list_move_tail(&tsk->sibling, &tsk->real_parent->children);
 	write_unlock_irq(&tasklist_lock);
 
 	rv = restore_mm(ctx, &i->ref_mm);
