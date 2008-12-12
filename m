Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYLLLiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYLLLiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLLLiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:38:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:27344 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYLLLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wcix7sXOWT8md4sXLLxd8mX6si5m5TG1tyghBZ61sGFZZ1fLr1Sk0jiBncIs6+4YGk
         qPqb29d3vZ3COLqtOaHapPhpfKig0QWtwgG9wFuUCnhoX7SmkmZLyHBr8IqYaLMb0VE6
         tnnaVqAFd0GZDNjOG1+5Jw2H9tGMwBi8UvjV4=
Message-ID: <344eb09a0812120338h29e1088pac7f9a22e37bf609@mail.gmail.com>
Date: Fri, 12 Dec 2008 17:08:02 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul Menage" <menage@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <494234B0.5@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494234B0.5@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 3:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>  kernel/sched_debug.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 26ed8e3..01abf5b 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -127,8 +127,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>        if (tg)
>                cgroup = tg->css.cgroup;
>
> -       if (cgroup)
> +       if (cgroup) {
> +               cgroup_lock();
>                cgroup_path(cgroup, path, sizeof(path));
> +               cgroup_unlock();
> +       }
>
>        SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
>  #else
> @@ -181,8 +184,11 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>        if (tg)
>                cgroup = tg->css.cgroup;
>
> -       if (cgroup)
> +       if (cgroup) {
> +               cgroup_lock();
>                cgroup_path(cgroup, path, sizeof(path));
> +               cgroup_unlock();
> +       }
>
>        SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
>  #else

The comment in cgroup_path() routine says that it needs to be called
with cgroup_mutex held. With the above fix, print_task() in
sched_debug.c remains the last caller of cgroup_path() which calls it
without holding cgroup_mutex. Does this also need a fix ?

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
