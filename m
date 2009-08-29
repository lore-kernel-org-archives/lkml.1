Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbZH2KIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbZH2KIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZH2KIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:08:53 -0400
Received: from mail-yw0-f186.google.com ([209.85.211.186]:46718 "EHLO
	mail-yw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZH2KIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:08:52 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Aug 2009 06:08:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V6CA6sfSDHqRh+i/XhKj17h/XZbMNGFY5DggfrJgKWPNNMPQQYgeWJgZodqkg6ENFx
         7KYvdkZXbsJ604NIEC30yoBIkZlQStwgvz6z5O+SRMO7ifj+Q2N1Ecqf+jjnJ9S64nWD
         s9r1OLe0BztLU8mMJ4xwIUbnaQqb6Ez/bvJb8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
References: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
Date: Sat, 29 Aug 2009 19:00:47 +0900
X-Google-Sender-Auth: f5e2b9aae9cda40b
Message-ID: <2f11576a0908290300h155596e1y730c355ade7a671e@mail.gmail.com>
Subject: Re: [PATCH mmotm] vmscan move pgdeactivate modification to 
	shrink_active_list fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh

2009/8/29 Hugh Dickins <hugh.dickins@tiscali.co.uk>:
> mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even
> quicker than last time: one bug fixed but another bug introduced.
> vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
> forgot to add NR_LRU_BASE to lru index to make zone_page_state index.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Can I use your test case?
Currently LRU_BASE is 0. it mean

LRU_BASE == NR_INACTIVE_ANON == 0
LRU_ACTIVE == NR_ACTIVE_ANON == 1

Therefore, I doubt there are another issue in current mmotm.
Can I join your strange oom fixing works?


> ---
>
>  mm/vmscan.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> --- mmotm/mm/vmscan.c   2009-08-28 10:07:57.000000000 +0100
> +++ linux/mm/vmscan.c   2009-08-28 18:30:33.000000000 +0100
> @@ -1381,8 +1381,10 @@ static void shrink_active_list(unsigned
>        reclaim_stat->recent_rotated[file] += nr_rotated;
>        __count_vm_events(PGDEACTIVATE, nr_deactivated);
>        __mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
> -       __mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE, nr_rotated);
> -       __mod_zone_page_state(zone, LRU_BASE + file * LRU_FILE, nr_deactivated);
> +       __mod_zone_page_state(zone, NR_ACTIVE_ANON + file * LRU_FILE,
> +                                                       nr_rotated);
> +       __mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
> +                                                       nr_deactivated);
>        spin_unlock_irq(&zone->lru_lock);
>  }
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
