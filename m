Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYKYKQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYKYKQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYKYKQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:16:23 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37384 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYKYKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:16:21 -0500
Date: Tue, 25 Nov 2008 15:49:23 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       Jeff Moyer <jmoyer@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: kvm aio wishlist
Message-ID: <20081125101923.GA28123@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492BC5CB.6000609@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[cc'ing lkml as well ] 

On Tue, Nov 25, 2008 at 11:30:51AM +0200, Avi Kivity wrote:
> Zach Brown wrote:
>>> I'm also worried about introducing threads.  With direct I/O, we know
>>> we're going to block.  The easiest thing is to slap the request onto a
>>> queue (blockdev or netdev) and unplug it.
>>>     
>>
>> Is it really that easy?  There's a non-trivial number of places it can
>> block before submitting the IO and making it to the async completion
>> phase.  They show up as latency spikes in real-world loads.
>>
>> DIO is a good example.  Using a kernel thread lets the entire path be
>> async.  We don't have to go in and fold an async state machine under
>> pinning user space pages, performing file system block mapping lookups,
>> allocating block layer requests, on and on.
>>
>>   
>
> Certainly, filesystem backed storage is much harder.  Maybe we can use one 
> of the fork-on-demand proposals to make the block mapping async, then queue 
> the request+pinned pages.
>
>>> IIRC, the idea behind the *lets/*rils was that the calls are usually
>>> nonblocking, so you fork on block, no?  I don't see that here.  Of
>>> course, that's not the case in my wishlist; all requests will block
>>> without exception.
>>>     
>>
>> Yeah.  My thinking is that if someone wants to experiment with syslets
>> it'll be pretty easy for them to add a flag to the submission struct and
>> re-use most of the submission and completion framework.  That's not my
>> priority.  I want posix aio in glibc to work.
>>   
>
> Why not extend io_submit() to use a thread pool when going through a 
> non-aio-ready path?  Yet a new interface, with another round of integrating 
> to the previous interfaces, is not a comforting thought.  I still haven't 
> got used to the fact that aio can work with fd polling.

Even paths that provide fop->aio_read/write can be synchronous (like non
O_DIRECT filesystem read/writes) underneath, and then there could be multiple
blocking points.

BTW, Ben had implemented a fallback approach that spawned kernel threads
- it was an initial patch and didn't do any thread pooling at that time.

I had a fallback path for pollable fds which did not require thread pools
http://lwn.net/Articles/216443/ 
(limited to fds which support non blocking semantics)

OR

Maybe we could use a very simple version of syslets to do an io_submit
in libaio :) 

Does the syslet approach of continuing in a different thread (different
thread id) affect kvm ?

Regards
Suparna

>
>>> Actually without preadv/pwritev (and without changes in qemu; that has
>>> its own wishlist) we can't really make good use of this now.
>>>     
>>
>> I could trivially add preadv and pwritev to the patch series.  The vfs
>> paths already support it, it's just that we don't have a syscall entry
>> point which takes the file position from an argument instead of from the
>> file struct behind the fd.
>>
>> Would that make it an interesting experiment for you to work with?
>>   
>
> Not really -- it doesn't add anything (at the moment) that a userspace 
> thread pool doesn't have.
>
> The key here is in the richer interface to the scheduler.  If we can get 
> the async exec thread to stay on the same cpu as the user thread that 
> launched it, and to start executing on the userspace thread's return to 
> userspace, then I guess many of the problems of threads are eliminated.
>
> -- 
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
