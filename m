Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbYKGHBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYKGHBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYKGHBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:01:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50302 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYKGHBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:01:44 -0500
Message-ID: <4913E72D.3060108@cn.fujitsu.com>
Date: Fri, 07 Nov 2008 14:58:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH -last version] freezer_cg: disable writing freezer.state
 of root  cgroup
References: <491245F1.5070707@cn.fujitsu.com> <6599ad830811051724p1f97026fl96be5efe38b33152@mail.gmail.com> <49124DFF.1090702@cn.fujitsu.com> <49125006.4050206@cn.fujitsu.com> <4912A73C.4080308@fr.ibm.com>
In-Reply-To: <4912A73C.4080308@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would make a small macro is_root_freezer() to show explicitly
> what we are testing and use the CSS_ROOT bit to test. That's what
> the CSS_ROOT bit is for Paul ?
> 

I think yes CSS_ROOT can be used, though currently CSS_ROOT is used in
cgroup internal only (in css_get() and css_put()).

> if yes, here's a possible result is below. 
> 

is_root_freezer() looks a bit better, but I don't have strong option about
this change, the original code and the comment is enough to explain what
we are doing.

> C.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> ---
>  kernel/cgroup_freezer.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> Index: 2.6.27-lxc/kernel/cgroup_freezer.c
> ===================================================================
> --- 2.6.27-lxc.orig/kernel/cgroup_freezer.c
> +++ 2.6.27-lxc/kernel/cgroup_freezer.c
> @@ -47,6 +47,11 @@ static inline struct freezer *task_freez
>  			    struct freezer, css);
>  }
>  
> +static inline int is_root_freezer(struct freezer *freezer)
> +{
> +	return test_bit(CSS_ROOT, &freezer->css.flags);
> +}
> +
>  int cgroup_frozen(struct task_struct *task)
>  {
>  	struct freezer *freezer;
> @@ -190,6 +195,13 @@ static void freezer_fork(struct cgroup_s
>  	freezer = task_freezer(task);
>  	task_unlock(task);
>  
> +	/*
> +	 * The root cgroup is non-freezable, so we can skip the
> +	 * following check.
> +	 */
> +	if (is_root_freezer(freezer))
> +		return;
> +
>  	BUG_ON(freezer->state == CGROUP_FROZEN);
>  	spin_lock_irq(&freezer->lock);
>  	/* Locking avoids race with FREEZING -> THAWED transitions. */
> @@ -363,6 +375,9 @@ static struct cftype files[] = {
>  
>  static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
>  {
> +	if (is_root_freezer(cgroup_freezer(cgroup)))
> +		return 0;
> +
>  	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
>  }
> 

