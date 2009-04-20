Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZDTGQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZDTGQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZDTGQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:16:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36490 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZDTGQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:16:04 -0400
Date: Mon, 20 Apr 2009 08:16:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CFQ: Preemption/timeout logic reversed?
Message-ID: <20090420061602.GO4593@kernel.dk>
References: <ed038eb20904191756y5a5bcf8fn53473405b3929de6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed038eb20904191756y5a5bcf8fn53473405b3929de6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20 2009, Carl Henrik Lunde wrote:
> Hi!
> 
> It seems the preemption "bonus" logic in CFQ is reversed, a preempted
> process is given an additional delay in start time instead of a bonus.
>  This seems unfair.  I'm not sure if it's a good idea to let

Hmm? ->slice_resid is a long, so if we preempt the process 10 jiffies
before it was supposed to end, the resid will be -10. So it'll not
increase the rb_key, it'll decrease it.

> slice_resid grow without limit as shown below, but isn't this more
> like the way it was intended to work?  Or did I misunderstand
> something?

->slice_resid is reset when it gets repositioned in the rb tree. The
intent was not to increase the slice length, but instead allow it sooner
service again.

> PS! The comment above cfq_preempt_queue seems outdated too.

Yep, the slice length comment is out dated indeed.

> Code not tested, just showing what I mean:
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 664ebfd..ea18d45 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -292,7 +292,8 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct
> cfq_queue *cfqq)
>  static inline void
>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> -       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
> +       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) +
> cfqq->slice_resid + jiffies;

So if ->slice_resid is negative because we preempted this queue, it'll
now get a shorter slice. That's not very nice :-)

-- 
Jens Axboe

