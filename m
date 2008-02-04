Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYBDSoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYBDSoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYBDSn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:43:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYBDSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:43:56 -0500
Message-ID: <47A75CCF.4090904@redhat.com>
Date: Mon, 04 Feb 2008 13:43:27 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] enhanced syscall ESTALE error handling (v2)
References: <4790C768.4080207@redhat.com> <47A387D4.70605@redhat.com> <E1JL3a0-0006H7-U3@pomaz-ex.szeredi.hu> <47A39471.4010105@redhat.com> <E1JL3yn-0006KQ-AS@pomaz-ex.szeredi.hu> <47A39D8F.9010003@redhat.com> <E1JLDIq-000747-1y@pomaz-ex.szeredi.hu> <47A73558.2080700@redhat.com> <E1JM5Gh-0003Pi-Dq@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JM5Gh-0003Pi-Dq@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>>> In FUSE interrupts are sent to userspace, and the filesystem decides
>>> what to do with them.  So it is entirely possible and valid for a
>>> filesystem to ignore an interrupt.  If an operation was non-blocking
>>> (such as one returning an error), then there would in fact be no
>>> purpose in checking interrupts.
>>>
>>>   
>>>       
>> Why do you think that it is valid to ignore pending signals?
>> You seem to be asserting that it okay for processes to hang,
>> uninterruptibly, when accessing files on fuse mounted file
>> systems?
>>
>> Perhaps the right error to return when there is a signal
>> pending is EINTR and not ESTALE or some other error?  There
>> has to be some way for the application to detect that its
>> system call was interrupted due to a signal pending.
>>     
>
> Traditionally a lot of filesystem related system calls are not
> interruptible, and for good reason.  For example what happens, if an
> app receives a signal, while the filesystem is performing a rename()
> request?  It would be very confusing if the call returned EINTR, but
> the rename would successfully complete regardless.
>
> We had a related problem with the open(O_CREAT) call in fuse, which
> was interruptible between the creation and the actual open because of
> a design mistake.  So it could return EINTR, after the file was
> created, and this broke a real world application (don't have details
> at hand, but could dig them out if you are interested).
>
> I don't know what NFS does, but returning EINTR without actually
> canceling an operation in the server is generally not a good idea.
>
>   

This is what NFS has been doing, for several decades, and no one
has complained yet.  It is just generally accepted.  I do agree
that it isn't the best of semantics, but it does seem to work and
does solve a real problem which exists if you don't allow an
operation to be interrupted.  The alternative, for NFS clients,
was potentially to block an application until a server, which
might never come back up, comes back up.  It was a serious
problem and worse than this resolution.

Yes, I'd like to hear the details and find out why it was a
problem.  If you allow the fuse file system to block waiting
on things which may never occur, than you are going to have a
problem.  I would suggest considering this now instead of waiting
until it is too late.  We can learn from the NFS experience instead
of just dismissing it.


>>> So while sending a signal might reliably work in NFS to break out of
>>> the loop, it does not necessarily work for other filesystems, and fuse
>>> may not be the only one affected.
>>>
>>>   
>>>       
>> Have you noticed another one?  I would be happy to chat with the
>> developers for that file system to see if this support would
>> negatively impact them.
>>     
>
> Oh, I have no idea.  And I wouldn't want to do a full audit of all the
> filesystems to find out.  But if you do, please go ahead.
>
>   

Well, you brought it up.  I thought that perhaps you had something
other than FUD.

>>> A few solutions come to mind, perhaps the best is to introduce a
>>> kernel internal errno value (ERETRYSTALE), that forces the relevant
>>> system calls to be retried.
>>>
>>> NFS could transform ESTALE errors to ERETRYSTALE and get the desired
>>> behavior, while other filesystems would not be affected.
>>>       
>> We don't need more error numbers, we've got plenty already.  :-)
>>     
>
> That's a rather poor excuse against a simple solution which would
> spare us some backward compatibility problems.
>
>   

Potential backwards compatibility problems and none are even known
or even considered.

The solution here isn't to create more hacks and a new error number
for this purpose is just a hack.

>> Do you have anything more specific about any real problems?
>> I see lots of "mays" and "coulds", but I don't see anything
>> that I can do to make this support better.
>>     
>
> Implement the above suggestion?  Or something else.
>
> Otherwise I have to NAK this patch due to the possibility of it
> breaking existing fuse installations.

Please describe this real and existing fuse installation so that I can
better understand the situation and the real requirements here.

Instead of attempting to block this proposal, what about considering
how to architect fuse to handle the situation instead of pretending
that fuse won't have the same problem to solve if it isn't solved
here?  I have a real problem to solve and I need to get it resolved.
I have real customers, with real problems, and not just theoretical
and vague ones.

          ps
