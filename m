Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752366AbYLQTEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbYLQTEv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYLQTEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:04:40 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:42210 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLQTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:04:39 -0500
Date: Wed, 17 Dec 2008 20:04:33 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, hch@infradead.org
Subject: Re: [PATCH] sys_execve and sys_uselib do not call into fsnotify
Message-ID: <20081217190433.GA31115@gambetta>
References: <1229540000.3384.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229540000.3384.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

On Wed, Dec 17, 2008 at 01:53:20PM -0500, Eric Paris wrote:
> sys_execve and sys_uselib do not call into fsnotify so inotify does not get
> open events for these types of syscalls.  This patch simply makes the
> requisite fsnotify calls.

Just curious, isn't the fact that the open still may fail a problem?
For example, if the lib is not executable in sys_uselib or if the file
was denied write access in open_exec.

Regards,
Frederik
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  fs/exec.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ec5df9a..cbd93b5 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -51,6 +51,7 @@
>  #include <linux/audit.h>
>  #include <linux/tracehook.h>
>  #include <linux/kmod.h>
> +#include <linux/fsnotify.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -135,6 +136,8 @@ asmlinkage long sys_uselib(const char __user * library)
>  	if (IS_ERR(file))
>  		goto out;
>  
> +	fsnotify_open(file->f_path.dentry);
> +
>  	error = -ENOEXEC;
>  	if(file->f_op) {
>  		struct linux_binfmt * fmt;
> @@ -687,6 +690,8 @@ struct file *open_exec(const char *name)
>  	if (IS_ERR(file))
>  		return file;
>  
> +	fsnotify_open(file->f_path.dentry);
> +
>  	err = deny_write_access(file);
>  	if (err) {
>  		fput(file);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
