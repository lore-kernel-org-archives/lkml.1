Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbZKJRhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbZKJRhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbZKJRhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:37:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48261 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbZKJRhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:37:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZwOg89r0anu/Z5UCrQwVq2OFa2fEQhUYJAvU51CsFcC8RJeS5V2PjVMrWP8uJL35Ax
         elqNEZp4gv0MUIgqvJB4J4UX4hEP7qVv1+9k6UpDiZAAkR73gGlM2zKgZb30gqTY4E9l
         t4/kZ/75idqRKYhOc73sFnAYMA6MT7Sy/bXEg=
MIME-Version: 1.0
In-Reply-To: <x494op25ntp.fsf@segfault.boston.devel.redhat.com>
References: <20091026172012.GC7233@duck.suse.cz>
	 <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	 <x49my2zh47n.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0911080901n6b855b0dle63f0151073ec2c6@mail.gmail.com>
	 <x494op25ntp.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 10 Nov 2009 18:37:57 +0100
Message-ID: <4e5e476b0911100937s31767d1dh52831126c5e8cf47@mail.gmail.com>
Subject: Re: Performance regression in IO scheduler still there
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 5:47 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Jeff, Jens,
>> do you think we should try to do more auto-tuning of cfq parameters?
>> Looking at those numbers for SANs, I think we are being suboptimal in
>> some cases.
>> E.g. sequential read throughput is lower than random read.
>
> I investigated this further, and this was due to a problem in the
> benchmark.  It was being run with only 500 samples for random I/O and
> 65536 samples for sequential.  After fixing this, we see random I/O is
> slower than sequential, as expected.
Ok.
>> I also think that current slice_idle and slice_sync values are good
>> for devices with 8ms seek time, but they are too high for non-NCQ
>> flash devices, where "seek" penalty is under 1ms, and we still prefer
>> idling.
>
> Do you have numbers to back that up?  If not, throw a fio job file over
> the fence and I'll test it on one such device.
>
It is based on reasoning.
Currently idling is based on the assumption that we can wait up to
10ms, to get a better request than jumping far away, since the jump
will likely cost more than that. If the jump costs around 1ms, like on
flash cards, then waiting 10ms is surely wasted time.
On the other hand, on flash cards a random write could cost 50ms or
more, so we will need to differentiate the last idle before switching
to async writes from the inter-read idles. This should be possible
with the new workload based infrastructure, but we need to measure
those characteristic times in order to use them in the heuristics.

>> If we agree on this, should the measurement part (I'm thinking to
>> measure things like seek time, throughput, etc...) be added to the
>> common elevator code, or done inside cfq?
>
> Well, if it's something that is of interest to others, than pushing it
> up a layer makes sense.  If only CFQ is going to use it, keep it there.
If the direction is to have only one intelligent I/O scheduler, as the
removal of anticipatory indicates, then it is the latter. I don't
think noop or deadline will ever make any use of them.
But it could still be useful for reporting performance as seen by the
kernel, after the page cache.

Thanks
Corrado
>
> Cheers,
> Jeff
>
