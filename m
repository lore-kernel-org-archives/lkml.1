Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXJXSEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXJXSEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXJXSEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:04:14 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36235 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbXJXSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:04:13 -0400
Message-ID: <471F822A.2030904@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2007 23:04:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/taskstats.c: fix bogus nlmsg_free()
References: <20071024162554.GC30533@stusta.de>
In-Reply-To: <20071024162554.GC30533@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> We'd better not nlmsg_free on a pointer containing an undefined value
> (and without having anything allocated)...
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  kernel/taskstats.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-2.6/kernel/taskstats.c.old	2007-10-23 19:01:07.000000000 +0200
> +++ linux-2.6/kernel/taskstats.c	2007-10-23 19:21:54.000000000 +0200
> @@ -383,67 +383,67 @@
> 
>  static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
>  {
>  	int rc = 0;
>  	struct sk_buff *rep_skb;
>  	struct cgroupstats *stats;
>  	struct nlattr *na;
>  	size_t size;
>  	u32 fd;
>  	struct file *file;
>  	int fput_needed;
> 
>  	na = info->attrs[CGROUPSTATS_CMD_ATTR_FD];
>  	if (!na)
>  		return -EINVAL;
> 
>  	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
>  	file = fget_light(fd, &fput_needed);
>  	if (file) {
>  		size = nla_total_size(sizeof(struct cgroupstats));
> 
>  		rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
>  					size);
>  		if (rc < 0)
> -			goto err;
> +			return rc;
> 

We miss a fput_light() here

>  		na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
>  					sizeof(struct cgroupstats));
>  		stats = nla_data(na);
>  		memset(stats, 0, sizeof(*stats));
> 
>  		rc = cgroupstats_build(stats, file->f_dentry);
> +
> +		fput_light(file, fput_needed);
> +

I don't understand this movement, it makes code reading a bit odd too.
rc is the result, but we check the result after fput_light?

>  		if (rc < 0)
>  			goto err;
> 
> -		fput_light(file, fput_needed);
>  		return send_reply(rep_skb, info->snd_pid);
> +err:
> +		nlmsg_free(rep_skb);
>  	}
> 
> -err:
> -	if (file)
> -		fput_light(file, fput_needed);
> -	nlmsg_free(rep_skb);
>  	return rc;
>  }


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
