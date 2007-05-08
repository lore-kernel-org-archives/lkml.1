Return-Path: <linux-kernel-owner+w=401wt.eu-S934771AbXEHInc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbXEHInc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934755AbXEHInb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:43:31 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:36335 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934665AbXEHIna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:43:30 -0400
X-Greylist: delayed 2540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 04:43:30 EDT
Subject: Re: [PATCH] DLM: fix a couple of races
From: Steven Whitehouse <steve@chygwyn.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: linux-kernel@vger.kernel.org, teigland@redhat.com,
       linux-cluster@redhat.com, joel.becker@oracle.com
In-Reply-To: <Pine.LNX.4.64.0705042119510.16239@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0705042119510.16239@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain
Organization: ChyGwyn Limited (Registered in England and Wales, No.
	03887683) Registered Office: Digital Technium, Singleton Park, Swansea. SA2
	8PP
Date: Tue, 08 May 2007 09:00:58 +0100
Message-Id: <1178611258.7476.5.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Added to the GFS2 -nmw git tree, thanks. Please remember to add a
Signed-off-by line for future patches - I've added it for you this time,

Steve.

On Fri, 2007-05-04 at 21:49 +0530, Satyam Sharma wrote:
> Hi,
> 
> There are the following two trivially-fixed races in fs/dlm/config.c:
> 
> 1. The configfs subsystem semaphore must be held by the caller when 
> calling config_group_find_obj(). It's needed to walk the subsystem 
> hierarchy without racing with a simultaneous mkdir(2) or rmdir(2). I 
> looked around to see if there was some other way we were avoiding this 
> race, but couldn't find any.
> 
> 2. get_comm() does hold the subsystem semaphore but lets go too soon -- 
> before grabbing a reference on the found config_item. A concurrent 
> rmdir(2) could come and release the comm after the up() but before the 
> config_item_get().
> 
> Patch that fixes both these bugs below.
> 
> Cheers,
> S
> 
> PS: For some reason, configfs still uses a struct semaphore (as a binary 
> semaphore) for configfs_subsystem.su_sem. Someone with free time should 
> convert that to a struct mutex, say configfs_subsystem.su_mtx -- which is 
> the preferred way to use (binary) mutexes presently. CC'ing Joel Becker on 
> this.
> 
> ---
> 
> Fix two races in fs/dlm/config.c:
> 
> (1) Grab the configfs subsystem semaphore before calling 
> config_group_find_obj() in get_space(). This solves a potential race 
> between get_space() and concurrent mkdir(2) or rmdir(2).
> 
> (2) Grab a reference on the found config_item _while_ holding the configfs 
> subsystem semaphore in get_comm(), and not after it. This solves a 
> potential race between get_comm() and concurrent rmdir(2).
> 
>   fs/dlm/config.c |   15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
>  	Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> ---
> 
> diff -ruNp linux-2.6.21.1/fs/dlm/config.c linux-2.6.21.1~patch/fs/dlm/config.c
> --- linux-2.6.21.1/fs/dlm/config.c	2007-04-26 08:38:32.000000000 +0530
> +++ linux-2.6.21.1~patch/fs/dlm/config.c	2007-05-04 21:08:54.000000000 +0530
> @@ -744,9 +744,16 @@ static ssize_t node_weight_write(struct
> 
>   static struct space *get_space(char *name)
>   {
> +	struct config_item *i;
> +
>   	if (!space_list)
>   		return NULL;
> -	return to_space(config_group_find_obj(space_list, name));
> +
> +	down(&space_list->cg_subsys->su_sem);
> +	i = config_group_find_obj(space_list, name);
> +	up(&space_list->cg_subsys->su_sem);
> +
> +	return to_space(i);
>   }
> 
>   static void put_space(struct space *sp)
> @@ -772,20 +779,20 @@ static struct comm *get_comm(int nodeid,
>   			if (cm->nodeid != nodeid)
>   				continue;
>   			found = 1;
> +			config_item_get(i);
>   			break;
>   		} else {
>   			if (!cm->addr_count ||
>   			    memcmp(cm->addr[0], addr, sizeof(*addr)))
>   				continue;
>   			found = 1;
> +			config_item_get(i);
>   			break;
>   		}
>   	}
>   	up(&clusters_root.subsys.su_sem);
> 
> -	if (found)
> -		config_item_get(i);
> -	else
> +	if (!found)
>   		cm = NULL;
>   	return cm;
>   }
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

