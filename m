Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbZAEHkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbZAEHkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 02:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZAEHj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 02:39:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbZAEHj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 02:39:58 -0500
Date: Sun, 4 Jan 2009 23:38:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] cpuset: convert cpuset_attach() to use
 cpumask_var_t
Message-Id: <20090104233856.8c72eb58.akpm@linux-foundation.org>
In-Reply-To: <495B2EFB.302@cn.fujitsu.com>
References: <495B2EA6.7010808@cn.fujitsu.com>
	<495B2EC2.9090305@cn.fujitsu.com>
	<495B2EE7.4040406@cn.fujitsu.com>
	<495B2EFB.302@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 16:36:11 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Impact: reduce stack usage
> 
> Allocate a cpumask_var_t in cpuset_can_attach() and then use it in
> cpuset_attach(), so we won't fail cpuset_attach().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cpuset.c |   31 +++++++++++++++++++++++++------
>  1 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index afa29cf..b4c36d5 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1306,6 +1306,14 @@ static int fmeter_getrate(struct fmeter *fmp)
>  	return val;
>  }
>  
> +/*
> + * Since cpuset_attach() can't fail, we allocate a cpumask_var_t in
> + * cpuset_can_attach() and then use it in cpuset_attach().
> + *
> + * Protected by cgroup_lock.

OK, but it's a bit fragile.

How are we to ensure that all calls to cpuset_can_attach() are followed
by a call to cpuset_attach(), and how are we to ensure that both calls
are protected by the same taking of the lock?  For all time?

In fact, it's broken right now, isn't it?  If cgroup_attach_task()'s
call to find_css_set() fails, we leak the result of cpuset_can_attach()'s
alloc_cpumask_var()?

