Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbZEOQgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbZEOQgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZEOQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:36:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51694 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZEOQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:36:19 -0400
Message-ID: <4A0D99E0.3050306@ti.com>
Date: Fri, 15 May 2009 11:35:44 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep   
 formorethan2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>	 <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com> <1242242497.9777.2.camel@jstultz-laptop>
In-Reply-To: <1242242497.9777.2.camel@jstultz-laptop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John Stultz wrote:
>>>> One final question, I noticed in clocksource.h that the definition of 
>>>> function cyc2ns returns a type of s64, however, in the function itself a 
>>>> variable of type u64 is used and returned. Should this function be 
>>>> modified as follows?
>>>>
>>>>   static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
>>>>   {
>>>> -       u64 ret = (u64)cycles;
>>>> +       s64 ret = (s64)cycles;
>>>>          ret = (ret * cs->mult) >> cs->shift;
>>>>          return ret;
>>>>   }
>>> Damn. So this brings up an issue I had missed prior.
>> Any comments on whether this should be u64 versus s64?
> 
> I'd leave it alone for now. I'm concerns that in large multiplies, if
> its a s64 the sign might get extended down by the shift. I need to look
> at it in more detail though.

I have been thinking about this some more and I do agree that there is a 
chance that the multiply could overflow if the "cycles" and "mult" are 
large. From the perspective of the timekeeping_max_deferment() function 
this would be very likely for 64-bit clocksources when the mask will be 
equal to (2^64)-1. Therefore, how about modifying the function as 
follows in order to catch any occurrences of overflow?

Let me know if this is aligned with your thinking or if I am barking up 
the wrong tree here.

Cheers
Jon


diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 507235a..8204373 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -316,8 +316,32 @@ static inline void clocksource_disable(struct 
clocksource *cs)
   */
  static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
  {
-	s64 ret = (s64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
+	s64 ret;
+	u64 upper, lower, overflow;
+
+	/*
+	 * Split the calculation into two halves to ensure
+	 * that we can catch any overflow that may occur.
+	 */
+	upper = ((cycles >> 32) * cs->mult) >> cs->shift;
+	lower = ((cycles & 0xFFFFFFFF) * cs->mult) >> cs->shift;
+
+	/*
+	 * Check to see if the result will overflow. If
+	 * overflow is non-zero then the result is greater
+	 * than 63-bits which is the max positive value
+	 * for a signed result.
+	 */
+	overflow = (upper + (lower >> 32)) >> 31;
+
+	/*
+	 * If the result overflows, return the max value we can.
+	 */
+	if (overflow)
+		ret = LONG_MAX;
+	else
+		ret = (s64)((upper << 32) + lower);
+
  	return ret;
  }

-- 
1.6.1
