Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZBCREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZBCREt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBCREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:04:41 -0500
Received: from ns1.suse.de ([195.135.220.2]:51707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZBCREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:04:40 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: cpufreq on demand governor sampling rate restricted to HZ even on NO_HZ kernels
Date: Tue, 3 Feb 2009 18:04:35 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200901301559.15170.trenn@suse.de> <1233336496.13694.49.camel@jamoon.sc.intel.com>
In-Reply-To: <1233336496.13694.49.camel@jamoon.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031804.36497.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 18:28:16 Pallipadi, Venkatesh wrote:
> On Fri, 2009-01-30 at 06:59 -0800, Thomas Renninger wrote:
> > Hi,
> >
> > depending on HZ set to:
> >
> > 100
> > 250
> > 1000
> >
> > the ondemand governor is currently limited to poll the CPU load
> > and adjust the frequency (sampling rate sysfs variable) every:
> >
> > 200ms
> > 80ms
> > 20ms
> >
> > This limitation does not consider NO_HZ which looks wrong?
> > If this is correct, can someone give me a pointer, I'd like
> > to understand why.
>
> That is wrong.
I think I got it now. I first thought my above assumptions are wrong.
Double checking tells me that above assumptions are right, but you
agree that the ondemand minimum sampling is wrong, is that correct?

Can a system fall back to periodic timers, once NO_HZ is active?
Or is NO_HZ always active, once no_hz=off boot param and timer
requirements are analyzed?
Then a rather low value could just be added to ondemand if no_hz is
active, checking what is allowed to be written to ondemand/sampling_rate
and that's it.
What could be sane minimum sampling rate value, the ondemand governor
would set the deferrable timer to?

> ondemand sampling_rate should not limit the sampling rate
> based on HZ when NO_HZ is configured. The idle statistics is not limited
> by HZ rate with NO_HZ, as we will have idle microaccounting.
>
> > If NO_HZ can/should go down to 20ms polling and more (current
> > CPUs are able to switch fast enough, so that the ondemand governor
> > would calculate the default polling interval below 80ms for them),
> > this would hurt in respect of C-states at some point.
> >
> > For performance reasons, one wants to poll as much as possible, for
> > powersaving reasons (C-states), one wants to poll as seldom as
> > possible.
> >
> > I wonder whether it makes sense to dynamically adjust the polling
> > interval (e.g. by a hint (and initial wakeup) from the scheduler or
> > taking C-states into account) to:
> >   - increase the sampling rate, e.g. based on context switching
> >     activity
> >   - lower sampling rate when the system is idle (to gain
> >     full C-state efficiency)
> > Or in what other way deep C-states could be taken into account
> > in respect of ondemand polling?
>
> ondemand polling uses deferrable timer and hence will not be called
> frequently on a totally idle CPU. The main reason we did not do the
> dynamic sampling_rate is because it increases the ondemand response time
> with a sudden increase of load, which is not liked by most workloads.

Neat. I didn't know about the deferrable timer, thanks.

    Thomas
