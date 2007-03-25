Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXCYJHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXCYJHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 05:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXCYJHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 05:07:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbXCYJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 05:07:15 -0400
Date: Sun, 25 Mar 2007 01:07:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utsns: fix !CONFIG_UTS_NS behavior
Message-Id: <20070325010709.5d801f1c.akpm@linux-foundation.org>
In-Reply-To: <20070323200039.GA15775@sergelap.austin.ibm.com>
References: <20070323200039.GA15775@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 15:00:39 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> When CONFIG_UTS_NS=n, clone(CLONE_NEWUTS) quietly refuses.  So correctly does
> not unshare a new uts namespace, but also does not return -EINVAL.
> 
> Fix this to return -EINVAL so the caller knows his request was denied.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> 
> ---
> 
>  include/linux/utsname.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> bc350994ac67df8f1b917f9979c065d87757eabe
> diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> index a4555fe..e10267d 100644
> --- a/include/linux/utsname.h
> +++ b/include/linux/utsname.h
> @@ -70,6 +70,8 @@ static inline int unshare_utsname(unsign
>  
>  static inline int copy_utsname(int flags, struct task_struct *tsk)
>  {
> +	if (flags & CLONE_NEWUTS)
> +		return -EINVAL;
>  	return 0;
>  }
>  static inline void put_uts_ns(struct uts_namespace *ns)

I'm assuming that this is 2.6.21 material.

Please review -mm's merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
- it probably needs to propagate this fix.

