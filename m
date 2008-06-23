Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYFWPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYFWPVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYFWPVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:21:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:15270 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbYFWPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AnLYPyHCLHpqyPGuSYDRQ8eL1qiAVCBJ7xUsfBxZFQkvUg1ziZgKOtzfloV3X3pY/J
         Oum/4X72I3wTQyVxWO04no/RDJu2/4NoT7r31Tn0vgt5iWKXCkeb1cFna9sRDsB+RTKB
         8VjRAt4Vp9VT43+BC8iZF6G3nU5i9+c7iik+s=
Message-ID: <b6a2187b0806230821g6759d6dbo2ec1c7720cf86209@mail.gmail.com>
Date: Mon, 23 Jun 2008 23:21:09 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc7
Cc: ecollins@vmware.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       support@vmware.com
In-Reply-To: <alpine.LFD.1.10.0806221003360.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
	 <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
	 <alpine.LFD.1.10.0806220926150.2926@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0806221003360.2926@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 1:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So assuming it's not the XIP fix, you could try this patch instead. It
> replaces the (insane) use of VM_LOCKED with VM_SHARED (which is a lot more
> meaningful for the case of ZERO_PAGE, but strictly speaking probably
> doesn't matter either), and it teaches it about the fact that
> non-anonymous pages can be populated not just with the "->fault" handler,
> but with "->nopfn" too.
>
> I really don't think it's due to this (nobody sane really uses '->nopfn'),
> but if the XIP disabling patch doesn't make a difference, give it a try.

Linus,

This one fixes the problem! So, it's something strange that VMware is
doing, but anyway, glad you fix it!!!

Thanks for the patch.

Jeff.



> (Most of the patch is obviously the fact that I moved the conditionals
> into a helper inline function to make the dang thing more readable). The
> actual change is trivial.
>
>                Linus
>
> ---
>  mm/memory.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9aefaae..8c5675f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1045,6 +1045,15 @@ no_page_table:
>        return page;
>  }
>
> +/* Can we do the FOLL_ANON optimization? */
> +static inline int use_zero_page(struct vm_area_struct *vma)
> +{
> +       if (vma->vm_flags & VM_SHARED)
> +               return 0;
> +       return !vma->vm_ops ||
> +               (!vma->vm_ops->fault && !vma->vm_ops->nopfn);
> +}
> +
>  int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                unsigned long start, int len, int write, int force,
>                struct page **pages, struct vm_area_struct **vmas)
> @@ -1119,8 +1128,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                foll_flags = FOLL_TOUCH;
>                if (pages)
>                        foll_flags |= FOLL_GET;
> -               if (!write && !(vma->vm_flags & VM_LOCKED) &&
> -                   (!vma->vm_ops || !vma->vm_ops->fault))
> +               if (!write && use_zero_page(vma))
>                        foll_flags |= FOLL_ANON;
>
>                do {
>
