Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYIIJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYIIJWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYIIJWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:22:11 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:20998 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYIIJWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jxJBAjUeapyIZUC5nyVgvb46bInkvfDnphv61KVuFQMYhobMluKOIqCGIjZYRZIOVj
         dqJceIzNLIx33yDspiK6YLjEkHjqCzc1GTHwsYU2m3XPle839S0BlrVUHfKO2jbNeH1n
         yepq8qB34bNo2CIAbWacAsybt02XDGf+NndJo=
Message-ID: <19f34abd0809090222u68e90c74l514cd0b50a290d4b@mail.gmail.com>
Date: Tue, 9 Sep 2008 11:22:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Oren Laadan" <orenl@cs.columbia.edu>
Subject: Re: [RFC v4][PATCH 4/9] Memory management (dump)
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 9:42 AM, Oren Laadan <orenl@cs.columbia.edu> wrote:
> For each VMA, there is a 'struct cr_vma'; if the VMA is file-mapped,
> it will be followed by the file name.  The cr_vma->npages will tell
> how many pages were dumped for this VMA.  Then it will be followed
> by the actual data: first a dump of the addresses of all dumped
> pages (npages entries) followed by a dump of the contents of all
> dumped pages (npages pages). Then will come the next VMA and so on.
>
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
> ---
>  arch/x86/mm/checkpoint.c   |   30 +++
>  arch/x86/mm/restart.c      |    1 +
>  checkpoint/Makefile        |    3 +-
>  checkpoint/checkpoint.c    |   53 ++++++
>  checkpoint/ckpt_arch.h     |    1 +
>  checkpoint/ckpt_mem.c      |  448 ++++++++++++++++++++++++++++++++++++++++++++
>  checkpoint/ckpt_mem.h      |   35 ++++
>  checkpoint/sys.c           |   23 ++-
>  include/asm-x86/ckpt_hdr.h |    5 +
>  include/linux/ckpt.h       |   12 ++
>  include/linux/ckpt_hdr.h   |   30 +++
>  11 files changed, 635 insertions(+), 6 deletions(-)
>  create mode 100644 checkpoint/ckpt_mem.c
>  create mode 100644 checkpoint/ckpt_mem.h
>
> diff --git a/arch/x86/mm/checkpoint.c b/arch/x86/mm/checkpoint.c
> index 71d21e6..50cfd29 100644
> --- a/arch/x86/mm/checkpoint.c
> +++ b/arch/x86/mm/checkpoint.c
> @@ -192,3 +192,33 @@ int cr_write_cpu(struct cr_ctx *ctx, struct task_struct *t)
>        cr_hbuf_put(ctx, sizeof(*hh));
>        return ret;
>  }
> +
> +/* dump the mm->context state */
> +int cr_write_mm_context(struct cr_ctx *ctx, struct mm_struct *mm, int parent)
> +{
> +       struct cr_hdr h;
> +       struct cr_hdr_mm_context *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +       int ret;
> +
> +       h.type = CR_HDR_MM_CONTEXT;
> +       h.len = sizeof(*hh);
> +       h.parent = parent;
> +
> +       mutex_lock(&mm->context.lock);
> +
> +       hh->ldt_entry_size = LDT_ENTRY_SIZE;
> +       hh->nldt = mm->context.size;
> +
> +       cr_debug("nldt %d\n", hh->nldt);
> +
> +       ret = cr_write_obj(ctx, &h, hh);
> +       cr_hbuf_put(ctx, sizeof(*hh));
> +       if (ret < 0)
> +               return ret;

mutex_unlock(&mm->context.lock) before return, I think?

> +
> +       ret = cr_kwrite(ctx, mm->context.ldt, hh->nldt * LDT_ENTRY_SIZE);
> +
> +       mutex_unlock(&mm->context.lock);
> +
> +       return ret;
> +}


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
