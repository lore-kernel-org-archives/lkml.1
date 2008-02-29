Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbYB2TAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbYB2TAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbYB2TAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:00:07 -0500
Received: from main.gmane.org ([80.91.229.2]:36838 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbYB2TAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:00:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
Date: Fri, 29 Feb 2008 19:54:45 +0100
Message-ID: <fq9kdl$j3$1@ger.gmane.org>
References: <1201142334.6383.40.camel@localhost.localdomain>	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>	 <1201573686.6766.13.camel@localhost>	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>	 <1201659263.6766.40.camel@localhost>	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>	 <1201745776.6195.14.camel@localhost.localdomain>	 <Pine.LNX.4.64.0801310404480.17507@scrub.home>	 <1201914175.6216.46.camel@jstultz-laptop>	 <Pine.LNX.4.64.0802081718040.3378@scrub.home>	 <1202523452.6174.45.camel@localhost.localdomain>	 <Pine.LNX.4.64.0802101917030.3378@scrub.home>	 <1202774999.5984.106.camel@localhost>	 <Pine.LNX.4.64.0802120335170.3378@scrub.home>	 <1202963796.6195.141.camel@localhost.localdomain>	 <Pine.LNX.4.64.0802150436300.1822@scrub.home>	 <1203382940.5984.242.camel@localhost>	 <Pine.LNX.4.64.0802190219360.2723@scrub.home>	 <1203472250.6123.98.camel@localhost>	 <Pine.LNX.4.64.0802200348230.2723@scrub.home> <1203647951.6150.80.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5b374e3b.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
In-Reply-To: <1203647951.6150.80.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
<snip>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index c88b591..fe25c94 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -43,19 +43,32 @@ long time_freq;				/* frequency offset (scaled ppm)*/
>  static long time_reftime;		/* time at last adjustment (s)	*/
>  long time_adjust;
>  
> +static s64 granularity_error_adjust;
> +
> +void ntp_set_granularity_error(s64 len)
> +{
> +	granularity_error_adjust = len * NTP_INTERVAL_FREQ;
> +}
> +
>  static void ntp_update_frequency(void)
>  {
>  	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
>  				<< TICK_LENGTH_SHIFT;
> -	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
> -	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
> +	s64 adj;
> +	
> +	/* Compensate for clocksource granularity error */
> +	second_length += granularity_error_adjust;
> +	
> +	/* Scale the base second length by the frequency adjustment */
> +	adj = second_length * time_freq;
> +	do_div(adj, 1000000);
> +	second_length += adj>>SHIFT_NSEC;
>  
>  	tick_length_base = second_length;
> +	do_div(tick_length_base, NTP_INTERVAL_FREQ);
>  
>  	do_div(second_length, HZ);
>  	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
> -
> -	do_div(tick_length_base, NTP_INTERVAL_FREQ);
>  }
>  
>  /**
<snip>

Hi John,

out of curiosity and inspired by the patch you suggested, I did a test
with the following ntp_update_frequency function in kernel/time/ntp.c
of kernel 2.6.24.3 using NO_HZ and the hpet timer:

static void ntp_update_frequency(void)
{
	s64 adj;
	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
				<< TICK_LENGTH_SHIFT;

         printk(KERN_NOTICE "*ntp* timefreq = %lld\n", (s64)time_freq);
         printk(KERN_NOTICE "*ntp* s len    = %lld\n", second_length);

         printk(KERN_NOTICE "*ntp* corr 1   = %lld\n",
                   (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC));

	/* Scale the base second length by the frequency adjustment */
	adj = second_length * time_freq;
	do_div(adj, 1000000);
         printk(KERN_NOTICE "*ntp* corr 2   = %lld\n", adj>>SHIFT_NSEC);

	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);

	tick_length_base = second_length;
	do_div(tick_length_base, NTP_INTERVAL_FREQ);

	do_div(second_length, HZ);
	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
}

Running this kernel and ntpd I get numbers like the following in my
syslog file:

Feb 29 12:28:16 skadi kernel: *ntp* timefreq = 305345
Feb 29 12:28:16 skadi kernel: *ntp* s len    = 4294967296000000000
Feb 29 12:28:16 skadi kernel: *ntp* corr 1   = 320177438720
Feb 29 12:28:16 skadi kernel: *ntp* corr 2   = 3030411349
Feb 29 12:36:53 skadi kernel: *ntp* timefreq = 730456
Feb 29 12:36:53 skadi kernel: *ntp* s len    = 4294967296000000000
Feb 29 12:36:53 skadi kernel: *ntp* corr 1   = 765938630656
Feb 29 12:36:53 skadi kernel: *ntp* corr 2   = 2434829845
Feb 29 12:39:03 skadi kernel: *ntp* timefreq = 868771
Feb 29 12:39:03 skadi kernel: *ntp* s len    = 4294967296000000000
Feb 29 12:39:03 skadi kernel: *ntp* corr 1   = 910972420096
Feb 29 12:39:03 skadi kernel: *ntp* corr 2   = 2301870005

So the original correction and the correction suggested by you
differ significantly by a factor of approximately 1000.
Incidentally, both corrections are nearly neglectable compared to
second_length.
But I think the correction suggested by you is calculated wrong due to
an overflow of the multiplication

   second_length * time_freq

Calculating the correction as

   (second_length / 1000000) * time_freq

the correction would be 1311446788997120000 which is much bigger as
the original correction 320177438720 (by a factor of 10^7).

Is it normal to have a second_length of approx. 4 * 10^18 ?
In what units?
-- 
Regards,
Jörg-Volker.

