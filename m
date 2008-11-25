Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYKYKth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYKYKth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYKYKt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:49:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYKYKt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:49:27 -0500
Message-ID: <492BD807.4000002@redhat.com>
Date: Tue, 25 Nov 2008 12:48:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: suparna@in.ibm.com
CC: Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       Jeff Moyer <jmoyer@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: kvm aio wishlist
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com>
In-Reply-To: <20081125101923.GA28123@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suparna Bhattacharya wrote:
>> Why not extend io_submit() to use a thread pool when going through a 
>> non-aio-ready path?  Yet a new interface, with another round of integrating 
>> to the previous interfaces, is not a comforting thought.  I still haven't 
>> got used to the fact that aio can work with fd polling.
>>     
>
> Even paths that provide fop->aio_read/write can be synchronous (like non
> O_DIRECT filesystem read/writes) underneath, and then there could be multiple
> blocking points.
>   

If they are known to be synchronous when execution starts, they could 
just return -ENOSYS and fall back to threads, until someone implements a 
truly async path.

> BTW, Ben had implemented a fallback approach that spawned kernel threads
> - it was an initial patch and didn't do any thread pooling at that time.
>
> I had a fallback path for pollable fds which did not require thread pools
> http://lwn.net/Articles/216443/ 
> (limited to fds which support non blocking semantics)
>   

These are good solutions for the complex-blocking and never blocking cases.

> OR
>
> Maybe we could use a very simple version of syslets to do an io_submit
> in libaio :) 
>
> Does the syslet approach of continuing in a different thread (different
> thread id) affect kvm ?
>   

Yes, we like to pthread_kill() threads from time to time, and even 
expose the thread IDs to management tools so they can control pinning.

Perhaps a variant of syslet, that is kernel-only, and does:

- always allocate a new kernel stack at io_submit() time, but not a new 
thread
- start executing the rarely-blocking path of the request (like block 
mapping and get_users_pages_fast) on the new stack
- if we block here, clone a new thread and graft the stack onto it
- start the always-blocking portion of the call (enqueuing a bio)
- exit the new thead if we hit the slowpath, or deallocate the stack and 
longjmp back to the main stack if we did not

This does not expose any new semantics to userspace.  It does twist the 
guts of the kernel in that we have to duplicate thread_info, but if 
thread_info is only accessed from current, I think that is managable.

(I think I just described fibrils, no?  I think that was a good idea.  
Why can't we go back to it?)

-- 
error compiling committee.c: too many arguments to function

