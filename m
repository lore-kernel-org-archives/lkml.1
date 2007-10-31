Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXJaK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXJaK15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXJaK1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:27:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:29134 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbXJaK1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ixyPvp1rdi/D0FD6FWI2xig1U8YXhVk/WYdkBXmFXJ6mbXTIJB3fc1U8CVYhpIW0Y0IokNQfLBAA0sqAUSil4Scn8ls6kn3uCZ1mAc1RhoeVPt5nXLJbCesMQF+WmIUzN+A7kUTfCxvNeOj2fE4r6NqqPwOWd13rlwALMGusGOk=
Message-ID: <e9e943910710310327w189c136ey2c8d893b20e81a83@mail.gmail.com>
Date: Wed, 31 Oct 2007 10:27:47 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
In-Reply-To: <20071031041932.GA12189@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
	 <20071031041932.GA12189@wotan.suse.de>
X-Google-Sender-Auth: 2c8b37b4575dd65e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/2007, Nick Piggin <npiggin@suse.de> wrote:
> Well that's probably the best bug report I've ever had, thanks Duane!

Aw, shucks!

> The issue is a silly thinko -- I didn't pay enough attention to the ptrace
> rules in filemap_fault :( partly I think that's because I don't understand
> them and am scared of them ;)
>
> The following minimal patch fixes it here, and should probably be applied to
> 2.6.23 stable as well as 2.6.24. If you could verify it, that would be much
> appreciated.

I can confirm that it fixes the problem, thanks Nick!

Feel free to add:
Tested-by: Duane Griffin <duaneg@dghda.com>

> However I actually don't really like how this all works. I don't like that
> filemap.c should have to know about ptrace, or exactly what ptrace wants here.
> It's a bit hairy to force insert page into pagecache and pte into pagetables
> here, given the races.
>
> In access_process_vm, can't we just zero fill in the case of a sigbus? Linus?
> That will also avoid changing applicatoin behaviour due to a gdb read...
>
> Thanks,
> Nick
>
> --
> Duane Griffin noticed a 2.6.23 regression that will cause gdb to hang when
> it tries to access the memory of another process beyond i_size.
>
> This is because the solution to the fault vs invalidate race requires that
> we recheck i_size after the page lock is taken. However in that case, I
> had not accounted for the fact that ptracers are granted an exception to this
> rule.
>
> Cc: Duane Griffin <duaneg@dghda.com>
> Cc: stable@kernel.org
> Signed-off-by: Nick Piggin <npiggin@suse.de
> ---
> Index: linux-2.6/mm/filemap.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap.c
> +++ linux-2.6/mm/filemap.c
> @@ -1374,7 +1374,7 @@ retry_find:
>
>         /* Must recheck i_size under page lock */
>         size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> -       if (unlikely(vmf->pgoff >= size)) {
> +       if (unlikely(vmf->pgoff >= size) && vma->vm_mm == current->mm) {
>                 unlock_page(page);
>                 page_cache_release(page);
>                 goto outside_data_content;
>

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
