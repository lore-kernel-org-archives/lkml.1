Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbXBVULp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbXBVULp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXBVULp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:11:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbXBVULo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:11:44 -0500
Message-ID: <45DDF8F3.2020304@redhat.com>
Date: Thu, 22 Feb 2007 15:11:31 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <45DC8A47.5050900@redhat.com> <E1HJw7l-0003Tq-00@dorka.pomaz.szeredi.hu> <45DC9581.4070909@redhat.com> <E1HJwoe-0003el-00@dorka.pomaz.szeredi.hu> <45DDD498.9050202@redhat.com> <E1HKIUk-0006Sl-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HKIUk-0006Sl-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>>>>>>> +int set_page_dirty_mapping(struct page *page);
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> This aspect of the design seems intrusive to me.  I didn't see a strong
>>>>>> reason to introduce new versions of many of the routines just to handle
>>>>>> these semantics.  What motivated this part of your design?  Why the new
>>>>>> _mapping versions of routines?
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> Because there's no way to know inside the set_page_dirty() functions
>>>>> if the dirtying comes from a memory mapping or from a modification
>>>>> through a normal write().  And they have different semantics, for
>>>>> write() the modification times are updated immediately.
>>>>>       
>>>>>           
>>>> Perhaps I didn't understand what page_mapped() does, but it does seem to
>>>> have the right semantics as far as I could see.
>>>>     
>>>>         
>>> The problems will start, when you have a file that is both mapped and
>>> modified with write().  Then the dirying from the write() will set the
>>> flag, and that will have undesirable consequences.
>>>       
>> I don't think that I quite follow the logic.  The dirtying from write()
>> will set the flag, but then the mtime will get updated and the flag will
>> be cleared by the hook in file_update_time().  Right?
>>     
>
> Take this example:
>
>     fd = open()
>     addr = mmap(.., fd)
>     write(fd, ...)
>     close(fd)
>     sleep(100)
>     msync(addr,...)
>     munmap(addr)
>
> The file times will be updated in write(), but with your patch, the
> bit in the mapping will also be set.
>
> Then in msync() the file times will be updated again, which is wrong,
> since the memory was _not_ modified through the mapping.

This is correct.  I have updated my proposed patch to include the clearing
of AS_MCTIME in the routine which updates the mtime field.  I haven't
reposted it yet until I complete testing of the new resulting system.  I
anticipate doing this later today.

    Thanx..

       ps
