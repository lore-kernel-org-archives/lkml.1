Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZHZVnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZHZVnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZHZVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:43:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbZHZVnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:43:06 -0400
Message-ID: <4A95AE06.305@redhat.com>
Date: Thu, 27 Aug 2009 00:49:58 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
References: <20090825145832.GP14722@random.random> <20090825152217.GQ14722@random.random> <Pine.LNX.4.64.0908251836050.30372@sister.anvils> <20090825181019.GT14722@random.random> <Pine.LNX.4.64.0908251958170.5871@sister.anvils> <20090825194530.GU14722@random.random> <Pine.LNX.4.64.0908261910530.15622@sister.anvils> <20090826194444.GB14722@random.random> <Pine.LNX.4.64.0908262048270.21188@sister.anvils> <4A95A10C.5040008@redhat.com> <20090826211400.GE14722@random.random>
In-Reply-To: <20090826211400.GE14722@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Wed, Aug 26, 2009 at 11:54:36PM +0300, Izik Eidus wrote:
>   
>> But before getting into this, why is it so important to break the ksm 
>> pages when madvise(UNMERGEABLE) get called?
>>     
>
> The moment ksm pages are swappable, there's no apparent reason why
> anybody should ask the kernel to break any ksm page if the application
> themselfs aren't writing to them in the first place (triggering
> copy-on-write in app context which already handles TIF_MEMDIE just
> fine).
>   

I think I am the one that should be blamed for breaking the ksm pages 
when running unmeregable (If I remember right),
but I think Hugh had a good case why we want to keep it... ? (If I 
remember right again...)

> In oom deadlock terms madvise(UNMERGEABLE) is the only place that is
> 100% fine at breaking KSM pages, because it runs with right tsk->mm
> and page allocation will notice TIF_MEMDIE set on tsk.
>
> If we remove "echo 2" only remaining "unsafe" spot is the break_cow in
> kksmd context when memcmp fails and similar during the scan.
>
>   
I didnt talk here about the bug..., I talked about the behavior...
It is the feeling that the oom will kill applications calling into 
UNMERGEABLE, even thought this application shouldn't die, just because 
it had big amount of memory shared and it unmerged it in the wrong time?...

But probably this thoughts have no end, and we are better stick with 
something practical that can work clean and simple...

So what I think is this:
echo 2 is something we want in this version beacuse we dont support 
swapping of the shared pages, so we got to allow some how to break the 
pages...

and echo 2 got to have UNMERGEABLE break the shared pages when its 
madvise get called...

So maybe it is just better to leave it like that?
>> When thinking about it, lets say I want to use ksm to scan 2 
>> applications and merged their STATIC identical data, and then i want to 
>> stop scanning them after i know ksm merged the pages, as soon as i will 
>> try to unregister this 2 applications ksm will unmerge the pages, so we 
>> dont allow such thing for the user (we can tell him ofcurse for such 
>> case to use normal way of sharing, so this isnt a really strong case for 
>> this)
>>     
>
> For the app it will be tricky to know when the pages are merged
> though, right now it could only wait a "while"... so I don't really
> see madvise(UNMERGEABLE) as useful regardless how we implement
> it... but then this goes beyond the scope of this bug because as said
> madvise(UNMERGEABLE) is the only place that breaks ksm pages as safe
> as regular write fault in oom context because of it running in the
> process context (not echo 2 or kksmd context).
>   
Yea, I agree about that this case was idiotic :), Actually I thought 
about case where application get little bit more info, but leave it, it 
is not worth it, traditional sharing is much better for such cases.
