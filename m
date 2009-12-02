Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZLBLtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZLBLtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZLBLtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:49:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59036 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZLBLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:49:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i3f1hO2a8Xw49Qnr/7AK6/DMEoepmxWlpc6Tl9PQNyE/EhikQaekkMd4F42mIp6jFf
         OyKshGaQDFEn+mzwVmNnn6t+GJMR823Y1xipQn6Xtj77Xjp24V8FgMy9WuCjMS5+WtEr
         HBxu+PpSo24Kr0w0xpHUC5xH28qq5HXGZHzNw=
Message-ID: <4B16545B.3090703@tuffmail.co.uk>
Date: Wed, 02 Dec 2009 11:49:47 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mel Gorman <mel@csn.ul.ie>, pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie> <200912012253.08522.rjw@sisk.pl>
In-Reply-To: <200912012253.08522.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 01 December 2009, Mel Gorman wrote:
>   
>> On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
>>     
>>> Hi
>>>
>>> Suspend to disk is (sometimes) hanging for me in 2.6.32-rc.  I finally  
>>> got around to bisecting it, which blamed the following commit by Mel:
>>>
>>> 5f8dcc2 "page-allocator: split per-cpu list into one-list-per-migrate-type"
>>>
>>> I was able to confirm this by reverting the commit, which fixed the  
>>> hang.  I had to revert one other commit first to avoid a conflict:
>>>
>>> a6f9edd "page-allocator: maintain rolling count of pages to free from  
>>> the PCP"
>>>
>>>       
>> Which RC kernel? Specifically, are the commits
>>
>> cc4a6851466039a8a688c843962a05689059ff3b always wake kswapd when restarting an allocation attempt
>> 9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 Do not allow interrupts to use ALLOC_HARDER
>>
>> applied?
>>
>> The latter one in particular might make a difference if s2disk is
>> pushing the system far below the watermarks. I don't suppose you know
>> where it's hanging? i.e. is it hanging in the allocator itself?
>>
>> If those patches are applied, then one difference that 5f8dcc2 makes is
>> that pages on the PCP lists but not of the right migratetype are not
>> used. Prior to that commit, an allocation might succeed even if the
>> buddy lists were empty because one of the other PCP page types would be
>> used.
>>
>>     
>>> -- detail --
>>>
>>> When I suspend my EeePc 701 to disk, it sometimes hangs after writing  
>>> out the hibernation image.  The system is still able to resume from this  
>>> image (after working around the hang by pressing the power button). 
>>>
>>> This is specific to s2disk from the uswsusp package (which is now  
>>> installed by default on debian unstable).  It doesn't happen if I  
>>> uninstall uswsusp and use the in-kernel suspend instead.
>>>
>>>       
>> This leads me to believe that uswsusp is able to push available pages
>> far below what is expected. It's a total guess though, I have no idea
>> how uswsusp is implemented or how it differs from what is in kernel.
>>     
>
> It doesn't differ at all in that respect.  Actually, it uses the same code, but
> the distro configuration may be such that it leaves fewer available pages
> than the default in-kernel hibernation.
>
> Thanks,
> Rafael
>   

It seems unintuitive that lack of memory is a problem _after we've 
written out the hibernation image_.  The backtrace I captured shows the 
hang happens within hibernation_platform_enter()...

Hmm.  Doesn't the in-kernel suspend free the in-memory image before 
powering off?

int hibernate(void)
...
        pr_debug("PM: writing image.\n");
        error = swsusp_write(flags);
        swsusp_free();
        if (!error)
            power_down();



Would that explain why only uswsusp is affected?  Do we want to fix 
snapshot_read() in user.c, so that it calls swsusp_free() once all the 
data has been read?

Regards
Alan
