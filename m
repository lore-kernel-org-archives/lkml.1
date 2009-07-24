Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZGXQSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZGXQSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZGXQSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:18:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48489 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZGXQSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:18:30 -0400
Date: Fri, 24 Jul 2009 18:14:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] task_struct cleanup: move binfmt field to mm_struct
Message-ID: <20090724161449.GA3509@redhat.com>
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A693569.1090009@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24, Hiroshi Shimamoto wrote:
>
>  int set_binfmt(struct linux_binfmt *new)
>  {
> -	struct linux_binfmt *old = current->binfmt;
> +	struct linux_binfmt *old;
>
> +	if (!current->mm)
> +		return -1;
> +
> +	old = current->mm->binfmt;
>  	if (new) {
>  		if (!try_module_get(new->module))
>  			return -1;
>  	}
> -	current->binfmt = new;
> +	current->mm->binfmt = new;

Hmm. Of-topic, but I think set_binfmt() is buggy (with or without this patch),
it should use __module_get(). I'll send the fix in a minute.

> @@ -1730,7 +1734,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>
>  	audit_core_dumps(signr);
>
> -	binfmt = current->binfmt;
> +	binfmt = current->mm ? current->mm->binfmt : NULL;

current->mm can't be NULL here. And please note we already have
struct mm_struct *mm = current->mm, so the above should be

	 binfmt = mm->binfmt;

> @@ -953,6 +953,9 @@ NORET_TYPE void do_exit(long code)
>  	tsk->exit_code = code;
>  	taskstats_exit(tsk, group_dead);
>
> +	if (tsk->mm && tsk->mm->binfmt)
> +		module_put(tsk->mm->binfmt->module);

This is not right. We leak ->binfmt on exec.

Seems to be fixed by the next patch, but still this is not good.
I'd suggest you to merge these 2 patches into single patch, because
module_put(->binfmt) should go to mmput() from the very beginning.

Oleg.

