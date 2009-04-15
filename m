Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZDOHvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZDOHvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZDOHvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:51:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55108 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZDOHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:51:31 -0400
Date: Wed, 15 Apr 2009 16:49:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Brice Goglin <Brice.Goglin@ens-lyon.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] migration: only migrate_prep() once per move_pages()
Message-Id: <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49E58D7A.4010708@ens-lyon.org>
References: <49E58D7A.4010708@ens-lyon.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 09:32:10 +0200
Brice Goglin <Brice.Goglin@ens-lyon.org> wrote:

> migrate_prep() is fairly expensive (72us on 16-core barcelona 1.9GHz).
> Commit 3140a2273009c01c27d316f35ab76a37e105fdd8 improved move_pages()
> throughput by breaking it into chunks, but it also made migrate_prep()
> be called once per chunk (every 128pages or so) instead of once per
> move_pages().
> 
> This patch reverts to calling migrate_prep() only once per chunk
> as we did before 2.6.29.
> It is also a followup to commit 0aedadf91a70a11c4a3e7c7d99b21e5528af8d5d
>     mm: move migrate_prep out from under mmap_sem
> 
> This improves migration throughput on the above machine from 600MB/s
> to 750MB/s.
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> 
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I think this patch is good. page migration is best-effort syscall ;)

BTW, current users of sys_move_pages() does retry when it gets -EBUSY ?

Thanks,
-Kame


> diff --git a/mm/migrate.c b/mm/migrate.c
> index 068655d..a2d3e83 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -820,7 +820,6 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
>  	struct page_to_node *pp;
>  	LIST_HEAD(pagelist);
>  
> -	migrate_prep();
>  	down_read(&mm->mmap_sem);
>  
>  	/*
> @@ -907,6 +906,9 @@ static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
>  	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
>  	if (!pm)
>  		goto out;
> +
> +	migrate_prep();
> +
>  	/*
>  	 * Store a chunk of page_to_node array in a page,
>  	 * but keep the last one as a marker
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

