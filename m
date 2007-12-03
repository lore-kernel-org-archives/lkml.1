Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXLCM3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXLCM3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXLCM3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:29:23 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:35669 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXLCM3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:29:22 -0500
Message-ID: <4753F72C.6060202@in.ibm.com>
Date: Mon, 03 Dec 2007 18:01:40 +0530
From: Supriya Kannery <supriyak@in.ibm.com>
Reply-To: supriyak@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: remap_file_pages() broken in 2.6.23?
References: <474F16D3.5060009@redhat.com> <20071129233058.GA10359@wotan.suse.de>
In-Reply-To: <20071129233058.GA10359@wotan.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Nov 29, 2007 at 02:45:23PM -0500, Chuck Ebbert wrote:
>   
>> Original report: https://bugzilla.redhat.com/show_bug.cgi?id=404201
>>
>> The test case below, taken from the LTP test code, prints -1 (as
>> expected) on 2.6.22 and 0 on 2.6.23. It tries to remap an out-of-range
>> page. Proposed patch follows the program. Bug was apparently caused by
>> commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7.
>>     
>
> Ah, that's not such good behaviour anyway. mmap is allowed to map
> outside the file offset, so you're telling me that remap_file_pages
> just magically should not be allowed to remap these...?
>
>   
Validation check for pgoff was there in populate() in earlier 
kernels.When populate() got removed and populate_range() was added, 
during the specified commit, validation for pgoff also got removed. This 
symantic would break existing apps that expects an error from 
remap_file_pages when a large value for pgoff is given. Though the 
change is error handling related, it breaks ABI from previous kernel 
versions.

For validation, we check whether the pgoff + size exceeds the file size, 
all in page units. And while calculating file size in page units, one 
additional page unit is taken into account to get the exact number of 
pages that contain the file size in bytes.
f_size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
<---- file size in bytes -------> <--- helps in rounding to next page 
unit -->

mmap() will be mapping the minimum number of pages that can contain a 
file. So offset cannot be a large value compared to file size. mmap() is 
also supposed to return EINVAL when the offset is a large/invalid value 
as man page mandates.
>   
>> Patch:
>>
>> Signed-off-by: Supriya Kannery <supriyak@in.ibm.com>
>>
>> --- linux-2.6.23/mm/fremap.c.orig	2007-11-22 00:56:09.000000000 -0600
>> +++ linux-2.6.23/mm/fremap.c	2007-11-26 03:08:55.000000000 -0600
>> @@ -124,6 +124,7 @@ asmlinkage long sys_remap_file_pages(uns
>>  	struct vm_area_struct *vma;
>>  	int err = -EINVAL;
>>  	int has_write_lock = 0;
>> +	unsigned long f_size = 0;
>>  
>>  	if (__prot)
>>  		return err;
>> @@ -181,6 +182,14 @@ asmlinkage long sys_remap_file_pages(uns
>>  			goto retry;
>>  		}
>>  		mapping = vma->vm_file->f_mapping;
>> +
>> +		f_size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
>> +		f_size = f_size >> PAGE_CACHE_SHIFT;
>> +		if ((pgoff + size >> PAGE_CACHE_SHIFT) > f_size) {
>> +			err = -EINVAL;
>> +			goto out;
>> +		}
>> +
>>  		/*
>>  		 * page_mkclean doesn't work on nonlinear vmas, so if
>>  		 * dirty pages need to be accounted, emulate with linear
>>     
>
>
> I don't think there is anything preventing truncate races here. Theoretically
> we could do it by taking i_mutex around here, but anyway then a subsequent
> truncate is just going to be able to cause the mapping to be out of bounds
> anyway.
>
>   
i_size_read() is taking care of syncing between the writes/truncations 
in SMP/ pre-emtable kernel. For SMP, it specifically takes care to get 
the value again if any changes happen to the source.
> If it were any other syscall than remap_file_pages, I'd be much more
> hesitant to say this: I propose we change the test case instead. I
> also changed other elements of the API, and we had the result tested
> and verified by Oracle...
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
Thanks, Supriya
Linux Technology Centre.
