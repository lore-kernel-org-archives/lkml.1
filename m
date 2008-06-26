Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbYF0MUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbYF0MUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbYF0MLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:11:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2919 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761031AbYF0MLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:11:16 -0400
Date: Thu, 26 Jun 2008 22:11:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mayank Sharma <mayanks@sirf.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Time drifting after multiple sleep/wakeup in timekeeping
Message-ID: <20080626201135.GC9878@ucw.cz>
References: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <013B1C915F9462459242424413ABB264011AC64C@bnglmail.sirf.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed 2008-06-25 17:18:52, Mayank Sharma wrote:
> Hi,
> 
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
>         if (now && (now > timekeeping_suspend_time)) {
>                 unsigned long sleep_length = now - timekeeping_suspend_time;
>  
> -               xtime.tv_sec += sleep_length;
> +               /* Syncronize the xtime with the rtc as is done during init. This
> +                * ensures that drift is not accumulated while sleeping and waking
> +                * multiple times
> +                */
> +               xtime.tv_sec = now;
> +               xtime.tv_nsec = 0;

Is it possible that this removes offset between rtc and system clock?

Added rafael to cc, I guess you should add time maintainers (tglx?)
too...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
