Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629Ab0ABN3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0ABN3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583Ab0ABN3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:29:44 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:36489 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0ABN3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:29:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O95eXhIDcoCHkm4PSbJBgHqXHcTkxkXRGn2+US0GIUHGENhwjdiCAleTnuOodfOQ/C
         a2BbkKeygouYAZgHLbjCT59E4QD/LVJDdLZVcAsYLz3x9v2dHnTVABWQXCGFutHMkUfE
         knuQXJHxTgHew6IZQUG4YqE9BAQTsEoYT3TJg=
MIME-Version: 1.0
In-Reply-To: <1262429166.32223.32.camel@laptop>
References: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
	 <1262387986.16572.234.camel@laptop>
	 <2f11576a1001012121o4f09d30n6dba925e74099da1@mail.gmail.com>
	 <1262429166.32223.32.camel@laptop>
Date: Sat, 2 Jan 2010 22:29:41 +0900
X-Google-Sender-Auth: b4606c0c315618a7
Message-ID: <2f11576a1001020529l729caebawc4364690f1df56cb@mail.gmail.com>
Subject: Re: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim too
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/2 Peter Zijlstra <peterz@infradead.org>:
> On Sat, 2010-01-02 at 14:21 +0900, KOSAKI Motohiro wrote:
>> 2010/1/2 Peter Zijlstra <peterz@infradead.org>:
>> > On Fri, 2010-01-01 at 18:45 +0900, KOSAKI Motohiro wrote:
>> >> Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
>> >> context annotation. But it didn't annotate zone reclaim. This patch do it.
>> >
>> > And yet you didn't CC anyone involved in that patch, nor explain why you
>> > think it necessary, massive FAIL.
>> >
>> > The lockdep annotations cover all of kswapd() and direct reclaim through
>> > __alloc_pages_direct_reclaim(). So why would you need an explicit
>> > annotation in __zone_reclaim()?
>>
>> Thanks CCing. The point is zone-reclaim doesn't use
>> __alloc_pages_direct_reclaim.
>> current call graph is
>>
>> __alloc_pages_nodemask
>>     get_page_from_freelist
>>         zone_reclaim()
>>     __alloc_pages_slowpath
>>         __alloc_pages_direct_reclaim
>>             try_to_free_pages
>>
>> Actually, if zone_reclaim_mode=1, VM never call
>> __alloc_pages_direct_reclaim in usual VM pressure.
>> Thus I think zone-reclaim should be annotated explicitly too.
>> I know almost user don't use zone reclaim mode. but explicit
>> annotation doesn't have any demerit, I think.
>
> Just be aware that the annotation isn't recursive, I'd have to trace all
> calls to __zone_reclaim, but if kswapd were ever to call it you'd just
> wrecked things by getting lockdep_clear_current_reclaim_state() called.
>
> So just make sure you don't shorten the existing notations by adding it
> here. Other than that it seems ok.

Umm, probably I haven't catch your mention. currently kswapd never
call __zone_reclaim() because
kswapd has PF_MEMALLOC and PF_MEMALLOC prevent to call __zone_reclaim
(see zone_reclaim()).

When recursive annotation occur?
