Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZEVJOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZEVJOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZEVJOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:14:24 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:63929 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZEVJOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U2Sbmqbf4yDPb+cV/Kg6FiqXhU4tvN1a28ZBhojZMKIuP4FXX8MOuBMe3pRVfYPLhu
         hsk7zHwa2vj4f1K0m/ipDthN/N3EfxAoOz8rDp8Lo/mQ43UZf+SnJ88l+JRkLXgvpwaP
         KlXFhJrg8As9FFbnbVHuYpUD432T5l+zvNO0k=
Date: Fri, 22 May 2009 17:14:51 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 08/38] pidns 2/2: rewrite copy_pid_ns()
Message-ID: <20090522091451.GC22601@cr0.nay.redhat.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-8-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:55:02AM +0400, Alexey Dobriyan wrote:
>copy_pid_ns() is a perfect example of a case where unwinding leads to more
>code and makes it less clear. Watch the diffstat.
>

Fully agreed...

>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Btw, which tree is this patch against? Looks like not linus-tree.


>---
> kernel/pid_namespace.c |   18 +++---------------
> 1 files changed, 3 insertions(+), 15 deletions(-)
>
>diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>index 495d5de..821722a 100644
>--- a/kernel/pid_namespace.c
>+++ b/kernel/pid_namespace.c
>@@ -116,23 +116,11 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
> 
> struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
> {
>-	struct pid_namespace *new_ns;
>-
>-	BUG_ON(!old_ns);
>-	new_ns = get_pid_ns(old_ns);
> 	if (!(flags & CLONE_NEWPID))
>-		goto out;
>-
>-	new_ns = ERR_PTR(-EINVAL);
>+		return get_pid_ns(old_ns);
> 	if (flags & CLONE_THREAD)
>-		goto out_put;
>-
>-	new_ns = create_pid_namespace(old_ns);
>-
>-out_put:
>-	put_pid_ns(old_ns);
>-out:
>-	return new_ns;
>+		return ERR_PTR(-EINVAL);
>+	return create_pid_namespace(old_ns);
> }
> 
> void free_pid_ns(struct kref *kref)
>-- 
>1.5.6.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
