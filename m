Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZBJKPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZBJKPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZBJKPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:15:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBJKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:15:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=k3BzUd8vs3SOuEcqhswy60qU96jSdfW1OJ9lLwbZDIU+nkj54HJOZJeUmRz64hQu4
	l71hJkRtk+ovDzTaVEsWg==
MIME-Version: 1.0
In-Reply-To: <4991497B.4030200@cn.fujitsu.com>
References: <4991497B.4030200@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 02:15:36 -0800
Message-ID: <6599ad830902100215o185edd31k8731e033717dbb49@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix possible use after free
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:31 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> In cgroup_kill_sb(), root is freed before sb is detached from the list,
> so another sget() may find this sb and call cgroup_test_super(),
> which will access the root that has been freed.

I think that I'd assumed that by the time we get to cgroup_kill_sb()
there's no chance of the sb being resurrected by sget().

If anyone can call cgroup_test_super() on the sb that we're trying to
free, isn't that bad? Since even with this patch we free root just
after calling kill_litter_sb(), if anyone tries to reuse that super
block then they're toast.

Would it be better to set sb->s_fs_info to NULL, before calling
kill_litter_sb(), and have cgroup_test_super() just return 0 for any
sb with a NULL sb->s_fs_info.

Paul

>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5a54ff4..42fd3f2 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1122,8 +1122,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
>
>        mutex_unlock(&cgroup_mutex);
>
> -       kfree(root);
>        kill_litter_super(sb);
> +       kfree(root);
>  }
>
>  static struct file_system_type cgroup_fs_type = {
> --
> 1.5.4.rc3
>
