Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYEIFAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYEIFAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYEIE7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:59:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26652 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYEIE7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QtSmVkxqAen8hXlG81FR/S8AasDcH/8HNRrWMAMo3/ON2nFww3nI+coYkMz0w34NfflNCmQs7ZSSHhbzyHyy3q+cmRhcUpFqym1e1DntdCWMbQVBLua5jdjQG8fcplmz/Pwd8Z4LctF5eZcfDYf3/qkNWxU+yEgT7HmdP4j3i3A=
Message-ID: <e9c3a7c20805082159y281d6a84i8136bad647566e09@mail.gmail.com>
Date: Thu, 8 May 2008 21:59:48 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jacek Luczak" <difrost.kernel@gmail.com>,
       "Prakash Punnoor" <prakash@punnoor.de>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
In-Reply-To: <18467.46015.146700.695469@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805031151.44287.prakash@punnoor.de>
	 <18462.46639.578272.994939@notabene.brown>
	 <20080505190159.GA329@kernel.dk> <200805082039.01316.rjw@sisk.pl>
	 <1210272379.9697.3.camel@dwillia2-linux.ch.intel.com>
	 <1210288690.9697.14.camel@dwillia2-linux.ch.intel.com>
	 <18467.46015.146700.695469@notabene.brown>
X-Google-Sender-Auth: 1bbb108b6c31942a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 7:15 PM, Neil Brown <neilb@suse.de> wrote:
> On Thursday May 8, dan.j.williams@intel.com wrote:
>  > @@ -133,8 +137,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  >
>  >               disk->rdev = rdev;
>  >
>  > +             spin_lock(&conf->device_lock);
>  >               blk_queue_stack_limits(mddev->queue,
>  >                                      rdev->bdev->bd_disk->queue);
>  > +             spin_unlock(&conf->device_lock);
>  >               /* as we don't honour merge_bvec_fn, we must never risk
>  >                * violating it, so limit ->max_sector to one PAGE, as
>  >                * a one page request is never in violation.
>
>  This shouldn't be necessary.
>  There is no actual race here -- mddev->queue->queue_flags is not going to be
>  accessed by anyone else until do_md_run does
>         mddev->queue->make_request_fn = mddev->pers->make_request;
>  which is much later.
>  So we only need to be sure that "queue_is_locked" doesn't complain.
>  And as q->queue_lock is still NULL at this point, it won't complain.
>
>  I think that the *only* change that is needs is to put
>
>
>  > +     /* blk-core uses queue_lock to verify protection of the queue flags */
>  > +     mddev->queue->queue_lock = &conf->device_lock;
>
>  after each
>
> > +     spin_lock_init(&conf->device_lock);
>
>  i.e. in raid1.c, raid10.c and raid5.c
>
>  ??

Yes, locking shouldn't be needed at those points; however, the warning
still fires because blk_queue_stack_limits() is using
queue_flag_clear() instead of queue_flag_unlocked().  Taking a look at
converting it to queue_flag_clear_unlocked() uncovered a couple more
overlooked sites (multipath.c:multipath_add_disk and
raid1.c:raid1_add_disk) where ->run has already been called...

The options I am thinking of all seem ugly:
1/ keep the unnecessary locking in MD
2/ make blk_queue_stack_limits() use queue_flag_clear_unlocked() even
though it needs to be locked sometimes
3/ conditionally use queue_flag_clear_unlocked if !t->queue_lock

--
Dan
I'm having a h
