Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZLBOZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZLBOZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZLBOZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:25:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49812 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZLBOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:25:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uoAyiwKARJS6Am4m49+/LIstp6R3pPIsQX36WXxSRUmr4ZNKUwkIQYwOkIXg7tG0Oj
         vpwF123a1C5Nh9UXKZCQyG4ftaIuyAKuI7rs2c538hcij9D/uWQebXLZ9v7yeqI0Lk5k
         6NA9azOFcP65RHeXzxXy5UAzcAOPRvZrwgtIk=
MIME-Version: 1.0
In-Reply-To: <20091202122019.GD1457@csn.ul.ie>
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie>
	 <200912012253.08522.rjw@sisk.pl> <4B16545B.3090703@tuffmail.co.uk>
	 <20091202122019.GD1457@csn.ul.ie>
Date: Wed, 2 Dec 2009 14:25:27 +0000
Message-ID: <9b2b86520912020625j31d180a1t1bc2a9b13a9d988d@mail.gmail.com>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/09, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, Dec 02, 2009 at 11:49:47AM +0000, Alan Jenkins wrote:
>> Rafael J. Wysocki wrote:
>>> On Tuesday 01 December 2009, Mel Gorman wrote:
>>>
>>>> On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
>>>>
>>>>> Hi
>>>>>
>>>>> Suspend to disk is (sometimes) hanging for me in 2.6.32-rc.  I
>>>>> finally  got around to bisecting it, which blamed the following
>>>>> commit by Mel:
>>>>>
>>>>> 5f8dcc2 "page-allocator: split per-cpu list into
>>>>> one-list-per-migrate-type"
>>>>>
>>>>> I was able to confirm this by reverting the commit, which fixed the
>>>>>  hang.  I had to revert one other commit first to avoid a conflict:
>>>>>
>>>>> a6f9edd "page-allocator: maintain rolling count of pages to free
>>>>> from  the PCP"
>>>>>
>>>>>
>>>> Which RC kernel? Specifically, are the commits
>>>>
>>>> cc4a6851466039a8a688c843962a05689059ff3b always wake kswapd when
>>>> restarting an allocation attempt
>>>> 9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 Do not allow interrupts to use
>>>> ALLOC_HARDER
>>>>
>>>> applied?
>>>>
>>>> The latter one in particular might make a difference if s2disk is
>>>> pushing the system far below the watermarks. I don't suppose you know
>>>> where it's hanging? i.e. is it hanging in the allocator itself?
>>>>
>>>> If those patches are applied, then one difference that 5f8dcc2 makes is
>>>> that pages on the PCP lists but not of the right migratetype are not
>>>> used. Prior to that commit, an allocation might succeed even if the
>>>> buddy lists were empty because one of the other PCP page types would be
>>>> used.
>>>>
>>>>
>>>>> -- detail --
>>>>>
>>>>> When I suspend my EeePc 701 to disk, it sometimes hangs after
>>>>> writing  out the hibernation image.  The system is still able to
>>>>> resume from this  image (after working around the hang by pressing
>>>>> the power button).
>>>>>
>>>>> This is specific to s2disk from the uswsusp package (which is now
>>>>> installed by default on debian unstable).  It doesn't happen if I
>>>>> uninstall uswsusp and use the in-kernel suspend instead.
>>>>>
>>>>>
>>>> This leads me to believe that uswsusp is able to push available pages
>>>> far below what is expected. It's a total guess though, I have no idea
>>>> how uswsusp is implemented or how it differs from what is in kernel.
>>>>
>>>
>>> It doesn't differ at all in that respect.  Actually, it uses the same
>>> code, but
>>> the distro configuration may be such that it leaves fewer available pages
>>> than the default in-kernel hibernation.
>>>
>>> Thanks,
>>> Rafael
>>>
>>
>> It seems unintuitive that lack of memory is a problem _after we've
>> written out the hibernation image_.  The backtrace I captured shows the
>> hang happens within hibernation_platform_enter()...
>>
>
> I think the backtrace is also showing that it's trying to create a kernel
> thread. For this to be getting locked up, memory must be exceptionally
> tight. One thing that the patch changes is that in certain circumstances,
> an additional 128K of memory per-CPU could be on each the PCP lists.
>
> Ordinarily it doesn't matter because reclaim would resolve the situation
> or the PCP lists would be drained very shortly after. However, if the
> CPUs were no longer being used but still have pages pinned, it could be
> causing a problem.
>
>> Hmm.  Doesn't the in-kernel suspend free the in-memory image before
>> powering off?
>>
>> int hibernate(void)
>> ...
>>        pr_debug("PM: writing image.\n");
>>        error = swsusp_write(flags);
>>        swsusp_free();
>>        if (!error)
>>            power_down();
>>
>>
>>
>> Would that explain why only uswsusp is affected?  Do we want to fix
>> snapshot_read() in user.c, so that it calls swsusp_free() once all the
>> data has been read?
>>
>
> Could you try it please?

Yes, that fixes it.  I left it running over lunch, and it did 24
hibernations cycles without hanging.  I'll post it and we'll see what
Rafael thinks.  It's only four lines of code, and I think there's a
strong case for it.

> Another possibility would be to call drain_all_pages() before powering
> off. If that makes a difference, it would confirm that pages are pinned
> on PCP lists of inactive processors.

Probably not, since this is a single processor machine :).  It's the
original EeePC model with a Celeron processor, no fancy dual cores or
hyperthreading.

Thanks
Alan
