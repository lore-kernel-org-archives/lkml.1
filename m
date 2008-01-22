Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYAVO2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYAVO2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYAVO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:27:52 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34219 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYAVO1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:27:51 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: konqueror deadlocks on 2.6.22
Date: Tue, 22 Jan 2008 09:25:49 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>,
       Oliver Pinter (=?iso-8859-1?q?Pint=E9r?= =?iso-8859-1?q?_Oliv=E9r?=) 
	<oliver.pntr@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200801192114.41427.a1426z@gawab.com> <20080122101014.GD5722@elte.hu> <200801221623.42989.a1426z@gawab.com>
In-Reply-To: <200801221623.42989.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801220925.50314.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008, Al Boldi wrote:
> Ingo Molnar wrote:
> > * Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> > > and then please update to CFS-v24.1
> > > http://people.redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.6.22.15-v24.
> > >1 .patch
> > >
> > > > Yes with CFSv20.4, as in the log.
> > > >
> > > > It also hangs on 2.6.23.13
> >
> > my feeling is that this is some sort of timing dependent race in
> > konqueror/kde/qt that is exposed when a different scheduler is put in.
> >
> > If it disappears with CFS-v24.1 it is probably just because the timings
> > will change again. Would be nice to debug this on the konqueror side and
> > analyze why it fails and how. You can probably tune the timings by
> > enabling SCHED_DEBUG and tweaking /proc/sys/kernel/*sched* values - in
> > particular sched_latency and the granularity settings. Setting wakeup
> > granularity to 0 might be one of the things that could make a
> > difference.
>
> Thanks Ingo, but Mike suggested that data=writeback may make a difference,
> which it does indeed.
>
> So the bug seems to be related to data=ordered, although I haven't gotten
> any feedback from the ext3 gurus yet.
>
> Seems rather critical though, as data=writeback is a dangerous mode to run.

Running fsync in data=ordered means that all of the dirty blocks on the FS 
will get written before fsync returns.  Your original stack trace shows 
everyone either performing writeback for a log commit or waiting for the log 
commit to return.

They key task in your trace is kjournald, stuck in get_request_wait.  It could 
be a block layer bug, not giving him requests quickly enough, or it could be 
the scheduler not giving him back the cpu fast enough.

At any rate, that's where to concentrate the debugging.  You should be able to 
simulate this by running a few instances of the below loop and looking for 
stalls:

while(true) ; do
    time dd if=/dev/zero of=foo bs=50M count=4 oflags=sync    
done

