Return-Path: <linux-kernel-owner+w=401wt.eu-S939159AbYCSVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939159AbYCSVxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764716AbYCSUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:20:26 -0400
Received: from main.gmane.org ([80.91.229.2]:33111 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbYCSUUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:20:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH 2/4] convert a few do_div user
Date: Tue, 18 Mar 2008 21:10:33 +0100
Message-ID: <47E021B9.7030502@web.de>
References: <20080313002235.351414762@linux-m68k.org> <20080313004902.866970953@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5b374d08.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
In-Reply-To: <20080313004902.866970953@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zippel@linux-m68k.org wrote:
> This converts a few users of do_div to div_[su]64 and this demonstrates
> nicely how it can reduce some expressions to one-liners.
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> 
> ---
>  kernel/time.c     |   29 +++++++++--------------------
>  kernel/time/ntp.c |   25 ++++++-------------------
>  2 files changed, 15 insertions(+), 39 deletions(-)
> 
<snip>
> Index: linux-2.6/kernel/time/ntp.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/ntp.c	2008-03-11 17:15:14.000000000 +0100
> +++ linux-2.6/kernel/time/ntp.c	2008-03-12 21:21:20.000000000 +0100
<snip>
>  /*
> @@ -53,10 +53,8 @@ static void ntp_update_frequency(void)
>  
>  	tick_length_base = second_length;
>  
> -	do_div(second_length, HZ);
> -	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
> -
> -	do_div(tick_length_base, NTP_INTERVAL_FREQ);
> +	tick_nsec = div_u64(second_length, HZ) >> TICK_LENGTH_SHIFT;
> +	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
>  }
>  

Probably the compiler would optimize it, but maybe its clearer to change it this 
way:

- 	tick_length_base = second_length;

-	do_div(second_length, HZ);
-	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
-
-	do_div(tick_length_base, NTP_INTERVAL_FREQ);
+	tick_nsec = div_u64(second_length, HZ) >> TICK_LENGTH_SHIFT;
+	tick_length_base = div_u64(second_length, NTP_INTERVAL_FREQ);

-- 
Regards,
Jörg-Volker.



<snip>

