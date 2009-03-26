Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZCZLZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZCZLZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZCZLZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:25:37 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:4469 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751294AbZCZLZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:25:36 -0400
Message-ID: <49CB65CB.1030905@panasas.com>
Date: Thu, 26 Mar 2009 13:23:55 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-4-git-send-email-tj@kernel.org> <49CA4B4B.50408@panasas.com> <49CAE425.5050009@kernel.org> <49CB31DB.2040608@gmail.com> <49CB3765.4070406@panasas.com> <49CB387A.3000006@panasas.com> <49CB56AD.3080101@gmail.com>
In-Reply-To: <49CB56AD.3080101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 11:25:33.0772 (UTC) FILETIME=[93FDC0C0:01C9AE05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2009 12:19 PM, Tejun Heo wrote:
> Boaz Harrosh wrote:
>> On 03/26/2009 10:05 AM, Boaz Harrosh wrote:
>>> On 03/26/2009 09:42 AM, Tejun Heo wrote:
>>>> The thing is that the prealloc variant should be allowed to be called
>>>> from IRQ context and blk_queue_bounce() shouldn't be called.
>>>> Hmmm... well, the caller is supposed to know what it's doing and maybe
>>>> we can just add a comment that it shouldn't be called with buffers
>>>> which might get bounced from IRQ context.
>>>>
>>> Hmm that is a problem. I would suggest a flag or a check. My bios come
>>> from VFS they need bouncing.
>>>
>>> Can you think of a solution?
>>>
>>> We could just call blk_queue_bounce(). IRQ callers need to make sure their
>>> buffers don't need bouncing anyway, so there is no such bug right? If a programmer
>>> gets it wrong he will get a BUG check that tells him that.
>>>
>> I just realized that in your original call you had the "force" flag,
>> we can keep that flag for the blk_rq_set_bio(), or what ever we
>> should name it.
> 
> Eh...  Currently, fs requests are built from bio whereas PC/kernel
> requests are usually mapped into the requset the driver already
> allocated, so there are two different directions of initiaializing a
> request.
> 
> For the latter, the APIs are blk_rq_map_{user[_iov]|kern}().  To add
> to the fun, we have blk_rq_map_sg() which does a completely different
> thing of mapping an rq's bios to sg and is usually called from low
> level do_request() when starting to process a request.
> 

Lets just remove for a moment blk_rq_map_sg() from the discussion.
That one is totally bogus name that gives me the crips every time
I read its name. If using the same terminology then at minimum it should have
been blk_sg_map_request() (Which I agree is even more cryptic but at least
it gets the source-destination right).

> You're suggesting to add blk_rq_map_bio() which doesn't really map
> anything but rather allocates and initializes an rq from bio and
> basically boils down to blk_rq_bio_prep() and blk_queue_bounce().
> 

Yes, as I said, I completely agree. It does not map anything and
should not be named blk_rq_map_. It should have a different better
name. Hell it exists today, as blk_rq_append_bio(), but that one
suggests usage in ways some people don't like, and they want to
remove it. My opinion is that: Both me and you could just use the
good old blk_rq_append_bio() and be happy.

So basically in practice it just comes down to renaming
blk_rq_append_bio() to something. We both just don't know how to call
it?

> I think it's about time to cool it a bit and try to see what's going
> on.  We don't really want blk_rq_map_*() to do three completely
> different things, right?  Usage of blk_rq_map_{user[_iov]|kern}()
> isn't too wide spread, so cleaning up the API shouldn't be difficult.
> 

Currently blk_rq_map_sg() is the only odd ball, renaming that to something
sane will fix the current situation.

What additionally we both want is just plain old blk_rq_append_bio and
maybe with a better name?

> So, let's think about the whole API.
> 
> There is fundamental difference between fs and pc requests.  For fs
> requests, rq (struct request) doesn't really matter.  bio is the final
> goal of fs requests and rq is just the carrier of bios into the block
> layer and drivers.  

This is because the one that cares about the request, comes later down
the stack in the form of a block-driver. So an FS_PC command is just a
flag that says: Careful, only half baked request here, someone needs to
fill in the extra information.

At the LLD level there is no difference between an READ_10 issued by
user-mode through sg.c pushing BLOCK_PC, or FS_PC commands from ext3
converted to READ_10 by sd.c on the way down.

I'm saying all that to better explain my answer below.

For pc requests, this isn't true.  Here, bios are
> used as data carrier and the issuer cares much more about the rq
> itself which will be configured to carry the command the issuer wants
> to execute.

BLOCK_PC commands are "protocol specific" and the issuer has all
the needed information up-front. So he needs the mapping, as well
as all the usual prep_fn thing done on the request in one go.

> This is also true for completion too.  For fs requests,
> rq error status doesn't matter.  For pc requests, the other way
> around.

Again a stack thing, The mid-level block-driver will carry status
on req->errors up to when it completes the request where it should
do a translation of it's specific error to a generic VFS error
-EIO, -ENOSPC, -ENOMEM etc. So they are both used only at different
stages of the request life time. Since BLOCK_PC are protocol specific
and they kind of by-pass the block-driver they need the protocol specific
information, just as above when they spoke the language in issuing READ_10

> The difference explains why we have two different
> initialization directions, so to me, the current API seems logical
> although we really should be using different names.
> 
> Can you please explain what your need is?  Why do you want
> blk_make_request()?
> 

I don't need blk_make_request per-se, I just need a way to
allocate a request and then associate a pre built bio with it,
that was prepared by an upper filesystem.

(Which talks OSD, which does not fit the block device model at all,
but this is too much information for you)

Farther more, My life is more complicated then that because, I need
a bidi-request which is second request hanging on the first one. And
each request can map up to 6 segments of source information that
are finally laid linear on the wire. So my bio can not be built
with a single blk_rq_map_xxx call.

To make the story short blk_rq_append_bio() can be used by your
code and mine, perhaps with a better name.

> Thanks.
> 

I feel I took to much of your time with my petty problems, Just
that I felt that if adding an associate-this-request-with-this-bio
API to blkdev.h could be done in a way that makes both of us happy.

Thanks alot
Boaz



