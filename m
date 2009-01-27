Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZA0SpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZA0SpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZA0Soz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:44:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:57755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZA0Soz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,333,1231142400"; 
   d="scan'208";a="425919278"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Hunter, Jon" <jon-hunter@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 27 Jan 2009 10:45:36 -0800
Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Topic: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Index: AcmArqYMOUZ57N6HSYW1dNJq1I5nmwAAKo9Q
Message-ID: <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>
 <1233081369.28350.68.camel@jamoon.sc.intel.com>
In-Reply-To: <1233081369.28350.68.camel@jamoon.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0RIjBwM026404

 
Oops. Sending with correct address this time.

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>Pallipadi, Venkatesh
>Sent: Tuesday, January 27, 2009 10:36 AM
>To: Hunter, Jon
>Cc: Andrew Morton; linux-kernel@vger.kernel.org; Thomas Gleixner
>Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
>
>On Mon, 2009-01-26 at 13:41 -0800, Hunter, Jon wrote:
>> Pallipadi, Venkatesh <mailto:venkatesh.pallipadi@intel.com> 
>wrote on Monday, January 26, 2009 1:48 PM:
>> 
>> > I looked at your patch earlier, but I was concerned about few
>> > things and wanted to spend some more time on it. So, I did
>> > not reply earlier.
>> 
>> No problem, I was not sure how clear my original email was :-)
>> 
>> > The potential issues I see:
>> > - May be a bit theoritcal, as this may not happen in reality.
>> > But, with your change, if all the timers happen to be
>> > defrrable, timer wheel never advances and none of the timers
>> > expire. Not sure whether we need to handle this cleanly
>> > somehow or assume that not all the timers will be deferrable.
>> 
>> So my understanding is, and please correct me if I am wrong, 
>but as long as there is a timer interrupt then the timer wheel 
>will advanced and all deferred timer functions will get 
>executed. If that is the case then we should always be 
>guaranteed a timer interrupt due to the implementation of the 
>dynamic tick.
>> 
>> The dynamic tick defines a maximum sleep period, 
>max_delta_ns, which is a member of the "clock_event_device" 
>structure. This governs the maximum time you could be 
>asleep/idle for. Currently, the variable, "max_delta_ns", is 
>defined as a 32-bit type (long) and for most architectures, if 
>not all, this is configured by calling function 
>"clockevent_delta2ns()". The maximum value that "max_delta_ns" 
>can be assigned by calling clockevent_delta2ns(), is LONG_MAX 
>(0x7fffffff). In nanoseconds the value 0x7fffffff equates to 
>~2.15 seconds. Hence, the maximum sleep time is ~2.15 seconds 
>and at a minimum we should have at least 1 timer interrupt 
>every ~2.15 seconds.
>> 
>> Do you think that this would be sufficient?
>
>Agreed. timer interrupt with its max_delta will avoid the situation I
>was thinking above.
>
>> I am actually thinking about proposing another idea to 
>increase the dynamic range of max_delta_ns to we could sleep 
>for longer than ~2.15 seconds.
>
>max_delta would depend on the timer in the platform. With HPET this
>should be much larger than 2.15 secs.
>
>> > - Another similar case is when we have more of deferrable
>> > timers in the system, if we do not cascade timers from the
>> > timer wheel, we may end up spending more time in the higher
>> > order timer wheel looking through all the timers, as they are
>> > at a higher timer granularity, instead of on the lower order
>> > timer wheel which will have timers sorted at a lower granularity.
>> 
>> Good point. I don't like the thought spending a lot of time 
>searching through timers. However, on the other hand you could 
>debate that the current implementation of categorising the 
>timer events is designed to make this efficient as possible. 
>So would this be a bad thing?
>> 
>> Anyway, you do confirm that the deferrable timer patch was 
>implemented only to defer timers in the tv1 group?
>> 
>
>Yes. The initial deferrable timer was done only for tv1 group on
>purpose. To keep things simpler and that would catch most of 
>the "small"
>timers and avoid them.
>
>> > I am not sure whether any of these issues will be a problem
>> > in real world or not. But, I think they are something we
>> > should be careful about.
>> 
>> Completely, agree. I have been playing around with this on 
>my setup, but the last thing I would want to do is introduce a 
>bug. Hence, thanks for spending sometime to discuss this.
>
>Ok. ï»¿Thinking about it a bit more, I think we can push this 
>patch along.
>Thomas/Andrew, can one of you pick up this patch..
>
>Thanks,
>Venki
>
>Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
>--
>To unsubscribe from this list: send the line "unsubscribe 
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
