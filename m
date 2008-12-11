Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYLKA6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYLKA6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYLKA60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:58:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64316 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbYLKA6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:58:25 -0500
Message-ID: <49406553.6000408@cn.fujitsu.com>
Date: Thu, 11 Dec 2008 08:56:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] devices cgroup: allow mkfifo
References: <20081210155721.GA15166@us.ibm.com>
In-Reply-To: <20081210155721.GA15166@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andrew

Serge E. Hallyn wrote:
> The devcgroup_inode_permission() hook in the devices whitelist
> cgroup has always bypassed access checks on fifos.  But the
> mknod hook did not.  The devices whitelist is only about block
> and char devices, and fifos can't even be added to the whitelist,
> so fifos can't be created at all except by tasks which have 'a'
> in their whitelist (meaning they have access to all devices).
> 
> Fix the behavior by bypassing access checks to mkfifo.
> 

It also bypasses checks to mksock. Should backport this patch?

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  security/device_cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 5ba7870..df9d491 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -513,6 +513,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
>  	struct dev_cgroup *dev_cgroup;
>  	struct dev_whitelist_item *wh;
>  
> +	if (!S_ISBLK(mode) && !S_ISCHR(mode))
> +		return 0;
> +
>  	rcu_read_lock();
>  
>  	dev_cgroup = task_devcgroup(current);

