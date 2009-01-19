Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZASCUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZASCUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbZASCUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:20:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42157 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756680AbZASCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:20:05 -0500
X-Sasl-enc: U8siHkTxNu2q+4fauoMqu5gIT2OAP0CXCqV64e3Aqevs 1232331602
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
In-Reply-To: <20090118073441.GA699@redhat.com>
References: <20090118073441.GA699@redhat.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 11:20:02 +0900
Message-Id: <1232331602.3136.19.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 08:34 +0100, Oleg Nesterov wrote:
> parse_options(&pgid) sets pgid = task_pgrp_nr() which uses the global
> namespace. This is wrong, we use this pgid to find "struct pid" in the
> current's namespace. Change parse_options() to use task_pgrp_vnr().
> 
> Also do s/task_pgrp_nr/task_pgrp_vnr/ in the debugging printks.
> checkpatch.pl complains about "line over 80 characters", but it should
> blame the cuurent code, not the patch.

This changelog entry doesn't really have anything that I can use to work
out if this change might introduce regressions.

It would be helpful to me if you could include:
1) A brief statement about what your trying to achieve and why.
2) The reason why task_pgrp_nr() has changed to task_pgrp_vnr() since
you made the change (that is someone working on pid namespaces) to
task_pgrp_nr().
3) Why you believe this change won't introduce a regression.

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
> +++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
> @@ -78,7 +78,7 @@ static int parse_options(char *options, 
>  
>  	*uid = current_uid();
>  	*gid = current_gid();
> -	*pgrp = task_pgrp_nr(current);
> +	*pgrp = task_pgrp_vnr(current);
>  
>  	*minproto = *maxproto = AUTOFS_PROTO_VERSION;
>  
> --- CUR/fs/autofs/root.c~1_AUTOFS	2008-10-10 00:13:53.000000000 +0200
> +++ CUR/fs/autofs/root.c	2009-01-18 06:15:42.000000000 +0100
> @@ -215,7 +215,7 @@ static struct dentry *autofs_root_lookup
>  	oz_mode = autofs_oz_mode(sbi);
>  	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
>  				"oz_mode = %d\n", task_pid_nr(current),
> -				task_pgrp_nr(current), sbi->catatonic,
> +				task_pgrp_vnr(current), sbi->catatonic,
>  				oz_mode));
>  
>  	/*
> @@ -550,7 +550,8 @@ static int autofs_root_ioctl(struct inod
>  	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
>  	void __user *argp = (void __user *)arg;
>  
> -	DPRINTK(("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",cmd,arg,sbi,task_pgrp_nr(current)));
> +	DPRINTK(("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",
> +		cmd, arg, sbi, task_pgrp_vnr(current)));
>  
>  	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
>  	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
> 

