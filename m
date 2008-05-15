Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYEOGYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYEOGYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYEOGYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:24:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:7485 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYEOGYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Mboy4aE/0VuZZjzHBZ+mcZA1eL3KO5CYfDD3y4ZO/j3S99fyT6iv4ihTA7hgw8JLkaCxMzA7cZgorE9F+AiiA5Etdoy6BZBgLTYDJ/KqQdK4TAcYxGZ5XTp/NntVOTkAHZRdWDZP+k2G0q47PindKvoINYatwIpfkHia7pX6GZU=
Message-ID: <386072610805142324v45e1687fi8d50bae03b9f6586@mail.gmail.com>
Date: Thu, 15 May 2008 14:24:12 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Subject: Re: [PATCH 3/4] [mm/nommu]: use copy_to_user_page to call flush icache for [#811] toolchain old bug
Cc: "Jie Zhang" <jie.zhang@analog.com>, "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <1210588325-11027-4-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	 <1210588325-11027-4-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: f1a3cb5e1dcf9cc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this patch OK for the nommu, David?

Thanks
-Bryan

On Mon, May 12, 2008 at 6:32 PM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Jie Zhang <jie.zhang@analog.com>
>
> access_process_vm in mm/memory.c uses copy_to_user_page and
> copy_from_user_page. So for !MMU we'd better do the same thing.
> Other archs with mmu do the cache flush in copy_to_user_page.
> It gives me hint that copy_to_user_page is designed to flush
> the cache. On other side, no archs do the cache flush ptrace.
>
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  mm/nommu.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index c11e5cc..56bb447 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1458,9 +1458,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>
>                /* only read or write mappings where it is permitted */
>                if (write && vma->vm_flags & VM_MAYWRITE)
> -                       len -= copy_to_user((void *) addr, buf, len);
> +                       copy_to_user_page(vma, NULL, NULL,
> +                                         (void *) addr, buf, len);
>                else if (!write && vma->vm_flags & VM_MAYREAD)
> -                       len -= copy_from_user(buf, (void *) addr, len);
> +                       copy_from_user_page(vma, NULL, NULL,
> +                                           buf, (void *) addr, len);
>                else
>                        len = 0;
>        } else {
> --
> 1.5.5
>
>
