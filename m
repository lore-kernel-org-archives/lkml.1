Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYKQGja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYKQGja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYKQGjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:39:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:36697 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYKQGjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nT1n1L5tRFvay6G7DqQh3LT65TnV0wQvZe4cK1z3oNg2Y5eeqdmifAFfLZ/VTIOH9y
         s6itDyJDKsb/LWaOl2I5wWe7tShopSp7+U2J/451O5xT8cBFj8JI6MEgENCBdSjOD0I7
         PJ9btq3OIlubB+NV8LfWrWylfSMVhEK6y2weI=
Message-ID: <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com>
Date: Mon, 17 Nov 2008 15:39:20 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081115210039.537f59f5.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
	 <49208E9A.5080801@redhat.com>
	 <20081116204720.1b8cbe18.akpm@linux-foundation.org>
	 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: 79ca25468a67fe7c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/17 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> On Sun, 16 Nov 2008 20:47:20 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Sun, 16 Nov 2008 16:20:26 -0500 Rik van Riel <riel@redhat.com> wrote:
>> Anyway, we need to do something.
>>
>> Shouldn't get_scan_ratio() be handling this case already?
>>
> Hmm, could I make a question ?
>
> I think
>
>  - recent_rolated[LRU_FILE] is incremented when file cache is moved from
>    ACTIVE_FILE to INACTIVE_FILE.
>  - recent_scanned[LRU_FILE] is sum of scanning numbers on INACTIVE/ACTIVE list
>    of file.
>  - file caches are added to INACITVE_FILE, at first.
>  - get_scan_ratio() calculates %file to be
>
>                         file        recent rotated.
>   %file = IO_cost * ------------ / -------------
>                      anon + file    recent scanned.

rewote by div to mul changing.


                        file               recent scanned.
  %file = IO_cost * ------------ * -------------
                     anon + file       recent rotated.


> But when "files are used by streaming or some touch once application",
> there is no rotation because they are in INACTIVE FILE at first add_to_lru().
> But recent_rotated will not increase while recent_scanned goes bigger and bigger.

Yup.

> Then %file goes to 0 rapidly.

I think reverse.

The problem is, when streaming access started right after, recent
scanned isn't so much.
then %file don't reach 100%.

then, few anon pages swaped out althouth memory pressure isn't so heavy.
