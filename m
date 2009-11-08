Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZKHRBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZKHRBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZKHRBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:01:46 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60286 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZKHRBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:01:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kD7nethtE6+GmbcNrpVdd0LkfswL1kFNHWHZ99egCADxJnX5XHG+eJH45WTxSZui0P
         nalgFo+Rk24uyfXH4+NZUq++eYBEv1868SoS3RQJx+LncPuFd/NEDZuEH5YSnHlYi23x
         grzywga2qKYZEDg8pudodNvTYcoB3XVDlIfPs=
MIME-Version: 1.0
In-Reply-To: <x49my2zh47n.fsf@segfault.boston.devel.redhat.com>
References: <20091026172012.GC7233@duck.suse.cz>
	 <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	 <x49my2zh47n.fsf@segfault.boston.devel.redhat.com>
Date: Sun, 8 Nov 2009 18:01:50 +0100
Message-ID: <4e5e476b0911080901n6b855b0dle63f0151073ec2c6@mail.gmail.com>
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

On Fri, Nov 6, 2009 at 7:56 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
>                                                            rlat      |     rrlat       |     wlat       |  rwlat
> kernel     | Thr | read  | randr  | write  | randw  |    avg, max     |    avg, max     |   avg, max     | avg,max
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.29     |  8  | 66.43 |  20.52 | 296.32 | 214.17 | 22.330, 3106.47 | 70.026, 2804.02 | 4.817, 2406.65 | 1.420, 349.44
>           | 16  | 63.28 |  20.45 | 322.65 | 212.77 | 46.457, 5779.14 |137.455, 4982.75 | 8.378, 5408.60 | 2.764, 425.79
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.32-rc6 |  8  | 87.66 | 115.22 | 324.19 | 222.18 | 16.677, 3065.81 | 11.834,  194.18 | 4.261, 1212.86 | 1.577, 103.20
> low_lat=0  | 16  | 94.06 | 49.65  | 327.06 | 214.74 | 30.318, 5468.20 | 50.947, 1725.15 | 8.271, 1522.95 | 3.064,  89.16
> ------------------------------------------------------------------------------------------------------------------------
>

Jeff, Jens,
do you think we should try to do more auto-tuning of cfq parameters?
Looking at those numbers for SANs, I think we are being suboptimal in
some cases.
E.g. sequential read throughput is lower than random read.
In those cases, converting all sync queues in sync-noidle (as defined
in for-2.6.33) should allow a better aggregate throughput when there
are multiple sequential readers, as in those tiobench tests.
I also think that current slice_idle and slice_sync values are good
for devices with 8ms seek time, but they are too high for non-NCQ
flash devices, where "seek" penalty is under 1ms, and we still prefer
idling.
If we agree on this, should the measurement part (I'm thinking to
measure things like seek time, throughput, etc...) be added to the
common elevator code, or done inside cfq?
If we want to put it in the common code, maybe we can also remove the
duplication of NCQ detection, by publishing the NCQ flag from elevator
to the io-schedulers.

Thanks,
Corrado

>
> Cheers,
> Jeff
> --
