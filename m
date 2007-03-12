Return-Path: <linux-kernel-owner+w=401wt.eu-S964978AbXCLExg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbXCLExg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965089AbXCLExg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:53:36 -0400
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:47865 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964978AbXCLExg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:53:36 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 15:53:30 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703120912.24156.kernel@kolivas.org> <200703120742.41041.a1426z@gawab.com>
In-Reply-To: <200703120742.41041.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121553.30462.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 15:42, Al Boldi wrote:
> Con Kolivas wrote:
> > On Monday 12 March 2007 08:52, Con Kolivas wrote:
> > > And thank you! I think I know what's going on now. I think each
> > > rotation is followed by another rotation before the higher priority
> > > task is getting a look in in schedule() to even get quota and add it to
> > > the runqueue quota. I'll try a simple change to see if that helps.
> > > Patch coming up shortly.
> >
> > Can you try the following patch and see if it helps. There's also one
> > minor preemption logic fix in there that I'm planning on including.
> > Thanks!
>
> Applied on top of v0.28 mainline, and there is no difference.
>
> What's it look like on your machine?

The higher priority one always get 6-7ms whereas the lower priority one runs 
6-7ms and then one larger perfectly bound expiration amount. Basically 
exactly as I'd expect. The higher priority task gets precisely RR_INTERVAL 
maximum latency whereas the lower priority task gets RR_INTERVAL min and full 
expiration (according to the virtual deadline) as a maximum. That's exactly 
how I intend it to work. Yes I realise that the max latency ends up being 
longer intermittently on the niced task but that's -in my opinion- perfectly 
fine as a compromise to ensure the nice 0 one always gets low latency.

Eg:
nice 0 vs nice 10

nice 0:
pid 6288, prio   0, out for    7 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms
pid 6288, prio   0, out for    6 ms

nice 10:
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for   66 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms
pid 6290, prio  10, out for    6 ms

exactly as I'd expect. If you want fixed latencies _of niced tasks_ in the 
presence of less niced tasks you will not get them with this scheduler. What 
you will get, though, is a perfectly bound relationship knowing exactly what 
the maximum latency will ever be.

Thanks for the test case. It's interesting and nice that it confirms this 
scheduler works as I expect it to.

-- 
-ck
