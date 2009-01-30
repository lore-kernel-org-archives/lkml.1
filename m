Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZA3UaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZA3UaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZA3UaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:30:05 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36359 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZA3UaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:30:01 -0500
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <49834F30.3040706@ti.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>
	 <1233081369.28350.68.camel@jamoon.sc.intel.com>
	 <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>
	 <4981D957.8040409@ti.com>
	 <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
	 <49834F30.3040706@ti.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 12:29:56 -0800
Message-Id: <1233347396.8861.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 13:04 -0600, Jon Hunter wrote:
> john stultz wrote:
> > As an aside, there are some further hardware limitations in the
> > timekeeping core that limit the amount of time the hardware can sleep.
> > For instance, the acpi_pm clocksource wraps every 2.5 seconds or so,
> > so we have to wake up periodically to sample it to avoid wrapping
> > issues.
> > 
> > Just to be able to deal with all the different hardware out there, the
> > timekeeping core expects to wake up twice a second to do this
> > sampling. It may be possible to push this out if you are using other
> > clocksources (HPET/TSC), but if sleeps for longer then a second are a
> > needed feature, we probably will need some infrastructure in the
> > timekeeping core that can be queried to make sure its safe.
> 
> The variable "max_delta_ns" is used by the dynamic tick to govern the 
> maximum time a given device can sleep. Hence, this variable should be 
> configured as necessary for the device you are using. Therefore, if your 
> device has a timer that will wrap every 2.5 seconds, then for this 
> device the "max_delta_ns" should be configure so that it does not exceed 
> this time.
> 
> So what I was proposing is that for devices that have timers that would 
> allow you to sleep beyond ~2.15 seconds (current max imposed by the 
> clockevent_delta2ns function), why not increase the dynamic range (make 
> this a 64-bit variable) or base (ie. from nanoseconds to milliseconds) 
> to permit longer sleep times for devices that can support them? This 
> should not have any negative impact on devices that cannot support such 
> long sleep times.

No objection to max_delta_ns being increased, but whatever code manages
it will probably need to query the timekeeping core in some fashion to
make sure the timer hardware max isn't larger then the clocksource
hardware max. I've provided a rough sketch at what the timekeeping code
would probably look like below.

> So far I have not encountered any issues with doing this. Let me know if 
> this does or does not address your concerns.

There may be some other issues here, such as NTP over-correction issues
(for instance: ntp trying to correct for a 1us offset over the next
second, but ends up applying it for 10 seconds) if we defer for a really
long time. But at that point, we might as well suspend to ram, like the
OLPC does.

thanks
-john


diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 900f1b6..2cf9ebd 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -265,6 +265,21 @@ int timekeeping_valid_for_hres(void)
 	return ret;
 }
 
+
+u64 timekeeping_max_deferment(void)
+{
+	u64 max_nsecs
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		max_nsecs = cyc2ns(clock, clock->mask);
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	return max_nsecs; /* XXX maybe reduce by some amount to be safe? */
+}
+
+
 /**
  * read_persistent_clock -  Return time in seconds from the persistent clock.
  *


