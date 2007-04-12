Return-Path: <linux-kernel-owner+w=401wt.eu-S2992557AbXDLPVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992557AbXDLPVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992558AbXDLPVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:21:38 -0400
Received: from mx34.mail.ru ([194.67.23.200]:29542 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992557AbXDLPVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:21:37 -0400
Date: Thu, 12 Apr 2007 19:18:24 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Shem Multinymous <multinymous@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412151824.GA1886@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <41840b750704120800l6ab2b0f8qeda6931d7c7e9bc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <41840b750704120800l6ab2b0f8qeda6931d7c7e9bc6@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shem,

On Thu, Apr 12, 2007 at 11:00:07AM -0400, Shem Multinymous wrote:
> Hi Anton,
> 
> A few comments on the ever-contentious choice of battery attributes:
> 
> On 4/11/07, Anton Vorontsov <cbou@mail.ru> wrote:
> >+ * All voltages, currents, capacities and temperatures in mV, mA, mAh and
> >+ * tenths of a degree unless otherwise stated. It's driver's job to 
> >convert
> >+ * its raw values to which this class operates. If for some reason driver
> >+ * can't afford this requirement, then it have to create its own 
> >attributes,
> >+ * plus additional "XYZ_units" for each of them.
> >+ */
> 
> Many (most, I believe) laptop batteries report capacity in mWh
> (energy), not mAh (charge). You can't convert between the two without
> a detailed, up-to-date physical model of the battery. This is too
> common to relegate to a non-standardized "XYZ_units" extension.

I see. Okay, I'll try to cook something regarding capacity units.

> >+BATTERY_INT_ATTR(min_voltage);
> >+BATTERY_INT_ATTR(min_current);
> >+BATTERY_INT_ATTR(min_capacity);
> >+BATTERY_INT_ATTR(max_voltage);
> >+BATTERY_INT_ATTR(max_current);
> >+BATTERY_INT_ATTR(max_capacity);
> >+BATTERY_INT_ATTR(temp);
> >+BATTERY_INT_ATTR(voltage);
> >+BATTERY_INT_ATTR(current);
> >+BATTERY_INT_ATTR(capacity);
> 
> I suggest adding "remaining operating time" and "remaining charging
> time". You can try deducing these from the above attributes, but in
> practice this gives very inaccurate predictions. On laptops (e.g.,
> ThinkPad) the BIOS or EC often provides much better estimates, using a
> more accurate physical model.

Yes, sure. Feel free to add these attributes to the "standard" ones,
along with your drivers. See (1).

> 
> I also see you omitted a host of other common attributes, like design
> capacity, cycle count, model string, and temperatures. There was an
> extensive LKML discussion of the choice and naming of attributes, in
> the context of David Woodhouse's patch; there are futher observations
> there. Also, here's the list of attributes in my tp_smapi ThinkPad
> driver: http://thinkwiki.org/wiki/tp_smapi#Battery_charge_control_features
> 
> Does "max capaxity" correspond to what's usually denoted "last full 
> capacity".

Yup.

> I understand you allow adding custom attributes, but they're of
> limited use if generic userspace tools don't know their name and
> semantics. It's important to standardize all reasonably common
> attributes.

(1) You're free to add your attribute to "standard" ones in
include/linux/battery.h if it's proven to widely used. Batteries which
do not have such attribute will not even notice that addition, so you
will not have to grep and modify other drivers.

So, that is plain matter of code duplication. If two or more battery
drivers have same attributes, then we can put it in battery.h.
If only one driver using it, then code duplication impossible, and
driver should keep this attribute private.

In handhelds.org tree we have two battery drivers with attributes you
see currently. Second driver is not ready for mainline inclusion yet
(it depends on ADC framework, which we'll present soon), thus I've not
posted it.


Also, APM emulation driver should learn how to use one attribute, or
another depending on which available/better. But this is only technical
question, like

if (battery have attribute1)
	do precise maths of something, because we have mWh;
else
	do approx maths of something, because we have only mAh.
else
	n/a.

>  Shem

Thanks for comments!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
