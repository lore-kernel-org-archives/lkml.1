Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXBAAte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXBAAte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161147AbXBAAte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:49:34 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51019 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161141AbXBAAtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:49:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: Fix listing of /proc/NOT_A_TGID/task
References: <45C12953.4070205@yahoo.fr>
Date: Wed, 31 Jan 2007 17:48:28 -0700
In-Reply-To: <45C12953.4070205@yahoo.fr> (Guillaume Chazarain's message of
	"Thu, 01 Feb 2007 00:42:11 +0100")
Message-ID: <m1abzyaejn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain <guichaz@yahoo.fr> writes:

> Hi,
>
> I think this is 2.6.20 material, if it gets appropriately reviewed ;-)

Look good to me.

Lookup doesn't have this problem because it only tests for tgid.
I'm not certain at the moment if we need the rcu_read_lock,
and pid_alive checks, but at worst they are overkill.

> Thanks.
>
> -- 
> Guillaume
>
> Listing /proc/PID/task were PID is not a TGID
> should not result in duplicated entries.
>
> [g ~]$ pidof thunderbird-bin
> 2751
> [g ~]$ ls /proc/2751/task
> 2751  2770  2771  2824  2826  2834  2835  2851  2853
> [g ~]$ ls /proc/2770/task
> 2751  2770  2771  2824  2826  2834  2835  2851  2853
> 2770  2771  2824  2826  2834  2835  2851  2853
> [g ~]$ 
>
> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
> ---
>
>  fs/proc/base.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff -r f99a8b402753 fs/proc/base.c
> --- a/fs/proc/base.c	Wed Jan 31 05:00:31 2007 +0000
> +++ b/fs/proc/base.c	Thu Feb 01 00:25:33 2007 +0100
> @@ -2328,13 +2328,23 @@ static int proc_task_readdir(struct file
>  {
>  	struct dentry *dentry = filp->f_path.dentry;
>  	struct inode *inode = dentry->d_inode;
> -	struct task_struct *leader = get_proc_task(inode);
> +	struct task_struct *leader = NULL;
>  	struct task_struct *task;
>  	int retval = -ENOENT;
>  	ino_t ino;
>  	int tid;
>  	unsigned long pos = filp->f_pos; /* avoiding "long long" filp->f_pos */
>  
> +	task = get_proc_task(inode);
> +	if (!task)
> +		goto out_no_task;
> +	rcu_read_lock();
> +	if (pid_alive(task)) {
> +		leader = task->group_leader;
> +		get_task_struct(leader);
> +	}
> +	rcu_read_unlock();
> +	put_task_struct(task);
>  	if (!leader)
>  		goto out_no_task;
>  	retval = 0;
