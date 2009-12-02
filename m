Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZLBMUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZLBMUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZLBMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:20:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58253 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLBMUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:20:17 -0500
Date: Wed, 2 Dec 2009 12:20:19 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
Message-ID: <20091202122019.GD1457@csn.ul.ie>
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie> <200912012253.08522.rjw@sisk.pl> <4B16545B.3090703@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B16545B.3090703@tuffmail.co.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:49:47AM +0000, Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
>> On Tuesday 01 December 2009, Mel Gorman wrote:
>>   
>>> On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
>>>     
>>>> Hi
>>>>
>>>> Suspend to disk is (sometimes) hanging for me in 2.6.32-rc.  I 
>>>> finally  got around to bisecting it, which blamed the following 
>>>> commit by Mel:
>>>>
>>>> 5f8dcc2 "page-allocator: split per-cpu list into one-list-per-migrate-type"
>>>>
>>>> I was able to confirm this by reverting the commit, which fixed the 
>>>>  hang.  I had to revert one other commit first to avoid a conflict:
>>>>
>>>> a6f9edd "page-allocator: maintain rolling count of pages to free 
>>>> from  the PCP"
>>>>
>>>>       
>>> Which RC kernel? Specifically, are the commits
>>>
>>> cc4a6851466039a8a688c843962a05689059ff3b always wake kswapd when restarting an allocation attempt
>>> 9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 Do not allow interrupts to use ALLOC_HARDER
>>>
>>> applied?
>>>
>>> The latter one in particular might make a difference if s2disk is
>>> pushing the system far below the watermarks. I don't suppose you know
>>> where it's hanging? i.e. is it hanging in the allocator itself?
>>>
>>> If those patches are applied, then one difference that 5f8dcc2 makes is
>>> that pages on the PCP lists but not of the right migratetype are not
>>> used. Prior to that commit, an allocation might succeed even if the
>>> buddy lists were empty because one of the other PCP page types would be
>>> used.
>>>
>>>     
>>>> -- detail --
>>>>
>>>> When I suspend my EeePc 701 to disk, it sometimes hangs after 
>>>> writing  out the hibernation image.  The system is still able to 
>>>> resume from this  image (after working around the hang by pressing 
>>>> the power button). 
>>>>
>>>> This is specific to s2disk from the uswsusp package (which is now   
>>>> installed by default on debian unstable).  It doesn't happen if I   
>>>> uninstall uswsusp and use the in-kernel suspend instead.
>>>>
>>>>       
>>> This leads me to believe that uswsusp is able to push available pages
>>> far below what is expected. It's a total guess though, I have no idea
>>> how uswsusp is implemented or how it differs from what is in kernel.
>>>     
>>
>> It doesn't differ at all in that respect.  Actually, it uses the same code, but
>> the distro configuration may be such that it leaves fewer available pages
>> than the default in-kernel hibernation.
>>
>> Thanks,
>> Rafael
>>   
>
> It seems unintuitive that lack of memory is a problem _after we've  
> written out the hibernation image_.  The backtrace I captured shows the  
> hang happens within hibernation_platform_enter()...
>

I think the backtrace is also showing that it's trying to create a kernel
thread. For this to be getting locked up, memory must be exceptionally
tight. One thing that the patch changes is that in certain circumstances,
an additional 128K of memory per-CPU could be on each the PCP lists.

Ordinarily it doesn't matter because reclaim would resolve the situation
or the PCP lists would be drained very shortly after. However, if the
CPUs were no longer being used but still have pages pinned, it could be
causing a problem.

> Hmm.  Doesn't the in-kernel suspend free the in-memory image before  
> powering off?
>
> int hibernate(void)
> ...
>        pr_debug("PM: writing image.\n");
>        error = swsusp_write(flags);
>        swsusp_free();
>        if (!error)
>            power_down();
>
>
>
> Would that explain why only uswsusp is affected?  Do we want to fix  
> snapshot_read() in user.c, so that it calls swsusp_free() once all the  
> data has been read?
>

Could you try it please?

Another possibility would be to call drain_all_pages() before powering
off. If that makes a difference, it would confirm that pages are pinned
on PCP lists of inactive processors.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
