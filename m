Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYLLDMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYLLDMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbYLLDMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:12:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbYLLDMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:12:22 -0500
Date: Thu, 11 Dec 2008 19:12:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: torvalds@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] devices cgroup: allow mkfifo
Message-Id: <20081211191208.d4d251ad.akpm@linux-foundation.org>
In-Reply-To: <20081211155027.GB12750@us.ibm.com>
References: <20081211155027.GB12750@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 09:50:27 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> The devcgroup_inode_permission() hook in the devices whitelist
> cgroup has always bypassed access checks on fifos.  But the
> mknod hook did not.  The devices whitelist is only about block
> and char devices, and fifos can't even be added to the whitelist,
> so fifos can't be created at all except by tasks which have 'a'
> in their whitelist (meaning they have access to all devices).
> 
> Fix the behavior by bypassing access checks to mkfifo (and mksock).
> 
> (Thanks, Daniel, for finding this)
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
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

hm.  I'd looked at your description and decided this was 2.6.29 material.

But you think it's for 2.6.28 and even for 2.6.27.  How come?

(iow, your changelog sucked :)
