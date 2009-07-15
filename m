Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZGOBPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZGOBPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZGOBPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:15:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbZGOBPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:15:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uyF/xYuYUSmzp06uk7pX5xuzyF184pJHYM+u6EgIdERvYnjQO24h/3I0Wlhqsi6/8
	/IF3zm16hgbEmHAVJxIlg==
MIME-Version: 1.0
In-Reply-To: <20090714210557.0f983c37@bree.surriel.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org>
	 <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com>
	 <20090714210557.0f983c37@bree.surriel.com>
Date: Tue, 14 Jul 2009 18:15:39 -0700
Message-ID: <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 6:05 PM, Rik van Riel<riel@redhat.com> wrote:
> After moving the oom_adj value from the task struct to the
> mm_struct, the oom_adj value was no longer properly inherited
> by child processes.
>
> Copying over the oom_adj value at fork time fixes that bug.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Paul Menage <manage@google.com>
> ---
> Paul, does this fix your bug?

It fixes that specific problem. (Although the patch title should
probably be "copy over oom_adj value at execve time")

But ironically, with this fix applied the main part of the original
change (force all threads in a process to share a single oom_adj
value) will start to break my code - it's no longer possible to have
the regular threads in a process be oom-immune, then vfork() and set a
non-disabled oom_adj in the child, since this will set it for the
entire process. (Our job scheduler does something like this, in order
to have the launcher be OOM immune and the running jobs be at various
oom_adj levels depending on their priority).

It's probably something that I can work around, but it seems like the
kind of API change that could break unsuspecting users.

Paul

>
>  kernel/fork.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: mmotm/kernel/fork.c
> ===================================================================
> --- mmotm.orig/kernel/fork.c    2009-07-14 20:58:01.000000000 -0400
> +++ mmotm/kernel/fork.c 2009-07-14 21:00:40.000000000 -0400
> @@ -435,6 +435,7 @@ static struct mm_struct * mm_init(struct
>        init_rwsem(&mm->mmap_sem);
>        INIT_LIST_HEAD(&mm->mmlist);
>        mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
> +       mm->oom_adj = current->mm->oom_adj;
>        mm->core_state = NULL;
>        mm->nr_ptes = 0;
>        set_mm_counter(mm, file_rss, 0);
>
