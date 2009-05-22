Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbZEVJUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbZEVJUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZEVJT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:19:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:34057 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZEVJT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XPaaNWbVYe0k92QbcuoAu5G8J1o6DW9uAqE37ZPI3C8Mdu/17Im8W496Of9h99Ybjl
         HJhRzyZ3sLfw4NuCTD1F7wJkCTmKZ9y16pTv48fSwdEDfgLAbq2E9mcdeiVDhTqSWjiB
         Kx2Sbto1EisR6ptaOgfMU+FiMgku/huh4snJE=
Date: Fri, 22 May 2009 17:20:25 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 07/38] pidns 1/2: make create_pid_namespace() accept
	parent pidns
Message-ID: <20090522092025.GD22601@cr0.nay.redhat.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-7-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-7-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:55:01AM +0400, Alexey Dobriyan wrote:
>create_pid_namespace() creates everything, but caller has to assign parent
>pidns by hand, which is unnatural. At the moment of call new ->level has
>to be taken from somewhere and parent pidns is already available.
>
>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Nice cleanup!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> kernel/pid_namespace.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>index 2d1001b..495d5de 100644
>--- a/kernel/pid_namespace.c
>+++ b/kernel/pid_namespace.c
>@@ -67,9 +67,10 @@ err_alloc:
> 	return NULL;
> }
> 
>-static struct pid_namespace *create_pid_namespace(unsigned int level)
>+static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
> {
> 	struct pid_namespace *ns;
>+	unsigned int level = parent_pid_ns->level + 1;
> 	int i;
> 
> 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
>@@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
> 
> 	kref_init(&ns->kref);
> 	ns->level = level;
>+	ns->parent = get_pid_ns(parent_pid_ns);
> 
> 	set_bit(0, ns->pidmap[0].page);
> 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
>@@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old
> 	if (flags & CLONE_THREAD)
> 		goto out_put;
> 
>-	new_ns = create_pid_namespace(old_ns->level + 1);
>-	if (!IS_ERR(new_ns))
>-		new_ns->parent = get_pid_ns(old_ns);
>+	new_ns = create_pid_namespace(old_ns);
> 
> out_put:
> 	put_pid_ns(old_ns);
>-- 
>1.5.6.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
