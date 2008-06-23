Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbYFWSPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbYFWSPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761616AbYFWSPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:15:15 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:3865 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761518AbYFWSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ajFBhITe0fzrrMXlD1WZVrSz5KDmhlRzCxNNKDg4X+Eybx1LqTNja48U0B09ytS1Uc
         Nrwa1NgGBQmAf9MHbUmoHrtpGCiNVt+Ll4WKlejbTLFPbkHiu70VvrX8XCt/5Bu2a5mT
         3ajidKanG4z3mlm/0LUks5C+cY6hBvfJZKtis=
Message-ID: <b6a2187b0806231115t55bf58cfgdc27a2d265258aab@mail.gmail.com>
Date: Tue, 24 Jun 2008 02:15:06 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages() and fix XIP
Cc: "Hugh Dickins" <hugh@veritas.com>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Nick Piggin" <npiggin@suse.de>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Roland McGrath" <roland@redhat.com>
In-Reply-To: <alpine.LFD.1.10.0806231022300.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622185327.348377223@mini.kroah.org>
	 <20080622190140.GD20141@suse.de>
	 <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>
	 <20080622202950.GB20800@suse.de>
	 <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com>
	 <Pine.LNX.4.64.0806231650190.13651@blonde.site>
	 <alpine.LFD.1.10.0806230928140.2926@woody.linux-foundation.org>
	 <b6a2187b0806231005x44b69918q111e865938c55e7@mail.gmail.com>
	 <alpine.LFD.1.10.0806231022300.2926@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 1:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> On the other hand, if you add a trace to the "use_zero_page()" function to
> print out the vm_flags and other details, that probably would help.

Let me know if you still want me to test this.

> That said, since the previous patch _did_ work, I bet that one that does
> both VM_LOCKED and VM_SHARED works too. There was a reason I wanted > to do that VM_SHARED test. I think the VM_SHARED test is sane, unlike the
> VM_LOCKED test (that is a fairly dubious hack for mlock).
> So here's the final version. I bet it works.

Yeh, it works great! Thank you.

Jeff.

>  mm/memory.c |   23 +++++++++++++++++++++--
>  1 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9aefaae..423e0e7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1045,6 +1045,26 @@ no_page_table:
>        return page;
>  }
>
> +/* Can we do the FOLL_ANON optimization? */
> +static inline int use_zero_page(struct vm_area_struct *vma)
> +{
> +       /*
> +        * We don't want to optimize FOLL_ANON for make_pages_present()
> +        * when it tries to page in a VM_LOCKED region. As to VM_SHARED,
> +        * we want to get the page from the page tables to make sure
> +        * that we serialize and update with any other user of that
> +        * mapping.
> +        */
> +       if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
> +               return 0;
> +       /*
> +        * And if we have a fault or a nopfn routine, it's not an
> +        * anonymous region.
> +        */
> +       return !vma->vm_ops ||
> +               (!vma->vm_ops->fault && !vma->vm_ops->nopfn);
> +}
> +
>  int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                unsigned long start, int len, int write, int force,
>                struct page **pages, struct vm_area_struct **vmas)
> @@ -1119,8 +1139,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
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
