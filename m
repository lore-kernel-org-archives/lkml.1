Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbYAJQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbYAJQxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYAJQxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:53:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbYAJQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:53:03 -0500
Message-ID: <47864D69.40209@redhat.com>
Date: Thu, 10 Jan 2008 11:52:57 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071018)
MIME-Version: 1.0
To: Anton Salikhmetov <salikhmetov@gmail.com>
CC: Rik van Riel <riel@redhat.com>, Jakob Oestergaard <jakob@unthought.net>,
       Valdis.Kletnieks@vt.edu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in
 msync()
References: <1199728459.26463.11.camel@codedot>	 <20080109170633.292644dc@cuia.boston.redhat.com>	 <20080109223340.GH25527@unthought.net>	 <20080109184141.287189b8@bree.surriel.com>	 <4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>	 <20080110085120.GK25527@unthought.net>	 <4df4ef0c0801100253m6c08e4a3t917959c030533f80@mail.gmail.com>	 <20080110104543.398baf5c@bree.surriel.com>	 <4df4ef0c0801100756v2a536cc5xa80d9d1cfdae073a@mail.gmail.com>	 <20080110110757.09ec494a@bree.surriel.com> <4df4ef0c0801100840uf84fef6g80e456fc5681193@mail.gmail.com>
In-Reply-To: <4df4ef0c0801100840uf84fef6g80e456fc5681193@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Salikhmetov wrote:
> 2008/1/10, Rik van Riel <riel@redhat.com>:
>   
>> On Thu, 10 Jan 2008 18:56:07 +0300
>> "Anton Salikhmetov" <salikhmetov@gmail.com> wrote:
>>
>>     
>>> However, I don't see how they will work if there has been
>>> something like a sync(2) done after the mmap'd region is
>>> modified and the msync call.  When the inode is written out
>>> as part of the sync process, I_DIRTY_PAGES will be cleared,
>>> thus causing a miss in this code.
>>>
>>> The I_DIRTY_PAGES check here is good, but I think that there
>>> needs to be some code elsewhere too, to catch the case where
>>> I_DIRTY_PAGES is being cleared, but the time fields still need
>>> to be updated.
>>>       
>> Agreed. The mtime and ctime should probably also be updated
>> when I_DIRTY_PAGES is cleared.
>>
>> The alternative would be to remember that the inode had been
>> dirty in the past, and have the mtime and ctime updated on
>> msync or close - which would be more complex.
>>     
>
> Adding the new flag (AS_MCTIME) has been already suggested by Peter
> Staubach in his first solution for this bug. Now I understand that the
> AS_MCTIME flag is required for fixing the bug.

Well, that was the approach before we had I_DIRTY_PAGES.  I am
still wondering whether we can get this approach to work, with
a little more support and heuristics.  PeterZ's work to better
track dirty pages should be helpful in determining when and why
a patch was dirty.

I keep thinking that by recording the time when a page was found
to be dirty and the file is mmap'd and then updating the mtime
and ctime fields in the inode during msync() and sync_single_inode()
if that time is newer than the mtime and ctime fields, then we
can solve the problem of when and when not to update those two
time fields.

I haven't had a chance to think it all through completely or do
the appropriate analysis yet though.

       ps
