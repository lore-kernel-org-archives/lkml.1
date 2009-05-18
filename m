Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZERDfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZERDfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZERDfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:35:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:10580 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZERDfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GdLQl2Q5J+Tq3AA7RVpWUwcYK5LHZDNIsx0OWK6AhgRTTg3BgI7sVrltDSQmyVZvRq
         Oe3dl3ln9s/bUUY1MgpWE7agKaEsbMylD0iDzIihz2xcajriiaRt4W9Fc12l5lPFXPPB
         iWtADV8svdNOQpJprzqyGj3xF5vrPXCTGCqwk=
MIME-Version: 1.0
In-Reply-To: <20090518031536.GC5869@localhost>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com>
	 <20090513120606.587C.A69D9226@jp.fujitsu.com>
	 <20090518031536.GC5869@localhost>
Date: Mon, 18 May 2009 12:35:31 +0900
X-Google-Sender-Auth: 95132ddfe4fd3bd0
Message-ID: <2f11576a0905172035k3f26b8d6r84af555a94b1d70e@mail.gmail.com>
Subject: Re: [PATCH 1/4] vmscan: change the number of the unmapped files in 
	zone reclaim
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2397,6 +2397,7 @@ static int __zone_reclaim(struct zone *z
>>               .isolate_pages = isolate_pages_global,
>>       };
>>       unsigned long slab_reclaimable;
>> +     long nr_unmapped_file_pages;
>>
>>       disable_swap_token();
>>       cond_resched();
>> @@ -2409,9 +2410,11 @@ static int __zone_reclaim(struct zone *z
>>       reclaim_state.reclaimed_slab = 0;
>>       p->reclaim_state = &reclaim_state;
>>
>> -     if (zone_page_state(zone, NR_FILE_PAGES) -
>> -             zone_page_state(zone, NR_FILE_MAPPED) >
>> -             zone->min_unmapped_pages) {
>> +     nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
>> +                              zone_page_state(zone, NR_ACTIVE_FILE) -
>> +                              zone_page_state(zone, NR_FILE_MAPPED);
>
> This can possibly go negative.

Is this a problem?
negative value mean almost pages are mapped. Thus

  (nr_unmapped_file_pages > zone->min_unmapped_pages)  => 0

is ok, I think.

>
>> +     if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
>>               /*
>>                * Free memory by calling shrink zone with increasing
>>                * priorities until we have enough memory freed.
