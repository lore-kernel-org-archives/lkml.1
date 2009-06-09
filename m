Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZFIKA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZFIKA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZFIKAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:00:19 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:56304 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZFIKAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HHOr1XukdM0SV00/BSLi2ElgPlS/gw+xeUjYD3s4EyyJREa2xSWr4RkQpFXPOLckZe
         zQDOQgccK8/B8JT0xbTMzCR+tU3BHykwQwBQAMycIljhMFo6AGgVBgqhNc2rr2IgG0ZD
         QvJKlCzvuxE3MKYB5Z0NIiPxNSo+XJ/G50iiQ=
MIME-Version: 1.0
In-Reply-To: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 9 Jun 2009 19:00:20 +0900
Message-ID: <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n59A6M54019451

On Tue, Jun 9, 2009 at 6:15 PM, KAMEZAWAHiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>>> In lumpty reclaim, "cursor_page" is found just by pfn. Then, we don't know> from which LRU "cursor" page came from. Then, putback it to "src" list is BUG.> Just leave it as it is.> (And I think rotate here is overkilling even if "src" is correct.)>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>> ---> Â mm/vmscan.c | Â  Â 5 ++---> Â 1 file changed, 2 insertions(+), 3 deletions(-)>> Index: mmotm-2.6.30-Jun4/mm/vmscan.c> ===================================================================> --- mmotm-2.6.30-Jun4.orig/mm/vmscan.c> +++ mmotm-2.6.30-Jun4/mm/vmscan.c> @@ -940,10 +940,9 @@ static unsigned long isolate_lru_pages(u> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â nr_taken++;> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â scan++;> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â break;> -> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â case -EBUSY:
We can remove case -EBUSY itself, too.It is meaningless.
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  /* else it is being freed elsewhere */> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  list_move(&cursor_page->lru, src);> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  /* Do nothing because we don't know where> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â cusrsor_page comes from */> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â default:> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â break; Â /* ! on LRU or wrong list */
Hmm.. what meaning of this break ?We are in switch case.This "break" can't go out of loop.But comment said "abort this block scan".
If I understand it properly , don't we add goto phrase ?
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â }>> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at Â http://vger.kernel.org/majordomo-info.html> Please read the FAQ at Â http://www.tux.org/lkml/>


-- Kinds regards,Minchan Kimÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
