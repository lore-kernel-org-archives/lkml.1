Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXCATuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXCATuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXCATuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:50:11 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:43796 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965537AbXCATuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=k5SKFfvlZhYq1NaOHFrpEpthbCcDu8Wp8sx6exBlU8/yguFr3mDQek5bV3VUky0CgT8HFvRgnkXF5DRoyYk3utfo27nc0r4Vtf6JyRTZdwwXp+G5cC1KvP9K5N+ca25n/0gbgBElSRVuSm+4D+UZoAQXmxAgWVjRgjvID3KM2fo=
Message-ID: <e9c3a7c20703011150h68d99cedx433112afbd8dc88b@mail.gmail.com>
Date: Thu, 1 Mar 2007 12:50:06 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2 and 2.6.20)
Cc: "Frank Seidel" <linux@f-seidel.de>, linux-kernel@vger.kernel.org,
       NeilBrown <neilb@suse.de>
In-Reply-To: <20070301123057.GO23985@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com>
	 <200703011308.28266.linux@f-seidel.de>
	 <20070301123057.GO23985@kernel.dk>
X-Google-Sender-Auth: 86ec8a7c3ee398b4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Mar 01 2007, Frank Seidel wrote:
> > Am Mittwoch, 28. Februar 2007 19:02 schrieb Dan Williams:
> > > I can reliably reproduce a null pointer dereference on 2.6.20 and
> > > 2.6.21-rc2.  I will keep digging to find the kernel version where
> > > this last worked, but wanted to see if there were any immediate
> > > experiments I should try.
> > > ...
> > > Kernel 2.6.21-rc2 on an i686
> > > ...
> > > [  431.709022] BUG: unable to handle kernel NULL pointer dereference
> > > at virtual address 0000005c [  431.717993]  printing eip:
> > > ...
> > > [  431.825386] EIP is at cfq_dispatch_insert+0xb/0x53
> > > ...
> > > [  431.887396]  [<c01e1fc9>] cfq_dispatch_requests+0x138/0x3f0
> > Hi,
> > unfortunately i yet don't really have much/enough knowledge of cfq and
> > the kernels inwards at the moment...
> > but looking at cfq_dispatch_insert+0xb it seems the struct request
> > pointer given (as second parameter by cfq_dispatch_request) was NULL
> > and dereferencing it in the RQ_CFQQ macro leads to this oops.
> >
> > The "break"-out patch below for __cfq_dispatch_request might be at least
> > a possible workaround for this, but it could also be total bullsh..
> > Perhaps someone smarter might pick this up.. and give a real fix.
> >
> > Have fun,
> > Frank
> > ---
> >
> >  block/cfq-iosched.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6/block/cfq-iosched.c
> > ===================================================================
> > --- linux-2.6.orig/block/cfq-iosched.c
> > +++ linux-2.6/block/cfq-iosched.c
> > @@ -962,7 +962,8 @@ __cfq_dispatch_requests(struct cfq_data
> >                  * follow expired path, else get first next available
> >                  */
> >                 if ((rq = cfq_check_fifo(cfqq)) == NULL)
> > -                       rq = cfqq->next_rq;
> > +                       if ((rq = cfqq->next_rq) == NULL)
> > +                               break;
> >
> >                 /*
> >                  * finally, insert request into driver dispatch list
>
> That is not the right fix. A little further up in this function, a check
> (well BUG_ON()) is done for a non-empty sort list. So we know at this
> point, that we have requests pending for this queue. When that is the
> case, ->next_rq must always be kept uptodate and non-NULL. The oops at
> least tells us this, it should not be papered around. The real fix is
> finding out _where_ this now isn't being updated.
>
> I'm puzzled why this is hitting Dan, but no one else has reported
> anything. Dan, did 2.6.19 work for you?
>
I am puzzled as well, although I do not think many people run raid6
arrays with 2-failed disks, so it might be an under-tested path, but a
non-degraded array runs fine...

I fired up a 2.6.19 kernel and tiobench ran past the point (in terms
of time) where it had failed on .20 and .21-rc.  However I noticed
things were running much slower since the cpu optimizations had fallen
back to Pentium-Pro from Core2 which affects the raid6 p+q calculation
speed among other things.  So I need to re-baseline the failure
against a more common config to say whether it is actually gone in
2.6.19.

I should have time to try these tests next week.

> --
> Jens Axboe

Regards,
Dan
