Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZF1O53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZF1O53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZF1O5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:57:21 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:46240 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZF1O5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=X6RcJuA8W5yV4oKxiiAfrUcU81Z63ugvwe12nbK6rBNefc6copr6k5ZP1Jnr3p/6eG
         JK8VWwvwkUX2lp8IgQkbEBZ4VCM4Y6T2Z3sZeDmN647A0DkvMc1bI/L6IYQZ9S3MLUe+
         lUUS7JkTXAx/SafFFl+c/v102hQab2JzdZrsU=
MIME-Version: 1.0
In-Reply-To: <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com>
References: <3901.1245848839@redhat.com> <32411.1245336412@redhat.com>
	 <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com>
	 <20090618095729.d2f27896.akpm@linux-foundation.org>
	 <7561.1245768237@redhat.com> <26537.1246086769@redhat.com>
	 <20090627125412.GA1667@cmpxchg.org> <20090628113246.GA18409@localhost>
	 <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com>
Date: Sun, 28 Jun 2009 23:49:52 +0900
X-Google-Sender-Auth: 2d0c330c1e219396
Message-ID: <2f11576a0906280749v25ab725dn8f98fbc1d2e5a5fd@mail.gmail.com>
Subject: Re: Found the commit that causes the OOMs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In David's OOM case, there are two symptoms:
>> 1) 70000 unaccounted/leaked pages as found by Andrew
>>   (plus rather big number of PG_buddy and pagetable pages)
>> 2) almost zero active_file/inactive_file; small inactive_anon;
>>   many slab and active_anon pages.
>>
>> In the situation of (2), the slab cache is _under_ scanned. So David
>> got OOM when vmscan should have squeezed some free pages from the slab
>> cache. Which is one important side effect of MinChan's patch?
>
> My patch's side effect is (2).
>
> My guessing is following as.
>
> 1. The number of page scanned in shrink_slab is increased in shrink_page_list.
> And it is doubled for mapped page or swapcache.
> 2. shrink_page_list is called by shrink_inactive_list
> 3. shrink_inactive_list is called by shrink_list
>
> Look at the shrink_list.
> If inactive lru list is low, it always call shrink_active_list not
> shrink_inactive_list in case of anon.
> It means it doesn't increased sc->nr_scanned.
> Then shrink_slab can't shrink enough slab pages.
> So, David OOM have a lot of slab pages and active anon pages.
>
> Does it make sense ?
> If it make sense, we have to change shrink_slab's pressure method.
> What do you think ?

I'm confused.

if system have no swap, get_scan_ratio() always return anon=0%.
Then, the numver of inactive_anon is not effect to sc.nr_scanned.
