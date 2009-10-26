Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZJZNUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZJZNUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZJZNUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:20:55 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:55009 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbZJZNUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UZ/DJEzEebcGyH6pV2qd7nwgiBcDivUIBxD9sXmdS2rvVt41DPvOVvTPW/hVHa3KUj
         OxJ0LAxLwa1148BPA/ZddG6+11UsGD3dnGl6kc3OhmpVHdgbFxJXow6f1OROnftmS1Ng
         NhiWyrM/IvJ7C5yDHBf8CxfdkZK9K7Jh+k4X8=
MIME-Version: 1.0
In-Reply-To: <20091026114011.GD10727@kernel.dk>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
	 <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
	 <20091026114011.GD10727@kernel.dk>
Date: Mon, 26 Oct 2009 14:20:59 +0100
Message-ID: <4e5e476b0910260620l3eb6c0a4u422cad1e5386bd71@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of 
	cfq_queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens
On Mon, Oct 26, 2009 at 12:40 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Sat, Oct 24 2009, Corrado Zoccolo wrote:
>> You identified the problem in the idling logic, that reduces the
>> throughput in this particular scenario, in which various threads or
>> processes issue (in random order) the I/O requests with different I/O
>> contexts on behalf of a single entity.
>> In this case, any idling between those threads is detrimental.
>> Ideally, such cases should be already spotted, since think time should
>> be high for such processes, so I wonder if this indicates a problem in
>> the current think time logic.
>
> That isn't necessarily true, it may just as well be that there's very
> little think time (don't see the connection here). A test case to
> demonstrate this would be a number of processes/threads splitting a
> sequential read of a file between them.

Jeff said that the huge performance drop was not observable with noop
or any other work conserving scheduler.
Since noop doesn't enforce any I/O ordering, but just ensures that any
I/O passes through ASAP,
this means that the biggest problem is due to idling, while the
increased seekiness has just a small impact.

So your test case doesn't actually match the observations: each thread
will always have new requests to submit (so idling doesn't penalize
too much here), while the seekiness introduced will be the most
important factor.

I think the real test case is something like (single dd through nfs via udp):
* there is a single thread, that submits a small number of requests
(e.g. 2) to a work queue, and wait for their completion before
submitting new requests
* there is a thread pool that executes those requests (1 thread runs 1
request), and signals back completion. Threads in the pool are
selected randomly.

In this case, the average think time should be > the average access
time, as soon as we have that the number of threads exceeds
2*#parallel_requests.

Corrado

>
> --
> Jens Axboe
>
>
