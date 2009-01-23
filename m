Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbZAWCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbZAWCU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 21:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbZAWCUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 21:20:17 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57082 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZAWCUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 21:20:16 -0500
Date: Thu, 22 Jan 2009 20:20:14 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH] cgroup: Fix root_count when mount fails due to busy
	subsystem
Message-ID: <20090123022014.GB9267@us.ibm.com>
References: <20090123004703.25103.29754.stgit@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123004703.25103.29754.stgit@menage.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> cgroup: Fix root_count when mount fails due to busy subsystem
> 
> root_count was being incremented in cgroup_get_sb() after all error
> checking was complete, but decremented in cgroup_kill_sb(), which can
> be called on a superblock that we gave up on due to an error.  This
> patch changes cgroup_kill_sb() to only decrement root_count if the
> root was previously linked into the list of roots.
> 
> Signed-off-by: Paul Menage <menage@google.com>

Tested-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> 
> ---
> 
> I was actually surprised to find that list_del() doesn't crash when
> run on an unattached list_head structure.
> 
>  kernel/cgroup.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index adcd0bb..9ce27e8 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1115,8 +1115,10 @@ static void cgroup_kill_sb(struct super_block *sb) {
>  	}
>  	write_unlock(&css_set_lock);
> 
> -	list_del(&root->root_list);
> -	root_count--;
> +	if (!list_empty(&root->root_list)) {
> +		list_del(&root->root_list);
> +		root_count--;
> +	}
> 
>  	mutex_unlock(&cgroup_mutex);
> 
