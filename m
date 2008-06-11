Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYFKKqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYFKKqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYFKKpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:45:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYFKKpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:45:52 -0400
Date: Wed, 11 Jun 2008 03:45:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] shm: Remove silly double assignment
Message-Id: <20080611034506.05ad07ae.akpm@linux-foundation.org>
In-Reply-To: <20080610125338.GB3165@hmsreliant.think-freely.org>
References: <20080610125338.GB3165@hmsreliant.think-freely.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 08:53:39 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:

>     Found a silly double assignment of err is do_shmat.  Silly, but good to clean up
>     the useless code.
>     
>     Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 554429a..d05f6b5 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -894,8 +894,6 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  	if (!sfd)
>  		goto out_put_dentry;
>  
> -	err = -ENOMEM;
> -
>  	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
>  	if (!file)
>  		goto out_free;

Not silly, really.  Look:

	err = -ENOMEM;
	if (expr1)
		goto out;

	err = -ENOMEM;
	if (expr2)
		goto out;

each of these two units is a separate, self-contained clause.  Removing
the second assignment to `err' breaks that separation and will make one
clause undesirably dependent upon the other.

Example: if someone later comes up and does

	err = -ENOMEM;
	if (expr1)
		goto out;

+	er = -EINVAL;
+	if (expr3)
+		goto out;

	if (expr2)
		goto out;

then whoops, it broke.

The compiler should optimise away the second assignment anyway.
