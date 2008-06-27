Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYF0FIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYF0FIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYF0FIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:08:11 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:17779 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYF0FIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=an6yCWwcnDGeptuDhoO5udGwlD24noAshHG/FM/pFRRyvhOBAdFjBvoeKzugIfJHm8
         BkUJ5ni2m7tjWZr+L6j+naC/qkGTLmk7cSCYCugfVL1iczrYV5xrfiY09kEaobdUaGLw
         wqcMgnJFStVdmIHevSUXaXZgxRQ9Sldo8LfIU=
Message-ID: <28c262360806262208i6791d67at446f7323ded16206@mail.gmail.com>
Date: Fri, 27 Jun 2008 14:08:08 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 8/10] fix shmem page migration incorrectness on memcgroup
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Rik van Riel" <riel@redhat.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080625190750.D864.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080625190750.D864.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, KAMEZAWA-san.

I have one question.
It's just curious.

On Wed, Jun 25, 2008 at 7:09 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> =
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> mem_cgroup_uncharge() against old page is done after radix-tree-replacement.
> And there were special handling to ingore swap-cache page. But, shmem can
> be swap-cache and file-cache at the same time. Chekcing PageSwapCache() is
> not correct here. Check PageAnon() instead.

When/How shmem can be both swap-cache and file-cache ?
I can't understand that situation.

Thanks. :)

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> ---
>  mm/migrate.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> Index: b/mm/migrate.c
> ===================================================================
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -332,7 +332,13 @@ static int migrate_page_move_mapping(str
>        __inc_zone_page_state(newpage, NR_FILE_PAGES);
>
>        spin_unlock_irq(&mapping->tree_lock);
> -       if (!PageSwapCache(newpage))
> +
> +       /*
> +        * The page is removed from radix-tree implicitly.
> +        * We uncharge it here but swap cache of anonymous page should be
> +        * uncharged by mem_cgroup_ucharge_page().
> +        */
> +       if (!PageAnon(newpage))
>                mem_cgroup_uncharge_cache_page(page);
>
>        return 0;
> @@ -381,7 +387,8 @@ static void migrate_page_copy(struct pag
>                /*
>                 * SwapCache is removed implicitly. Uncharge against swapcache
>                 * should be called after ClearPageSwapCache() because
> -                * mem_cgroup_uncharge_page checks the flag.
> +                * mem_cgroup_uncharge_page checks the flag. shmem's swap cache
> +                * is uncharged before here.
>                 */
>                mem_cgroup_uncharge_page(page);
>        }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
