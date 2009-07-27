Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZG0RCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZG0RCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZG0RCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:02:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55501 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbZG0RCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:02:42 -0400
Date: Mon, 27 Jul 2009 18:59:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] task_struct cleanup: move binfmt field to mm_struct
Message-ID: <20090727165901.GA8854@redhat.com>
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com> <20090724161449.GA3509@redhat.com> <4A6CF466.9040608@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6CF466.9040608@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Rusty)

On 07/27, Hiroshi Shimamoto wrote:
>
>  void set_binfmt(struct linux_binfmt *new)
>  {
> -	if (current->binfmt)
> -		module_put(current->binfmt->module);
> +	struct mm_struct *mm = current->mm;
> +
> +	BUG_ON(!mm);
> +	if (mm->binfmt)

I am not sure we need this BUG_ON() above. If mm == NULL we will
have the same debug info after the crash.

> @@ -619,6 +621,9 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
>  	mm->hiwater_rss = get_mm_rss(mm);
>  	mm->hiwater_vm = mm->total_vm;
>
> +	if (mm->binfmt && !try_module_get(mm->binfmt->module))
> +		goto free_pt;

free_pt does mmput() which calls module_put(mm->binfmt->module). This
is not right when try_module_get() fails. Hmm, the same if dup_mmap()
fails, we are doing an extra module_put().

Perhaps we can use __module_get() again, current->mm->binfmt holds a
reference. But this is a user-visible change, currently fork() can't
succeed if ->module->state == MODULE_STATE_GOING.

So I think we need another small change:

	 free_pt:
	+	mm->binfmt = NULL;
	 	mmput(mm);

Oleg.

