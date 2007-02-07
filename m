Return-Path: <linux-kernel-owner+w=401wt.eu-S1161460AbXBGW1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161460AbXBGW1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161464AbXBGW1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:27:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161460AbXBGW1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:27:50 -0500
Date: Wed, 7 Feb 2007 14:27:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
Message-Id: <20070207142717.5da4d8d4.akpm@linux-foundation.org>
In-Reply-To: <45C962C3.2020904@in.ibm.com>
References: <45C85097.1000106@in.ibm.com>
	<20070206100607.GA10296@infradead.org>
	<45C856F1.7060403@in.ibm.com>
	<45C894EA.4060305@in.ibm.com>
	<20070206145609.GA11249@slug>
	<45C962C3.2020904@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Feb 2007 10:55:23 +0530
Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> --- linux-2.6.20.orig/fs/debugfs/inode.c
> +++ linux-2.6.20/fs/debugfs/inode.c
> @@ -25,6 +25,7 @@
>  #include <linux/namei.h>
>  #include <linux/debugfs.h>
>  #include <linux/fsnotify.h>
> +#include <linux/kprobes.h>
>  
>  #define DEBUGFS_MAGIC	0x64626720
>  
> @@ -320,6 +321,7 @@ static int __init debugfs_init(void)
>  	retval = register_filesystem(&debug_fs_type);
>  	if (retval)
>  		subsystem_unregister(&debug_subsys);
> +	debugfs_kprobe_init();
>  	return retval;
>  }

eww.  Didn't it feel bad when you did that?


As this module has a dependency upon debugfs, I'd have thought the
approproate way of expressing that would be to run debugfs_kprobe_init()
at a lower initcall priority than debugfs_init()

> +void __kprobes debugfs_kprobe_init(void)
> +{
> +	struct dentry *dir;
> +	
> +	dir = debugfs_create_dir("kprobes", NULL);
> +	if (dir == NULL)
> +		return;
> +	debugfs_create_file("list", 0444, dir , 0 , &proc_kprobes_operations);
> +}
> +
>  __initcall(init_kprobes);

debugfs_init() already runs at core_initcall level, presumably so that
debugfs clients can use plain old module_init().

> 
> +static inline void debugfs_kprobe_init(void)
> +{
> +}

In which case we don't need this.	
