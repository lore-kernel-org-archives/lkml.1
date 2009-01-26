Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZAZVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZAZVmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZAZVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:41:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35221 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZAZVln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:41:43 -0500
From: "Hunter, Jon" <jon-hunter@ti.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 15:41:00 -0600
Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Topic: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Index: Acl22NMmPRfHmhnyTuem0+yaDRLXwwJCC58gAAMph9AAAmHCAA==
Message-ID: <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh <mailto:venkatesh.pallipadi@intel.com> wrote on Monday, January 26, 2009 1:48 PM:

> I looked at your patch earlier, but I was concerned about few
> things and wanted to spend some more time on it. So, I did
> not reply earlier.

No problem, I was not sure how clear my original email was :-)

> The potential issues I see:
> - May be a bit theoritcal, as this may not happen in reality.
> But, with your change, if all the timers happen to be
> defrrable, timer wheel never advances and none of the timers
> expire. Not sure whether we need to handle this cleanly
> somehow or assume that not all the timers will be deferrable.

So my understanding is, and please correct me if I am wrong, but as long as there is a timer interrupt then the timer wheel will advanced and all deferred timer functions will get executed. If that is the case then we should always be guaranteed a timer interrupt due to the implementation of the dynamic tick.

The dynamic tick defines a maximum sleep period, max_delta_ns, which is a member of the "clock_event_device" structure. This governs the maximum time you could be asleep/idle for. Currently, the variable, "max_delta_ns", is defined as a 32-bit type (long) and for most architectures, if not all, this is configured by calling function "clockevent_delta2ns()". The maximum value that "max_delta_ns" can be assigned by calling clockevent_delta2ns(), is LONG_MAX (0x7fffffff). In nanoseconds the value 0x7fffffff equates to ~2.15 seconds. Hence, the maximum sleep time is ~2.15 seconds and at a minimum we should have at least 1 timer interrupt every ~2.15 seconds.

Do you think that this would be sufficient?

I am actually thinking about proposing another idea to increase the dynamic range of max_delta_ns to we could sleep for longer than ~2.15 seconds.

> - Another similar case is when we have more of deferrable
> timers in the system, if we do not cascade timers from the
> timer wheel, we may end up spending more time in the higher
> order timer wheel looking through all the timers, as they are
> at a higher timer granularity, instead of on the lower order
> timer wheel which will have timers sorted at a lower granularity.

Good point. I don't like the thought spending a lot of time searching through timers. However, on the other hand you could debate that the current implementation of categorising the timer events is designed to make this efficient as possible. So would this be a bad thing?

Anyway, you do confirm that the deferrable timer patch was implemented only to defer timers in the tv1 group?

> I am not sure whether any of these issues will be a problem
> in real world or not. But, I think they are something we
> should be careful about.

Completely, agree. I have been playing around with this on my setup, but the last thing I would want to do is introduce a bug. Hence, thanks for spending sometime to discuss this.

Cheers
Jon
