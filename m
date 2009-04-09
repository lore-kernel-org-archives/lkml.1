Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZDIDfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZDIDfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbZDIDfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:35:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41312 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbZDIDfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:35:36 -0400
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make consistent errno value when open pident vs exit(2) race
References: <20090409121756.B3DD.A69D9226@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 08 Apr 2009 20:35:31 -0700
In-Reply-To: <20090409121756.B3DD.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's message of "Thu\,  9 Apr 2009 12\:23\:01 +0900 \(JST\)")
Message-ID: <m14owymrcs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org, adobriyan@gmail.com, akpm@osdl.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> proc_pident_instantiate() has following call flow.
>
> proc_pident_lookup()
>   proc_pident_instantiate()
>     proc_pid_make_inode()
>
> And, proc_pident_lookup() has following error handling.
>
> 	const struct pid_entry *p, *last;
> 	error = ERR_PTR(-ENOENT);
> 	if (!task)
> 		goto out_no_task;
>
> Then, proc_pident_instantiate should return ENOENT too when racing against
> exit(2) occur.
>
> EINAL has two bad reason. 
>   - it implies caller is wrong. bad the race isn't caller's mistake. 
>   - man 2 open don't explain EINVAL. user often don't handle it.
>
>
> Note: Other proc_pid_make_inode() caller already use ENOENT properly.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks reasonable to me.


> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> --
>  fs/proc/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f715597..803d09e 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1953,7 +1953,7 @@ static struct dentry *proc_pident_instantiate(struct inode *dir,
>  	const struct pid_entry *p = ptr;
>  	struct inode *inode;
>  	struct proc_inode *ei;
> -	struct dentry *error = ERR_PTR(-EINVAL);
> +	struct dentry *error = ERR_PTR(-ENOENT);
>  
>  	inode = proc_pid_make_inode(dir->i_sb, task);
>  	if (!inode)
