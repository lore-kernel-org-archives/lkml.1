Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZKJRz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZKJRz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZKJRz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:55:58 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54911 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZKJRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TUMeaxNdY7MRHAhH4KsXglAsoJvL4GaNMwavJJiNUAGXgxO7T8Wo1MwqS7Lp3CiR6X
         8VHVCGL0XPksDTL4JEjnS2It5NIDEmAusbZ3Pl/+RUL8I28T+Es1fa9lHG8/jjprJpch
         cGa+a0ppWA/F5CA90K5wuuQ0rjPExFkkIHsUA=
MIME-Version: 1.0
In-Reply-To: <20091110151431.GI8742@kernel.dk>
References: <200911101454.57522.czoccolo@gmail.com>
	 <20091110151431.GI8742@kernel.dk>
Date: Tue, 10 Nov 2009 18:56:01 +0100
Message-ID: <4e5e476b0911100956u47bb3111jeba9fbcc3d992960@mail.gmail.com>
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection code
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, aaronc@gelato.unsw.edu.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 4:14 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Nov 10 2009, Corrado Zoccolo wrote:
>> The core block layer already has code to detect presence of command
>> queuing devices. We convert cfq to use that instead of re-doing the
>> computation.
>
> There's is the major difference that the CFQ variant is dynamic and the
> block layer one is not. This change came from Aaron some time ago IIRC,
> see commit 45333d5. It's a bit of a chicken and egg problem.

The comment by Aaron:
    CFQ's detection of queueing devices assumes a non-queuing device and detects
    if the queue depth reaches a certain threshold.  Under some workloads (e.g.
    synchronous reads), CFQ effectively forces a unit queue depth,
thus defeating
    the detection logic.  This leads to poor performance on queuing hardware,
    since the idle window remains enabled.

makes me think that the dynamic-off detection in cfq may really be
buggy (BTW this could explain the bad results on SSD Jeff observed
before my patch set).
The problem is, that once the hw_tag is 0, it is difficult for it to
become 1 again, as explained by Aaron, since cfq will hardly send more
than 1 request at a time. My patch set fixes this for SSDs (the seeky
readers will still be sent without idling, and if they are enough, the
logic will see a large enough depth to reconsider the initial
decision).

So the only sound way to do the detection is to start in an
indeterminate state, in which CFQ behaves as if hw_tag = 1, and then,
if for a long observation period we never saw large depth, we switch
to hw_tag = 0, otherwise we stick to hw_tag = 1, without reconsidering
it.

I think the correct logic could be pushed to the blk-core, by
introducing also an indeterminate bit.

Corrado
>
> --
> Jens Axboe
>
>
