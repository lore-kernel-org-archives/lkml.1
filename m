Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab0COA2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:28:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0COA2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GBXxhZGdDGD0x5A0Lo+l175IBlN8y0JZWHaKBGFhNOT9IYpHgyY82afaquqjFS6u1z
         1+XPBM/0xCpDwI+k/G2Ti353VRFNXCWZAelQEaeeDXoiNOCc6roowiB3WzGqYyxDwgUa
         CKESJog2unxviowYtnCZuCrpmLijmu4tOfTy0=
MIME-Version: 1.0
In-Reply-To: <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
Date: Mon, 15 Mar 2010 09:28:08 +0900
Message-ID: <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
	anonymous pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mel.
On Sat, Mar 13, 2010 at 1:41 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> rmap_walk_anon() was triggering errors in memory compaction that looks like
> use-after-free errors in anon_vma. The problem appears to be that between
> the page being isolated from the LRU and rcu_read_lock() being taken, the
> mapcount of the page dropped to 0 and the anon_vma was freed. This patch
> skips the migration of anon pages that are not mapped by anyone.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---
>  mm/migrate.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 98eaaf2..3c491e3 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -602,6 +602,16 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>         * just care Anon page here.
>         */
>        if (PageAnon(page)) {
> +               /*
> +                * If the page has no mappings any more, just bail. An
> +                * unmapped anon page is likely to be freed soon but worse,
> +                * it's possible its anon_vma disappeared between when
> +                * the page was isolated and when we reached here while
> +                * the RCU lock was not held
> +                */
> +               if (!page_mapcount(page))

As looking code about mapcount of page, I got confused.
I think mapcount of page is protected by pte lock.
But I can't find pte lock in unmap_and_move.
If I am right, what protects race between this condition check and
rcu_read_lock?
This patch makes race window very small but It can't remove race totally.

I think I am missing something.
Pz, point me out. :)


> +                       goto uncharge;
> +
>                rcu_read_lock();
>                rcu_locked = 1;
>                anon_vma = page_anon_vma(page);
> --
> 1.6.5
>




-- 
Kind regards,
Minchan Kim
