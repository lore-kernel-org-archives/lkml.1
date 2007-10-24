Return-Path: <linux-kernel-owner+w=401wt.eu-S1765126AbXJXQvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765126AbXJXQvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbXJXQae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:30:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24761 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368AbXJXQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:30:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XtCJ90tIDICLQiTlTESuxpXf3eJpvh2S5fZNkIlzM3hXRHT8ILjsFXf+1/vBPelqP
	hb7k8dZIGQTEwNiMsyeGA==
Message-ID: <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
Date: Wed, 24 Oct 2007 09:30:23 -0700
From: "Paul Menage" <menage@google.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] kernel/cgroup.c: remove dead code
Cc: "Paul Jackson" <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162534.GZ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162534.GZ30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think I'd rather not make this change - if we later changed the size
of release_agent_path[] this could silently fail. Can we get around
the coverity checker somehow?

Paul

On 10/24/07, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes dead code spotted by the Coverity checker
> (look at the "(nbytes >= PATH_MAX)" check).
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  kernel/cgroup.c |   18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> --- linux-2.6/kernel/cgroup.c.old       2007-10-23 18:37:43.000000000 +0200
> +++ linux-2.6/kernel/cgroup.c   2007-10-23 18:39:15.000000000 +0200
> @@ -1320,90 +1320,88 @@ static ssize_t cgroup_common_file_write(
>
>         if (nbytes >= PATH_MAX)
>                 return -E2BIG;
>
>         /* +1 for nul-terminator */
>         buffer = kmalloc(nbytes + 1, GFP_KERNEL);
>         if (buffer == NULL)
>                 return -ENOMEM;
>
>         if (copy_from_user(buffer, userbuf, nbytes)) {
>                 retval = -EFAULT;
>                 goto out1;
>         }
>         buffer[nbytes] = 0;     /* nul-terminate */
>
>         mutex_lock(&cgroup_mutex);
>
>         if (cgroup_is_removed(cgrp)) {
>                 retval = -ENODEV;
>                 goto out2;
>         }
>
>         switch (type) {
>         case FILE_TASKLIST:
>                 retval = attach_task_by_pid(cgrp, buffer);
>                 break;
>         case FILE_NOTIFY_ON_RELEASE:
>                 clear_bit(CGRP_RELEASABLE, &cgrp->flags);
>                 if (simple_strtoul(buffer, NULL, 10) != 0)
>                         set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>                 else
>                         clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>                 break;
>         case FILE_RELEASE_AGENT:
>         {
>                 struct cgroupfs_root *root = cgrp->root;
>                 /* Strip trailing newline */
>                 if (nbytes && (buffer[nbytes-1] == '\n')) {
>                         buffer[nbytes-1] = 0;
>                 }
> -               if (nbytes < sizeof(root->release_agent_path)) {
> -                       /* We never write anything other than '\0'
> -                        * into the last char of release_agent_path,
> -                        * so it always remains a NUL-terminated
> -                        * string */
> -                       strncpy(root->release_agent_path, buffer, nbytes);
> -                       root->release_agent_path[nbytes] = 0;
> -               } else {
> -                       retval = -ENOSPC;
> -               }
> +
> +               /* We never write anything other than '\0'
> +                * into the last char of release_agent_path,
> +                * so it always remains a NUL-terminated
> +                * string */
> +               strncpy(root->release_agent_path, buffer, nbytes);
> +               root->release_agent_path[nbytes] = 0;
> +
>                 break;
>         }
>         default:
>                 retval = -EINVAL;
>                 goto out2;
>         }
>
>         if (retval == 0)
>                 retval = nbytes;
>  out2:
>         mutex_unlock(&cgroup_mutex);
>  out1:
>         kfree(buffer);
>         return retval;
>  }
>
>  static ssize_t cgroup_file_write(struct file *file, const char __user *buf,
>                                                 size_t nbytes, loff_t *ppos)
>  {
>         struct cftype *cft = __d_cft(file->f_dentry);
>         struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
>
>         if (!cft)
>                 return -ENODEV;
>         if (cft->write)
>                 return cft->write(cgrp, cft, file, buf, nbytes, ppos);
>         if (cft->write_uint)
>                 return cgroup_write_uint(cgrp, cft, file, buf, nbytes, ppos);
>         return -EINVAL;
>  }
>
>  static ssize_t cgroup_read_uint(struct cgroup *cgrp, struct cftype *cft,
>                                    struct file *file,
>                                    char __user *buf, size_t nbytes,
>                                    loff_t *ppos)
>  {
>         char tmp[64];
>         u64 val = cft->read_uint(cgrp, cft);
>         int len = sprintf(tmp, "%llu\n", (unsigned long long) val);
>
>
>
