Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZLBLfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZLBLfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLBLfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:35:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58525 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZLBLfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GYFL/aI2DGPB8vD7tz3sC1Prt1otUmc0qWu21c8VbIyIW9TiOE+BrK2Em3oL/zlilC
         ey6TRW8AJOtkSolhX430Y2QYvkK0Y2CpOuWjObaDlZKjoiqMCrSKfve8ODpS1tC+bVzA
         wOXPU6cM5/MJ9yfYXDa5b0/TPKUQzFHPJzYEI=
Message-ID: <4B1650E9.3070302@tuffmail.co.uk>
Date: Wed, 02 Dec 2009 11:35:05 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie> <4B162BE1.7070709@tuffmail.co.uk> <20091202103538.GB1457@csn.ul.ie>
In-Reply-To: <20091202103538.GB1457@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Wed, Dec 02, 2009 at 08:57:05AM +0000, Alan Jenkins wrote:
>   
>> Mel Gorman wrote:
>>     
>>> On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
>>>   
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
>>>> hang.  I had to revert one other commit first to avoid a conflict:
>>>>
>>>> a6f9edd "page-allocator: maintain rolling count of pages to free from 
>>>>  the PCP"
>>>>
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
>>>       
>>>> -- detail --
>>>>
>>>> When I suspend my EeePc 701 to disk, it sometimes hangs after writing 
>>>>  out the hibernation image.  The system is still able to resume from 
>>>> this  image (after working around the hang by pressing the power 
>>>> button). 
>>>>
>>>> This is specific to s2disk from the uswsusp package (which is now   
>>>> installed by default on debian unstable).  It doesn't happen if I   
>>>> uninstall uswsusp and use the in-kernel suspend instead.
>>>>
>>>>     
>>>>         
>>> This leads me to believe that uswsusp is able to push available pages
>>> far below what is expected. It's a total guess though, I have no idea
>>> how uswsusp is implemented or how it differs from what is in kernel.
>>>
>>>   
>>>       
>>>> The hang doesn't happen if I boot with "init=/bin/bash" and run 
>>>> s2disk.   Nor does it happen if I boot normally, then switch to 
>>>> single user mode  ("telinit 12").
>>>>
>>>> It only happens if I've logged in to KDE.  In the past, this has   
>>>> indicated a problem in a network driver, since NetworkManager only 
>>>> made  a connection once I logged in.  But it still hangs if I remove 
>>>> both  ath5k and atl2 before I log into KDE.  (I actually tried 
>>>> removing as  many modules as possible: atl2, ath5k, usbcore, 
>>>> snd-hda-intel, psmouse,  pcspkr, battery, ac, themal, fan, and 
>>>> eeepc-laptop).  Perhaps it's  something to do with the size of the 
>>>> hibernation image.
>>>>
>>>>     
>>>>         
>>> I believe you are correct in that it's something to do with the size of
>>> the hibernation image and how close to the edge the kernel gets pushed
>>> as a result.
>>>
>>> Please confirm first that the two commits I mentioned above are in your
>>> kernel. If not, would you mind trying the following patch?
>>> Unfortunately, it's totally untested. The intention of the patch is to
>>> use other PCP lists if the desired one cannot be refilled.
>>>
>>> Thanks.
>>>   
>>>       
>> The hang happens on 2.6.32-rc8, which includes the two commits above.
>>
>>     
>
> Ok, that was somewhat expected as they only had an impact if there was a
> storm of interrupts which was unlikely in this case. How about the
> additional patch?
>   

The patch doesn't help.  I still see the same hang (and the hung task 
backtraces look the same as before).

Thanks
Alan
