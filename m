Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYGJWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYGJWJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbYGJWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:09:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:49607 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYGJWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Oe/Gun5lFEAh/LFZ+wOTs9hepHQ64UkBt34fNlsTLi8HhTFTo3hCdekmhunqc//MAN
         +F+Pw/1HV5iKmfV01HR3TQG1t05NPta4qGsf7j/nB4cWqWrvOXqPeXihBJjxvP9hn2+H
         R/w3YdE7JshWFhLyGU6kwN2KJi2o1u1Pw7HP0=
Message-ID: <1f1b08da0807101509q355eda72ofa855be6e5f42e7f@mail.gmail.com>
Date: Thu, 10 Jul 2008 15:09:24 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Mayank Sharma" <mayanks@sirf.com>
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <AcjWuXCdruANDkKsEd3GhwAVxR+4QQ==>
	 <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
X-Google-Sender-Auth: 6a759ad00ca3fb19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 4:48 AM, Mayank Sharma <mayanks@sirf.com> wrote:
> I noticed a bug with respect to time drifting after multiple sleep/wakeup sequence. We have an embedded ARM11 based platform on which we have successfuly ported Linux. We also have a RTC on board. Hence we have implemented the read_persistent_clock() function overriding the one defined in kernel/time/timekeeping.c. What we observed was that after doing multiple sleep/wakeup sequences, the time reported by RTC and gettimeofday was drifting. After about 10 iterations the gettimeofday was lagging by about one second. Subsequently the lag only increased.
>
> What looks to me is that in the timekeeping_resume function we are adding the number of seconds we have been sleeping to adjust the new time. But since we are adding only the seconds slept the update is only second level accurate. read_persistent_clock gives a second level granulaity, and hence we cannot help that. Hence after one sleep/wake sequence the gettimeoday would have lagged by delta (where delta is less than a second). On multiple such iterations the delta keeps adding up, becoming a second and thereafter we see a drift of more than a second.
>
> If however we set the gettimeofday (xtime) to the RTC time on wakeup (Just like we do in timekeeping_init()) instead of just adding the sleep time, the drift will not accumulate. I am using the patch mentioned in the end of the mail to fix this issue. Let me know if this is a valid patch.
>
> Regards,
> Mayank
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index e91c29f..6edf37f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -288,12 +288,19 @@ static int timekeeping_resume(struct sys_device *dev)
>        if (now && (now > timekeeping_suspend_time)) {
>                unsigned long sleep_length = now - timekeeping_suspend_time;
>
> -               xtime.tv_sec += sleep_length;
> +               /* Syncronize the xtime with the rtc as is done during init. This
> +                * ensures that drift is not accumulated while sleeping and waking
> +                * multiple times
> +                */
> +               xtime.tv_sec = now;
> +               xtime.tv_nsec = 0;

This would only be better if we are sure the persistent clock is NTP
synced (which it may not be) and it also waits for a second boundary
to return. On x86 I know the stall-for-a-second-boundary trick was
removed because it would add an extra 1sec delay to the suspend/resume
time.

Additionally Mixing the above with the below could cause the monotonic
clock to see inconsistencies.

>                wall_to_monotonic.tv_sec -= sleep_length;
>                total_sleep_time += sleep_length;
>        }
>        /* Make sure that we have the correct xtime reference */
> -       timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
> +       else {
> +               timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
> +    }
>        update_xtime_cache(0);
>        /* re-base the last cycle value */
>        clock->cycle_last = 0;

So instead,  I'd suggest extending the persistent_clock interface to
support/return nanoseconds, so the delta can be more precise. This
won't work on all hardware (since not all systems have nanosecond
resolution rtcs) but avoids any delays trying to only return on second
boundaries, etc.

thanks
-john
