Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZLNXJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZLNXJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZLNXJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:09:01 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:34192 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749AbZLNXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=r4XdYA5JDXd16IOV6e/rzHy+jlq99ZQyigr7Ped/uxEk6G+PU1ofgaszfHPdP45kBw
         ukkyNi51+RAN2Kzk5Zg7LK3Bz/fOJHzKxGyJAtmq5/Tec/D1UCtWHohz88+ssIQ+dBjt
         9cCPXcoXFYV3CF3p6HLY+sulZmFaOXDxvDPQo=
Date: Tue, 15 Dec 2009 08:03:28 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 4/8] Use prepare_to_wait_exclusive() instead
 prepare_to_wait()
Message-Id: <20091215080328.b4af59ad.minchan.kim@barrios-desktop>
In-Reply-To: <20091214212936.BBBA.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214212936.BBBA.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:30:19 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> if we don't use exclusive queue, wake_up() function wake _all_ waited
> task. This is simply cpu wasting.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e0cb834..3562a2d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1618,7 +1618,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
>  	 * we would just make things slower.
>  	 */
>  	for (;;) {
> -		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
> +		prepare_to_wait_exclusive(wq, &wait, TASK_UNINTERRUPTIBLE);
>  
>  		if (atomic_read(&zone->concurrent_reclaimers) <=
>  		    max_zone_concurrent_reclaimers)
> @@ -1632,7 +1632,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
>                  */
>  		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
>  					0, 0)) {
> -			wake_up(wq);
> +			wake_up_all(wq);

I think it's typo. The description in changelog says we want "wake_up". 
Otherwise, looks good to me.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
