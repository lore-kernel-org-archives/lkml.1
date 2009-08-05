Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZHEXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZHEXd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZHEXd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:33:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbZHEXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:33:55 -0400
Date: Wed, 5 Aug 2009 16:33:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] oom: fix oom_adjust_write() input sanity check.
Message-Id: <20090805163325.14a4a77f.akpm@linux-foundation.org>
In-Reply-To: <20090804192721.6A49.A69D9226@jp.fujitsu.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
	<20090804192721.6A49.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Aug 2009 19:28:03 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] oom: fix oom_adjust_write() input sanity check.
> 
> Andrew Morton pointed out oom_adjust_write() has very strange EIO
> and new line handling. this patch fixes it.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Paul Menage <menage@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>,
> Cc: Andrew Morton <akpm@linux-foundation.org>,
> ---
>  fs/proc/base.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> Index: b/fs/proc/base.c
> ===================================================================
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1033,12 +1033,15 @@ static ssize_t oom_adjust_write(struct f
>  		count = sizeof(buffer) - 1;
>  	if (copy_from_user(buffer, buf, count))
>  		return -EFAULT;
> +
> +	strstrip(buffer);

+1 for using strstrip()

-1 for using it wrongly.  If it strips leading whitespace it will
return a new address for the caller to use.

We could mark it __must_check() to prevent reoccurences of this error.

How does this look?

--- a/fs/proc/base.c~oom-fix-oom_adjust_write-input-sanity-check-fix
+++ a/fs/proc/base.c
@@ -1033,8 +1033,7 @@ static ssize_t oom_adjust_write(struct f
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
 
-	strstrip(buffer);
-	oom_adjust = simple_strtol(buffer, &end, 0);
+	oom_adjust = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&


>  	oom_adjust = simple_strtol(buffer, &end, 0);

That should've used strict_strtoul() but it's too late to fix it now.

> +	if (*end)
> +		return -EINVAL;
>  	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
>  	     oom_adjust != OOM_DISABLE)
>  		return -EINVAL;
> -	if (*end == '\n')
> -		end++;
> +
>  	task = get_proc_task(file->f_path.dentry->d_inode);
>  	if (!task)
>  		return -ESRCH;
> @@ -1057,9 +1060,8 @@ static ssize_t oom_adjust_write(struct f
>  	task->signal->oom_adj = oom_adjust;
>  	unlock_task_sighand(task, &flags);
>  	put_task_struct(task);
> -	if (end - buffer == 0)
> -		return -EIO;
> -	return end - buffer;
> +
> +	return count;
>  }
>  
>  static const struct file_operations proc_oom_adjust_operations = {
> 
