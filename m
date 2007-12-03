Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXLCViz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXLCViz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXLCVis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:38:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbXLCVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:38:47 -0500
Date: Mon, 3 Dec 2007 13:38:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef
 CONFIG_SYSCTL
Message-Id: <20071203133844.40804dab.akpm@linux-foundation.org>
In-Reply-To: <475009FA.20409@openvz.org>
References: <475008F5.3000506@openvz.org>
	<475009FA.20409@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 16:02:50 +0300
Pavel Emelyanov <xemul@openvz.org> wrote:

> This includes the tables themselves and the call to the
> register_sysctl_table(). Since this call is done from the __init
> call, I hope this is OK to keep the #ifdef inside the function, 
> rather than making proper helpers outside it.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/dquot.c b/fs/dquot.c
> index 50e7c2a..efee14d 100644
> --- a/fs/dquot.c
> +++ b/fs/dquot.c
> @@ -1821,6 +1821,7 @@ struct quotactl_ops vfs_quotactl_ops = {
>  	.set_dqblk	= vfs_set_dqblk
>  };
>  
> +#ifdef CONFIG_SYSCTL
>  static ctl_table fs_dqstats_table[] = {
>  	{
>  		.ctl_name	= FS_DQ_LOOKUPS,
> @@ -1918,6 +1919,7 @@ static ctl_table sys_table[] = {
>  	},
>  	{ .ctl_name = 0 },
>  };
> +#endif
>  
>  static int __init dquot_init(void)
>  {
> @@ -1926,7 +1928,9 @@ static int __init dquot_init(void)
>  
>  	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
>  
> +#ifdef CONFIG_SYSCTL
>  	register_sysctl_table(sys_table);
> +#endif
>  
>  	dquot_cachep = kmem_cache_create("dquot",
>  			sizeof(struct dquot), sizeof(unsigned long) * 4,

We should avoid the ifdefs around the register_sysctl_table() call.

At present the !CONFIG_SYSCTL implementation of register_sysctl_table() is
a non-inlined NULL-returning stub.  All we have to do is to inline that stub
then these ifdefs can go away.

The same applies to register_sysctl_paths().


If that's all agreeable then there isn't a lot of point in me merging these
seven patches.



btw, administrivia detail: please don't put the patch's subsystem
identifier in [].  IOW, this:

Subject: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL

should have been

Subject: [PATCH 1/7] quota: move sysctl management code under ifdef CONFIG_SYSCTL

for reasons described in section 2 of
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt.


Thanks.

