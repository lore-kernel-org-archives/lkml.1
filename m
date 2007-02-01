Return-Path: <linux-kernel-owner+w=401wt.eu-S1422909AbXBAPFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422909AbXBAPFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422914AbXBAPFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:05:23 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:10575 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXBAPFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:05:22 -0500
Message-ID: <45C20456.2070800@sw.ru>
Date: Thu, 01 Feb 2007 18:16:38 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: devel@openvz.org
CC: akpm@osdl.org, pasky@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [Devel] [RFC] Allow access to /proc/$PID/fd after setuid()
References: <20070201150434.GA6023@localhost.sw.ru>
In-Reply-To: <20070201150434.GA6023@localhost.sw.ru>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Kirill Korotaev <dev@openvz.org>

> /proc/$PID/fd has r-x------ permissions, so if process does setuid(), it
> will not be able to access /proc/*/fd/. This breaks fstatat() emulation
> in glibc.
> 
> open("foo", O_RDONLY|O_DIRECTORY)       = 4
> setuid32(65534)                         = 0
> stat64("/proc/self/fd/4/bar", 0xbfafb298) = -1 EACCES (Permission denied)
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
> ---
> 
>  fs/proc/base.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1413,11 +1413,27 @@ static struct file_operations proc_fd_op
>  	.readdir	= proc_readfd,
>  };
>  
> +static int proc_fd_permission(struct inode *inode, int mask, struct nameidata *nd)
> +{
> +	struct task_struct *tsk;
> +	int rv;
> +
> +	rv = generic_permission(inode, mask, NULL);
> +	if (rv == 0)
> +		return 0;
> +	tsk = get_proc_task(inode);
> +	if (tsk == current)
> +		rv = 0;
> +	put_task_struct(tsk);
> +	return rv;
> +}
> +
>  /*
>   * proc directories can do almost nothing..
>   */
>  static struct inode_operations proc_fd_inode_operations = {
>  	.lookup		= proc_lookupfd,
> +	.permission	= proc_fd_permission,
>  	.setattr	= proc_setattr,
>  };
>  
> 
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
> 

