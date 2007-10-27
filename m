Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbXJ0FvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbXJ0FvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXJ0Fu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:50:57 -0400
Received: from fw01.cmbrmaks.akamai.com ([80.67.64.10]:20489 "EHLO
	smtp2.akamai.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbXJ0Fu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:50:56 -0400
Date: Fri, 26 Oct 2007 22:50:45 -0700
From: Jason Uhlenkott <juhlenko@akamai.com>
To: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] cgroup simplify space stripping
Message-ID: <20071027055045.GA12340@48M1231.sanmateo.corp.akamai.com>
References: <20071024173621.24359.1372.sendpatchset@jackhammer.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024173621.24359.1372.sendpatchset@jackhammer.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 10:36:21 -0700, Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> Simplify the space stripping code in cgroup file write.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
> 
> This patch applies after both:
> 	Adrian Bunk's: [2.6 patch] kernel/cgroup.c: remove dead code
> 	pj's: [PATCH] cgroup brace coding style fix
> 
>  kernel/cgroup.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> --- 2.6.23-mm1.orig/kernel/cgroup.c	2007-10-24 10:03:11.847801501 -0700
> +++ 2.6.23-mm1/kernel/cgroup.c	2007-10-24 10:29:08.355032464 -0700
> @@ -1327,6 +1327,7 @@ static ssize_t cgroup_common_file_write(
>  		goto out1;
>  	}
>  	buffer[nbytes] = 0;	/* nul-terminate */
> +	strstrip(buffer);	/* strip -just- trailing whitespace */
>  
>  	mutex_lock(&cgroup_mutex);
>  
> @@ -1347,19 +1348,9 @@ static ssize_t cgroup_common_file_write(
>  			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>  		break;
>  	case FILE_RELEASE_AGENT:
> -	{
> -		struct cgroupfs_root *root = cgrp->root;
> -		/* Strip trailing newline */
> -		if (nbytes && (buffer[nbytes-1] == '\n'))
> -			buffer[nbytes-1] = 0;
> -		/* We never write anything other than '\0'
> -		 * into the last char of release_agent_path,
> -		 * so it always remains a NUL-terminated
> -		 * string */
> -		strncpy(root->release_agent_path, buffer, nbytes);
> -		root->release_agent_path[nbytes] = 0;
> +		BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);

Could be BUILD_BUG_ON, even.


> +		strcpy(cgrp->root->release_agent_path, buffer);
>  		break;
> -	}
>  	default:
>  		retval = -EINVAL;
>  		goto out2;
