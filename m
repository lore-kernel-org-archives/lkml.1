Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZFKRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZFKRTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZFKRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:19:28 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51044 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFKRT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fB1V58xNrutIlJDAmurJR/H1Z8LesmpYpdCXLbCLlu9tjn9I2kwTEprNx/XdhRP5mn
         EyrY3uKjf3vyRxXf7bg/3BqXVv8sh8zNJGduIN0sgk6ZgR2agjZ7O/a+JwSoYxL4L4d4
         ol6MKhrCWsJg244R/1qR5PkWsRS6nE76Zw6ds=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0906111512400.3372@localhost.localdomain>
References: <20090611112746.802a24cb.sfr@canb.auug.org.au>
	 <20090611102927.GE12431@alberich.amd.com>
	 <alpine.LFD.2.00.0906111512400.3372@localhost.localdomain>
Date: Thu, 11 Jun 2009 10:19:28 -0700
Message-ID: <86802c440906111019o5829933fnfffcea5cd0e3c862@mail.gmail.com>
Subject: Re: [PATCH] x86: memtest: fix compile warning
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 7:21 AM, Thomas Gleixner<tglx@linutronix.de> wrote:
> On Thu, 11 Jun 2009, Andreas Herrmann wrote:
>
>> Commit c9690998ef48ffefeccb91c70a7739eebdea57f9
>> (x86: memtest: remove 64-bit division) introduced following compile warning:
>>
>>  arch/x86/mm/memtest.c: In function 'memtest':
>>  arch/x86/mm/memtest.c:56: warning: comparison of distinct pointer types lacks a cast
>>  arch/x86/mm/memtest.c:58: warning: comparison of distinct pointer types lacks a cast
>>
>> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>> ---
>>  arch/x86/mm/memtest.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> Sorry.
>> Please apply.
>
> I applied it already, but zapped it right away, as it is bad style to
> do the type casting in the loops. The proper fix is below.
>
> But aside of that this code is confusing.
>
>        start_phys_aligned = ALIGN(start_phys, incr);
>
> Why do we have to fiddle with the alignment. Are you really seing e820
> entries which are not 8 byte aligned ?
>
>        for (p = start; p < end; p++, start_phys_aligned += incr) {
>                if (*p == pattern)
>                        continue;
>                if (start_phys_aligned == last_bad + incr) {
>                        last_bad += incr;
>                        continue;
>                }
>                if (start_bad)
>                        reserve_bad_mem(pattern, start_bad, last_bad + incr);
>                start_bad = last_bad = start_phys_aligned;
>        }
>        if (start_bad)
>                reserve_bad_mem(pattern, start_bad, last_bad + incr);
>
> I really had to look more than once to understand what the heck
> start_phys_aligned and last_bad + incr are doing. Really non
> intuitive.
>
> But the reserve_bad_mem() semantics are even more scary:
>
> - if you hit flaky memory, which gives you bad and good results here
>  and there, you call reserve_bad_mem() totally unbound which is
>  likely to overflow the early reservation space and panics the
>  machine. You need to keep track of those events somehow (e.g. in a
>  bitmap) so you can detect such problems and mark the whole affected
>  region bad in one go.
if one pass found bad, it is reserved.
second pass will use find_e820_area_size() to get new range, so bad
one will not be used.
>
> - you call reserve_early() which calls __reserve_early(....,
>  overrun_ok = 0) so if you do the default multi pattern scan and each
>  run sees the same region of broken memory you will trigger the
>  "Overlapping early reservations" panic in __reserve_early() when you
>  reserve that region the second time. Why do you run the test twice
>  when the first one failed already ? Also there is no need to do the
>  wipeout run in that case, which will trigger it as well!

current problem in that: we could run out of res_reserve array.
solution will be make res_reserve array dynamically.
  when can not find slot, need use find_e820_area to get double sized,
and copy the old to new one.
  then free the old one.

YH
