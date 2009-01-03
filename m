Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZACTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZACTEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbZACTE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 14:04:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:59774 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234AbZACTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 14:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NXhRD8MQJRTx1+NgjPLKBOrZyVQ4DpICfC5xPbLQlJok8aY5YccSFYpVcKRayfLOa2
         kvp0jBdZJf1aoFTwODcbecs8lAOFm18URk5pzVL23TOvBwjvaA/ISj7uJlbmNWeB7+9P
         lL6TYpsODu5Nr60MbS+6tDWtmgQ0WlPZHNDuU=
Message-ID: <e9e943910901031104n36bb216al9b81304eefde4085@mail.gmail.com>
Date: Sat, 3 Jan 2009 19:04:24 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Chris Adams" <cmadams@hiwaay.net>
Subject: Re: [PATCH] v2 Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Linas Vepstas" <linasvepstas@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090103180148.GA1375968@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
	 <20090103022358.GA2454@dastardly.home.dghda.com>
	 <20090103044143.GB1538533@hiwaay.net>
	 <20090103045227.GA5994@dastardly.home.dghda.com>
	 <20090103180148.GA1375968@hiwaay.net>
X-Google-Sender-Auth: b3ce67828c89c083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Chris Adams <cmadams@hiwaay.net>:
> Once upon a time, Duane Griffin <duaneg@dghda.com> said:
>> How about instead of a switch statement, assigning the message to a
>> variable and printing that. I.e. something like:
>
> Good point.  Here's an updated version that also adds a comment to the
> xtime_lock definition about not using printk.

Good idea.

> --
> Chris Adams <cmadams@hiwaay.net>
> Systems and Network Administrator - HiWAAY Internet Services
> I don't speak for anybody but myself - that's enough trouble.
>
>
> From: Chris Adams <cmadams@hiwaay.net>
>
> The code to handle leap seconds printks an information message when the
> second is inserted or deleted.  It does this while holding xtime_lock.
> However, printk wakes up klogd, and in some cases, the scheduler tries
> to get the current kernel time, trying to get xtime_lock (which results
> in a deadlock).  This moved the printks outside of the lock.  It also
> adds a comment to not use printk while holding xtime_lock.
>
> Signed-off-by: Chris Adams <cmadams@hiwaay.net>
> ---
> diff -urpN linux-2.6.28-git5-vanilla/include/linux/time.h linux-2.6.28-git5/include/linux/time.h
> --- linux-2.6.28-git5-vanilla/include/linux/time.h      2009-01-02 22:09:10.000000000 -0600
> +++ linux-2.6.28-git5/include/linux/time.h      2009-01-03 11:57:27.000000000 -0600
> @@ -99,6 +99,12 @@ static inline struct timespec timespec_s
>
>  extern struct timespec xtime;
>  extern struct timespec wall_to_monotonic;
> +
> +/*
> + * Do not call printk while holding this lock; it wakes klogd and the
> + * scheduler may try to get the current kernel time, which will try to get
> + * this lock.
> + */
>  extern seqlock_t xtime_lock;
>
>  extern unsigned long read_persistent_clock(void);
> diff -urpN linux-2.6.28-git5-vanilla/kernel/time/ntp.c linux-2.6.28-git5/kernel/time/ntp.c
> --- linux-2.6.28-git5-vanilla/kernel/time/ntp.c 2009-01-02 22:09:34.000000000 -0600
> +++ linux-2.6.28-git5/kernel/time/ntp.c 2009-01-03 11:57:46.000000000 -0600
> @@ -130,6 +130,7 @@ void ntp_clear(void)
>  static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
>  {
>        enum hrtimer_restart res = HRTIMER_NORESTART;
> +       const char *msg = NULL;
>
>        write_seqlock(&xtime_lock);
>
> @@ -140,8 +141,7 @@ static enum hrtimer_restart ntp_leap_sec
>                xtime.tv_sec--;
>                wall_to_monotonic.tv_sec++;
>                time_state = TIME_OOP;
> -               printk(KERN_NOTICE "Clock: "
> -                      "inserting leap second 23:59:60 UTC\n");
> +               msg = "Clock: inserting leap second 23:59:60 UTC";
>                hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
>                res = HRTIMER_RESTART;
>                break;
> @@ -150,8 +150,7 @@ static enum hrtimer_restart ntp_leap_sec
>                time_tai--;
>                wall_to_monotonic.tv_sec--;
>                time_state = TIME_WAIT;
> -               printk(KERN_NOTICE "Clock: "
> -                      "deleting leap second 23:59:59 UTC\n");
> +               msg = "Clock: deleting leap second 23:59:59 UTC";
>                break;
>        case TIME_OOP:
>                time_tai++;
> @@ -166,6 +165,9 @@ static enum hrtimer_restart ntp_leap_sec
>
>        write_sequnlock(&xtime_lock);
>
> +       if (msg)
> +               printk(KERN_NOTICE "%s\n", msg);
> +
>        return res;
>  }

Looks good to me!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
