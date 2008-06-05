Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYFERT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYFERT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYFERTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:19:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44224 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbYFERT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:19:29 -0400
Date: Thu, 5 Jun 2008 09:23:38 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 2/2] devscgroup: make white list more compact in some
	cases
Message-ID: <20080605142338.GB11919@us.ibm.com>
References: <4847A7BE.5010603@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4847A7BE.5010603@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Consider you added a 'c foo:bar r' permission to some cgroup and then
> (a bit later) 'c'foo:bar w' for it. After this you'll see a
> c foo:bar r
> c foo:bar w
> lines in a devices.list file.
> 
> Another example - consider you added 10 'c foo:bar r' permissions to
> some cgroup (e.g. by mistake). After this you'll see 10
> c foo:bar r
> lines in a list file.
> 
> This is weird. This situation also has one more annoying consequence. 
> Having many items in a white list makes permissions checking slower, 
> sine it has to walk a longer list.
> 
> The proposal is to merge permissions for items, that correspond to the
> same device.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks.  I suppose if it was deemed worth it, the other thing you could
do would be to detect when you have a rule

	c foo:bar r

and you add a rule

	c foo:(all) r

-serge

> ---
>  security/device_cgroup.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index f9941a7..baf3488 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -106,7 +106,7 @@ free_and_exit:
>  static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
>  			struct dev_whitelist_item *wh)
>  {
> -	struct dev_whitelist_item *whcopy;
> +	struct dev_whitelist_item *whcopy, *walk;
> 
>  	whcopy = kmalloc(sizeof(*whcopy), GFP_KERNEL);
>  	if (!whcopy)
> @@ -114,7 +114,21 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
> 
>  	memcpy(whcopy, wh, sizeof(*whcopy));
>  	spin_lock(&dev_cgroup->lock);
> -	list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
> +	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
> +		if (walk->type != wh->type)
> +			continue;
> +		if (walk->major != wh->major)
> +			continue;
> +		if (walk->minor != wh->minor)
> +			continue;
> +
> +		walk->access |= wh->access;
> +		kfree(whcopy);
> +		whcopy = NULL;
> +	}
> +
> +	if (whcopy != NULL)
> +		list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
>  	spin_unlock(&dev_cgroup->lock);
>  	return 0;
>  }
> -- 
> 1.5.3.4
