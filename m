Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbXJKWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbXJKWMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXJKWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:12:09 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:37357 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbXJKWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hdfpmnPbKRHt1/qhVG+41At8px9UtlT0SEHyCKdLYV1xhso8to3zLWujeS7zMt8pCCxNPfyyYN3ilSFuFUPX5pu3ifBDYsYXtLCmjdJDWl1GMLf0r4mnO415pNFqw5irTUwjIvJD4mSVWe0/db72BcR1Wp3/MwjB2aXBLW+UmW8=
Message-ID: <cfa94dc20710111512j9b6c038qf89c516ecd605411@mail.gmail.com>
Date: Thu, 11 Oct 2007 15:12:05 -0700
From: "Ryan Finnie" <ryan@finnie.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
In-Reply-To: <20071011144740.136b31a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu>
	 <20071011144740.136b31a8.akpm@linux-foundation.org>
X-Google-Sender-Auth: cf4b428906295f05
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> shit.  That's a nasty bug.  Really userspace should be testing for -1, but
> the msync() library function should only ever return 0 or -1.
>
> Does this fix it?
>
> --- a/mm/page-writeback.c~a
> +++ a/mm/page-writeback.c
> @@ -850,8 +850,10 @@ retry:
>
>                         ret = (*writepage)(page, wbc, data);
>
> -                       if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
> +                       if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
>                                 unlock_page(page);
> +                               ret = 0;
> +                       }
>                         if (ret || (--(wbc->nr_to_write) <= 0))
>                                 done = 1;
>                         if (wbc->nonblocking && bdi_write_congested(bdi)) {
> _
>

Pekka Enberg replied with an identical patch a few days ago, but for
some reason the same condition flows up to msync as -1 EIO instead of
AOP_WRITEPAGE_ACTIVATE with that patch applied.  The last part of the
thread is below.  Thanks.

Ryan

On 10/7/07, Ryan Finnie <ryan@finnie.org> wrote:
> On 10/7/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> > On 10/7/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> > > Anyway, some Ubuntu users of Unionfs reported that msync(2) sometimes
> > > returns AOP_WRITEPAGE_ACTIVATE (decimal 524288) back to userland.
> > > Therefore, some user programs fail, esp. if they're written such as
> > > this:
> >
> ...
> > It's a kernel bug. AOP_WRITEPAGE_ACTIVATE is a hint to the VM to avoid
> > writeback of the page in the near future. I wonder if it's enough that we
> > change the return value to zero from
> > mm/page-writeback.c:write_cache_pages() in case we hit AOP_WRITEPAGE_ACTIVE...
>
> Doesn't appear to be enough.  I can't figure out why (since it appears
> write_cache_pages bubbles up directly to sys_msync), but with that
> patch applied, in my test case[1], msync returns -1 EIO.  However,
> with the exact same kernel without that patch applied, msync returns
> 524288 (AOP_WRITEPAGE_ACTIVATE).  But as your patch specifically flips
> 524288 to 0, I can't figure out how it eventually returns  -1 EIO.
>
> Ryan
>
> [1] "apt-get check" on a unionfs2 mount backed by tmpfs over cdrom,
> standard livecd setup
>
