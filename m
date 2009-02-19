Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZBSWNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZBSWNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZBSWNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:13:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbZBSWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:13:24 -0500
Date: Thu, 19 Feb 2009 14:12:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: zippel@linux-m68k.org, williams@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC(again)] Apply NTP frequency/tick changes
 immediately.
Message-Id: <20090219141234.40f84111.akpm@linux-foundation.org>
In-Reply-To: <1235001742.6946.18.camel@localhost.localdomain>
References: <1234494121.7042.14.camel@localhost.localdomain>
	<1235001742.6946.18.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 16:02:22 -0800
john stultz <johnstul@us.ibm.com> wrote:

> On Thu, 2009-02-12 at 19:02 -0800, john stultz wrote:
> > Hey Roman,
> > 	It was brought to my attention that since the GENERIC_TIME changes
> > landed, the adjtimex behavior changed for struct timex.tick and .freq
> > changes. When the tick or freq value is set, we adjust the
> > tick_length_base in ntp_update_frequency(). However, this new value
> > doesn't get applied to tick_length until the next second (via
> > second_overflow). 
> > 
> > This means some applications that do quick time tweaking do not see the
> > requested change made as quickly as expected.
> > 
> > Looking at the code, it doesn't seem like it would be too hard to
> > immediately apply the change to the tick_length value, so its changed in
> > the following NTP_INTERVAL, which this patch does.
> > 
> > I've run a few tests with this change, and ntpd still functions fine. I
> > do however note that the drift value for my test system changed from
> > ~170ppm to ~18ppm, which I didn't quite expect, and needs some
> > additional research.
> > 
> > Anyway, I just wanted to see if you had any thoughts on this sort of
> > change.
> 
> Hey Roman, Just wanted to ping you again to see if you had any
> objections to this change.
> 
> I did find the cause of my test system's drift switching from 170ppm to
> 18ppm, and it ends up its due to my bouncing between kernel versions.
> The 170ppm drift was established after running w/ a older 2.6.24 based
> kernel for awhile, and after the NTP_INTERVAL_LENGTH changes
> (10a398d04c4a1fc395840f4d040493375f562302) landed the ppm value was
> expected to change. Comparing the same kernel 2.6.29-rc4 with and
> without this patch, the ppm value did not change.

<tries to find a changelog in there, gives up>

> Anyway, here it is again.
> 
> thanks
> -john
> 
> 
> Apply NTP tick/frequency adjustments immediately instead of waiting for
> the next second to pass.
> 

Please modify the changelog so that it explains the reason for making
the change.

I _could_ copy-n-paste the doubly-quoted text from up top, but perhaps
that isn't how you'd have wanted to changelog it, had you wanted to
changelog it ;)

I'm particularly looking for a sense of how urgent this fix is.

> 
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index f5f793d..9fd0d15 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -51,6 +51,7 @@ static long ntp_tick_adj;
>  
>  static void ntp_update_frequency(void)
>  {
> +	u64 old_tick_length_base = tick_length_base;
>  	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
>  				<< NTP_SCALE_SHIFT;
>  	second_length += (s64)ntp_tick_adj << NTP_SCALE_SHIFT;
> @@ -60,6 +61,11 @@ static void ntp_update_frequency(void)
>  
>  	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
>  	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
> +	
> +	/* Don't wait for the next second_overflow, apply
> +	 * the change to the tick length immediately
> +	 */

the comment-layout police will get ya.

> +	tick_length += tick_length_base - old_tick_length_base;
>  }
>  
>  static void ntp_update_offset(long offset)

The patch adds new trailing whitespace.  checkpatch whines.
