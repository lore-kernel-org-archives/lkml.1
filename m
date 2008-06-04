Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYFDJLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYFDJLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYFDJLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:11:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22992 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYFDJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:11:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NDWpBfnNCV4Z9IUXz2t3uAubMg3pjVq/ySBgnM6YMYd0cdJaPRiuyXrJ57xGdroGW
	yPe3ynMxr/fu8tG/nn7rA==
Message-ID: <6599ad830806040211t31d86c57o6836f7cc34faf7f7@mail.gmail.com>
Date: Wed, 4 Jun 2008 02:11:39 -0700
From: "Paul Menage" <menage@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] cgroup: list_for_each cleanup
Cc: linux-kernel@vger.kernel.org, "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <20080604172812.941C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604172812.941C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,

On Wed, Jun 4, 2008 at 1:36 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> @@ -3072,16 +3070,19 @@ void __css_put(struct cgroup_subsys_stat
>  */
>  static void cgroup_release_agent(struct work_struct *work)
>  {
> +       struct cgroup *cgrp;
> +       struct cgroup *saved_cgrp;
> +
>        BUG_ON(work != &release_agent_work);
>        mutex_lock(&cgroup_mutex);
>        spin_lock(&release_list_lock);
> -       while (!list_empty(&release_list)) {
> +
> +       list_for_each_entry_safe(cgrp, saved_cgrp, &release_list,
> +                                release_list) {
>                char *argv[3], *envp[3];
>                int i;
>                char *pathbuf;
> -               struct cgroup *cgrp = list_entry(release_list.next,
> -                                                   struct cgroup,
> -                                                   release_list);
> +
>                list_del_init(&cgrp->release_list);
>                spin_unlock(&release_list_lock);
>                pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>

I don't think that list_for_each_entry_safe() is still safe when we've
dropped release_list_lock. saved_cgroup could end up pointing to a
cgroup that's freed while we're forking the usermode helper.

Paul
