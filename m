Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZAWFGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZAWFGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZAWFGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:06:09 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50496 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbZAWFGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:06:08 -0500
X-Sasl-enc: vJO2gHOi56AdAE2jtSYUxw0xx41JjX+T76WupVSt5K6P 1232686104
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20090118073441.GA699@redhat.com>
References: <20090118073441.GA699@redhat.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 13:48:20 +0900
Message-Id: <1232686100.3011.18.camel@zeus.themaw.net>
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

Following the lengthy discussion, largely for my benefit, I'm now
looking at the patch with some idea of sensibility.

It seems to me that when setting sbi->oz_pgrp we should use
task_pgrp_vnr(). As Oleg says, and I agree, this should always give
correct results when checking if current is the session leader.

But I think that for debug logging we should always report numbers that
correspond to the object as it is seen in the global namespace as that
is the most likely reference point someone examining debug logging will
be working from.

Oleg, what should be the recommended call to report that, instead of the
task_pgrp_nr() call?

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

