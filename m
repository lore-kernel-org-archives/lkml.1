Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYHUXcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYHUXcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYHUXch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:32:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:60577 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYHUXcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:32:36 -0400
Date: Fri, 22 Aug 2008 09:32:15 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Move the exec mutex release out of bprm_free()
In-Reply-To: <20080821123907.4731.54839.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808220932010.17708@tundra.namei.org>
References: <20080821123907.4731.54839.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, David Howells wrote:

> Move the exec mutex release out of free_bprm() and into the error handling
> paths of do_execve() and compat_do_execve().  install_exec_creds() already
> takes care of the success path.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

This patch does not apply to my tree:

Applying CRED: Move the exec mutex release out of bprm_free()
error: patch failed: fs/compat.c:1373
error: fs/compat.c: patch does not apply
error: patch failed: fs/exec.c:1319
error: fs/exec.c: patch does not apply
Patch failed at 0001.


> ---
> 
>  fs/compat.c |    3 +--
>  fs/exec.c   |    7 ++-----
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/compat.c b/fs/compat.c
> index 918f0f2..af24b8a 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -1373,7 +1373,7 @@ int compat_do_execve(char * filename,
>  	file = open_exec(filename);
>  	retval = PTR_ERR(file);
>  	if (IS_ERR(file))
> -		goto out_free;
> +		goto out_unlock;
>  
>  	sched_exec();
>  
> @@ -1427,7 +1427,6 @@ out_file:
>  		allow_write_access(bprm->file);
>  		fput(bprm->file);
>  	}
> -	goto out_free;
>  
>  out_unlock:
>  	mutex_unlock(&current->cred_exec_mutex);
> diff --git a/fs/exec.c b/fs/exec.c
> index 7b71679..9fa9a2d 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1277,10 +1277,8 @@ EXPORT_SYMBOL(search_binary_handler);
>  void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
> -	if (bprm->cred) {
> -		mutex_unlock(&current->cred_exec_mutex);
> +	if (bprm->cred)
>  		abort_creds(bprm->cred);
> -	}
>  	kfree(bprm);
>  }
>  
> @@ -1319,7 +1317,7 @@ int do_execve(char * filename,
>  	file = open_exec(filename);
>  	retval = PTR_ERR(file);
>  	if (IS_ERR(file))
> -		goto out_free;
> +		goto out_unlock;
>  
>  	sched_exec();
>  
> @@ -1376,7 +1374,6 @@ out_file:
>  		allow_write_access(bprm->file);
>  		fput(bprm->file);
>  	}
> -	goto out_free;
>  
>  out_unlock:
>  	mutex_unlock(&current->cred_exec_mutex);
> 

-- 
James Morris
<jmorris@namei.org>
