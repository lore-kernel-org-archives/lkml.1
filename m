Return-Path: <linux-kernel-owner+w=401wt.eu-S1161597AbXDLMKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161597AbXDLMKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161598AbXDLMKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:10:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:31552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161597AbXDLMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QJ5KZaium1p05TAafcCRDJ1hOjWZXvcOsZmAGGVR/NXz9nWFxu767Mxcm88xA8qxww+BAi8cQveZkiJjnAH5PogONZg0NeWv1oRgZfuhcnRY5ROXBvC+K93tB3Mg0OMFGJg7V+VI5/InxiGY4K75XgJvzEm5lcQvZNGVNRBTsF4=
Message-ID: <b647ffbd0704120510q58ad8b24ob7758b1e7e16c427@mail.gmail.com>
Date: Thu, 12 Apr 2007 14:10:05 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "surya.prabhakar@wipro.com" <surya.prabhakar@wipro.com>
Subject: Re: rsdl:mouse freezing while doing git-gc
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1176364262.2633.27.camel@bluegenie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176279462.8833.8.camel@bluegenie>
	 <b647ffbd0704110501x79b6dba7rf094113b59016559@mail.gmail.com>
	 <1176364262.2633.27.camel@bluegenie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/07, surya.prabhakar@wipro.com <surya.prabhakar@wipro.com> wrote:
> > [...]
> >
> > btw, it's sd-0.39, isn't?
> No! it is not. I have updated it to 2.6.21-rc5-sd-0.39.patch   and
> did the same tests.

It's nice-dependent. At least, that's something one would expect from
this design..

> PRI values s constantly changing while the git-gc is running. Is this
> expected behaviour?

Yep. Each nice level has a set of dynamic priorities which can be be
used by a task. After exhausting a time quota on a current level, the
task is moved to another (if there are no more -> "expired" array). So
the "PRI" field shows the current dynamic level.
The exceptions are SCHED_BATCH and Real-Time (FIFO and RR) tasks which
have different priority scheme.

/*
 * This contains a bitmap for each dynamic priority level with empty slots
 * for the valid priorities each different nice level can have. It allows
 * us to stagger the slots where differing priorities run in a way that
 * keeps latency differences between different nice levels at a minimum.
 * ie, where 0 means a slot for that priority, priority running from left to
 * right:
 * nice -20 0000000000000000000000000000000000000000
 * nice -10 1001000100100010001001000100010010001000
 * nice   0 0101010101010101010101010101010101010101
 * nice   5 1101011010110101101011010110101101011011
 * nice  10 0110111011011101110110111011101101110111
 * nice  15 0111110111111011111101111101111110111111
 * nice  19 1111111111111111111011111111111111111111

As you can see there is only a single possible level for nice 19
tasks, that's why your first results looked strange _but_ it might
have been due to the old version which lacks the prio_matrix (or it
was broken.. PRI == 0 for NICE 19 is very strabge indeed). So it's
good you have upgraded to the recent one.

I have made a small debugging extension that allows to monitor all the
priority levels (and how many times) being used by a given task
(configured via proc).. will test it later (don't have sd-enabled
kernel here). Just want to be sure that the "rules" are never broken.
Most likely Con did it already but as he is off-line we can't know.

>
> Did another test with hackbench and git-gc both at same priorities
> and captured the top output, in here all of them seem to have
> same priority..

Yep, this one looks good.


> thanks.
>
> surya.

-- 
Best regards,
Dmitry Adamushko
