Return-Path: <linux-kernel-owner+w=401wt.eu-S934296AbZIDVWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296AbZIDVWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934254AbZIDVWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:22:02 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:53343 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934148AbZIDVWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MjH5j9aoj3lXpzYfctMiYfAH+Rxbov4ITcLsqj1xkNZUBOFgDBjHhWMSYSAh1ixTt1
         ZsRssw00S01CcWHJizDFefqCMd323xeI+6dewBlvJ/advNHC8LiVMcw9z7a6KFSfDwK6
         iUhuUKzOMlw5/2FJHdO1u1R7KJBCiKJ8EkDcs=
MIME-Version: 1.0
In-Reply-To: <1252052757.26413.9.camel@pc1117.cambridge.arm.com>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com> 
	<1251962791.3336.3.camel@johannes.local> <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com> 
	<1252001837.9336.2.camel@johannes.local> <20090903204319.GC3701@mosca> 
	<1252040671.9336.10.camel@johannes.local> <1252052757.26413.9.camel@pc1117.cambridge.arm.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 4 Sep 2009 14:21:40 -0700
X-Google-Sender-Auth: 759b833d4662b8d6
Message-ID: <43e72e890909041421m243bbea6i95c26ab21dc8732d@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak 
	reports
To: Catalin Marinas <catalin.marinas@arm.com>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 1:25 AM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> On Fri, 2009-09-04 at 07:04 +0200, Johannes Berg wrote:
>> On Thu, 2009-09-03 at 13:43 -0700, Luis R. Rodriguez wrote:
>> > On Thu, Sep 03, 2009 at 11:17:17AM -0700, Johannes Berg wrote:
>> > > On Thu, 2009-09-03 at 11:13 -0700, Luis R. Rodriguez wrote:
>> > >
>> > > > What I meant is it gobbles it up and spits another thing out. When it
>> > > > gobbles it up the routine then uses kref_put().
>> > > >
>> > > > > Why can it not track this?
>> > > >
>> > > > It probably can, just not sure if it follows kref_put(), I was under
>> > > > the impression here it doesn't and because of it we were getting false
>> > > > positives. Catalin, can you confirm?
>> > >
>> > > Ah I'd think that if it can't track it then that's because we use a
>> > > pointer to the middle of the struct to keep track of it much of the
>> > > time.
>> >
>> > So you agree with the patch but not the commit log entry?
>>
>> I'm not sure -- I think kmemleak should be able to figure it out, and if
>> you were using IBSS then we actually have a leak that we need to plug,
>> but otherwise I'd prefer to get some more input from Catalin first.
>
> First of all, kmemleak_ignore() is not the right function to mark a
> false positive as it completely ignores an object even though it may
> have pointers to others. The kmemleak_not_leak() function should be
> used. However, there are only two places in the kernel where this was
> actually needed (one of them is a real leak but we ignore it as it makes
> the code more complicated).
>
> So, I think we should try to figure out why kmemleak reports it. There
> are a few common cases:
>     1. transient false positive - this should disappear after a few
>        scans
>     2. a pointer leading to the reported object is stored in an area of
>        memory not scanned by kmemleak - most commonly pages allocated
>        explicitly (alloc_pages etc.) as kmemleak doesn't track these.
>        The preferred solution is to inform kmemleak about such page
>        (kmemleak_alloc/kmemleak_free) rather than marking the false
>        positive
>     3. a pointer leading to the reported object isn't actually pointing
>        to anywhere inside the structure (i.e. using the physical
>        address). Here we would use kmemleak_not_leak()

John please revert this merged patch
(b563f91105758c35d7cd4589992198b9da52d579) on wireless-testing as we'd
like to investigate further why we get this.

BTW I should not I got this kmemleak report after using the clear
command by painting objects black. I'll test it now with your
suggested changes.

  Luis
