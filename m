Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZDTIYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZDTIYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZDTIYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:24:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37465 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZDTIYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:24:08 -0400
Date: Mon, 20 Apr 2009 10:24:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFQ: Preemption/timeout logic reversed?
Message-ID: <20090420082407.GV4593@kernel.dk>
References: <ed038eb20904191756y5a5bcf8fn53473405b3929de6@mail.gmail.com> <20090420061602.GO4593@kernel.dk> <ed038eb20904192348m7f9f630q395baf123c3fd2ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed038eb20904192348m7f9f630q395baf123c3fd2ba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20 2009, Carl Henrik Lunde wrote:
> On Mon, Apr 20, 2009 at 08:16, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Apr 20 2009, Carl Henrik Lunde wrote:
> >> Hi!
> >>
> >> It seems the preemption "bonus" logic in CFQ is reversed, a preempted
> >> process is given an additional delay in start time instead of a bonus.
> >>  This seems unfair.  I'm not sure if it's a good idea to let
> >
> > Hmm? ->slice_resid is a long, so if we preempt the process 10 jiffies
> > before it was supposed to end, the resid will be -10. So it'll not
> > increase the rb_key, it'll decrease it.
> 
> OK, so maybe I'm tired (I am!), but I don't get it. :)
> 
> {
>         if (... busy_rt_queues)
>                cfq_slice_expire(timed_out=1)
> }
> 
> cfq_slice_expire() {
> {
>         if (timed_out)
>                 slice_resid = slice_end - jiffies;
> }
> 
> if preempted it would be 100 - 90 = +10?

Hrmpf, that is buggy, it should be jiffies - slice_end! Presumably that
has been buggy since the shift to rb service tree, since (IIRC) that was
when it was changed from "add to slice length" to "adjust in tree".

-- 
Jens Axboe

