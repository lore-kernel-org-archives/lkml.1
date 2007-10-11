Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbXJKGwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbXJKGwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXJKGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:52:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49505 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbXJKGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:52:17 -0400
Message-ID: <470DC988.3020506@bull.net>
Date: Thu, 11 Oct 2007 08:58:16 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pierre Peiffer <Pierre.Peiffer@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPC: fix error case when idr-cache is empty in ipcget()
References: <20071010114659.c4db806f.Pierre.Peiffer@bull.net>
In-Reply-To: <20071010114659.c4db806f.Pierre.Peiffer@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 08:58:35,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 08:58:37,
	Serialize complete at 11/10/2007 08:58:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Peiffer wrote:
> With the use of idr to store the ipc, the case where the idr cache is
> empty, when idr_get_new is called (this may happen even if we call
> idr_pre_get() before), is not well handled: it lets semget()/shmget()/msgget()
> return ENOSPC when this cache is empty, what 1. does not reflect the facts
> and 2. does not conform to the man(s).
> 
> This patch fixes this by retrying the whole process of allocation in this case.
> 
> Note: we could directly return ENOMEM if idr_pre_get() fails, but it does not
> mean that the cache is empty...
> 

Pierre,

I agree with everythying, but not on idr_pre_get() failure: I think we 
should give up in that case: the tests on idr_pre_get() return code 
should remain IMHO (see after).


><snip>
> 
> @@ -309,17 +309,20 @@ int ipc_addid(struct ipc_ids* ids, struc
>  int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
>  		struct ipc_ops *ops, struct ipc_params *params)
>  {
> -	int err;
> -
> -	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
> -
> -	if (!err)
> -		return -ENOMEM;
> +	int err, alloc;
> +retry:
> +	alloc = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
>  
>  	mutex_lock(&ids->mutex);
>  	err = ops->getnew(ns, params);
>  	mutex_unlock(&ids->mutex);
>  
> +	if (err == -EAGAIN) {
> +		if (alloc)
> +			goto retry;
> +		else
> +			err = -ENOMEM;
> +	}
>  	return err;
>  }


ops->getnew will call idr_get_new() that should not be called if 
idr_pre_get() has failed. So I think that we should give up if 
idr_pre_get() fails and the test on idr_pre_get() return code should not 
be removed.

>  
> @@ -372,9 +375,9 @@ int ipcget_public(struct ipc_namespace *
>  {
>  	struct kern_ipc_perm *ipcp;
>  	int flg = params->flg;
> -	int err;
> -
> -	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
> +	int err, alloc;
> +retry:
> +	alloc = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
>  
>  	mutex_lock(&ids->mutex);
>  	ipcp = ipc_findkey(ids, params->key);
> @@ -382,8 +385,6 @@ int ipcget_public(struct ipc_namespace *
>  		/* key not used */
>  		if (!(flg & IPC_CREAT))
>  			err = -ENOENT;
> -		else if (!err)
> -			err = -ENOMEM;
>  		else
>  			err = ops->getnew(ns, params);

Same remark as above:
ops->getnew will call idr_get_new() that should not be called if 
idr_pre_get() has failed. So I think that we should give up if 
idr_pre_get() fails and this this test should not be removed.


Regards,
Nadia




