Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZKXPjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZKXPjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZKXPjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:39:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097AbZKXPjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:39:00 -0500
Date: Tue, 24 Nov 2009 10:39:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/4] cfq-iosched: idling on deep seeky sync queues
Message-ID: <20091124153902.GD9595@redhat.com>
References: <200911241449.20715.czoccolo@gmail.com> <20091124143340.GA9595@redhat.com> <4e5e476b0911240724x42346177t5d2335cf5171dd15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911240724x42346177t5d2335cf5171dd15@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:24:23PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Tue, Nov 24, 2009 at 3:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Corrado,
> >
> > Thinking more about it. This clearing of flag when idle expires might
> > create issues with queues which sent down requests with a burst initially
> > forcing to set "deep" flag and then fall back to low depth. In that case,
> > enable_idle will continue to be 1 and we will be driving queue depth as 1.
> >
> > This is a theoritical explanation looking at the patch. I don't know if
> > in real life we have workloads who do this frequently. At least for my
> > testing, this patch did make sure we don't switch between workload type
> > of queue very frequently.
> >
> I thought at this scenario when developing the patch, but considered
> it too infrequent (and not so costly) to justify the added complexity
> of having a moving average.
> 
> For me, wasting an idle time is something to be punished for, while
> driving the queue at lower depth is not, if the requests are coming
> timely.

Agreed that penalty of idling and not dispatching anything to disk/array
is more as compared to penalty of driving queue depth smaller. But in 
general we don't want to drive shallow queue depths until and unless
required.

> 
> > May be keeping a track of average queue depth of a seeky process might
> > help here like thinktime. If average queue depth is less over a period of
> > time, we move the queue to sync-noidle group to achieve better throughput
> > overall and if average queue depth is high, make is sync-idle.
> >
> > Currently we seem to be taking queue depth into account only for enabling
> > the flag. We don't want too frequent switching of "deep" flag, so some
> > kind of slow moving average might help.
> >
> Averages can still change in the middle of a slice.
> A simpler way could be to reset the deep flag after a full slice, if
> the depth never reached the threshold during that slice.

That's fine. For the time being we can stick to this patch and observe
if there are singifincant cases which hit this condition. If yes, we can
go for your second suggestion of resetting the flag if queue never
achieved the deeper depths again during the slice.

Thanks
Vivek
