Return-Path: <linux-kernel-owner+w=401wt.eu-S1030653AbXCLRF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653AbXCLRF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030704AbXCLRF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:05:29 -0400
Received: from services106.cs.uwaterloo.ca ([129.97.152.164]:56165 "EHLO
	services106.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030653AbXCLRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:05:28 -0400
Date: Mon, 12 Mar 2007 13:05:17 -0400 (EDT)
From: Ashif Harji <asharji@cs.uwaterloo.ca>
To: Jan Kara <jack@suse.cz>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: do_generic_mapping_read performance issue
In-Reply-To: <20070312151355.GB23532@duck.suse.cz>
Message-ID: <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
 <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de>
 <20070312151355.GB23532@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0 (services106.cs.uwaterloo.ca [129.97.152.132]); Mon, 12 Mar 2007 13:05:20 -0400 (EDT)
X-Miltered: at endeis with ID 45F5884F.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 89f4f77c-4fa1-440a-9399-ab0ba6f19634
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 Mar 2007, Jan Kara wrote:

> On Mon 12-03-07 15:39:00, Nick Piggin wrote:
>> On Mon, Mar 12, 2007 at 03:20:12PM +0100, Jan Kara wrote:
>>>   Hi,
>>>
>>>> Hi, I am encountering a performance problem, which I have tracked into the
>>>> Linux kernel. The problem occurs with my experimental web server that uses
>>>> sendfile to repeatedly transmit files.  The files are based on the static
>>>> portion of the SPECweb99 fileset and range in size to model a reasonable
>>>> workload.  With this workload, a significant number of the requests are
>>>> for files of size 4 KB or less.
>>>>
>>>> I have determined that the performance problems occurs in the function
>>>> do_generic_mapping_read in file mm/filemap.c for kernel version 2.6.20.1.
>>>> Here is the specific code fragment:
>>>>
>>>>         /*
>>>>          * When (part of) the same page is read multiple times
>>>>          * in succession, only mark it as accessed the first time.
>>>>          */
>>>>         if (prev_index != index)
>>>>                 mark_page_accessed(page);
>>>   Actually, the code is like that certainly for two years :).
>>
>> Did it always use ra->prev_page? ISTR it using pos%PAGE_SIZE == 0 at some
>> stage (ie. read from the start of a page -- obviously that also has holes).
>  Yes, at least in 2.6.12-rc5 which is the first one in git :).
>
>>>> I was wondering if anyone could explain why the call to mark_page_accessed
>>>> is conditional? That is, what problem it is trying to solve. It would seem
>>>> that in many scenarios, if the same page is accessed repeatedly, then it
>>>> would be appropriate to keep that page cached.
>>>   I also don't know why the condition is there but it's there at least
>>> for two years so I'm not sure anybody remembers ;). Nick, do you have
>>> an idea?
>>
>> Yeah it is there because that is basically how our "use once" detection
>> handles the case where an app does not read in chunks that are PAGE_SIZE
>> multiples and PAGE_SIZE aligned.
>  OK, I see. Then I'm not sure the check does more good than bad. Because
> if we happen to reread the same chunk several times, then the check does a
> wrong thing...

Thanks for providing me with additional information.

I would like to submit a patch to fix the performance problem.  The 
simplest solution is to remove the check.  Even in the situation where an 
application does not read in PAGE_SIZE multiples as described above, if 
the page is accessed frequently it should remain in the cache.  However, I 
am open to suggestions for a more sophisticated scheme.

ashif.
