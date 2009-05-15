Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZEOSz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZEOSz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZEOSzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:55:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38370 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZEOSzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:55:49 -0400
Message-ID: <4A0DBA9D.2050107@ti.com>
Date: Fri, 15 May 2009 13:55:25 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep   
 formorethan2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>	 <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com> <1242242497.9777.2.camel@jstultz-laptop> <4A0D99E0.3050306@ti.com>
In-Reply-To: <4A0D99E0.3050306@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jon Hunter wrote:
> +	/*
> +	 * If the result overflows, return the max value we can.
> +	 */
> +	if (overflow)
> +		ret = LONG_MAX;
> +	else
> +		ret = (s64)((upper << 32) + lower);
> +
>   	return ret;
>   }

Correction. Should have been LLONG_MAX and not LONG_MAX in the above. 
See below.

Jon


diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5a40d14..647f228 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -316,8 +316,32 @@ static inline void clocksource_disable(struct 
clocksource *cs)
   */
  static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
  {
-       u64 ret = (u64)cycles;
-       ret = (ret * cs->mult) >> cs->shift;
+       s64 ret;
+       u64 upper, lower, overflow;
+
+       /*
+        * Split the calculation into two halves to ensure
+        * that we can catch any overflow that may occur.
+        */
+       upper = ((cycles >> 32) * cs->mult) >> cs->shift;
+       lower = ((cycles & 0xFFFFFFFF) * cs->mult) >> cs->shift;
+
+       /*
+        * Check to see if the result will overflow. If
+        * overflow is non-zero then the result is greater
+        * than 63-bits which is the max positive value
+        * for a signed result.
+        */
+       overflow = (upper + (lower >> 32)) >> 31;
+
+       /*
+        * If the result overflows, return the max value we can.
+        */
+       if (overflow)
+               ret = LLONG_MAX;
+       else
+               ret = (s64)((upper << 32) + lower);
+
         return ret;
  }

