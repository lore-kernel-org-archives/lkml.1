Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZCLJeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZCLJeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZCLJeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:34:08 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2976 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751728AbZCLJeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:34:07 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 6/7] mmc_spi: convert timeout handling to jiffies and avoid busy waiting
Date: Thu, 12 Mar 2009 10:33:41 +0100
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111945.22597.david-b@pacbell.net>
In-Reply-To: <200903111945.22597.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903121033.42257.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Am Donnerstag, 12. März 2009 schrieb David Brownell:
> > o SD/MMC card timeouts can be very high. So avoid busy-waiting,
> >   using the scheduler. Calculate all timeouts in jiffies units,
> >   because this will give us the correct sign when to involve
> >   the scheduler.
>
> Of these patches, this is the one that bothers me the most.
>
> First, earlier versions used jiffies ... but switching to
> ktime sped things up.  (I forget the details by now.)

I doubt that it was the switching to ktime_t that sped things up.
(In fact, I found that mmc_spi.c uses ktime_t from the first moment it was 
included in the kernel 2007). Maybe a earlier version used jiffies, but
I have not find it.

The computing power needed for jiffies (32 bit) can not be more than the 
computing power for ktime_t (2x32 or 64 bit).

In fact, ktime_t with its nanosecond resolution seems to be an overkill if 
there are timeouts in the area of 10 .. 3000 ms.

My goal in programming is to keep it as simple and lightwight as possible.

> So it's odd to think that switching again could improve
> things.

Using jiffies does not sped up. This can't be. Speed is a matter of the fast 
reaction of the SD card. All we can do in the driver is to poll often, so 
that we do not incure an additional delay here.

My rationale for using jiffies is:

o The creator of an (embedded) system is choosing a value for HZ. A jiffie may 
be 10ms or 1ms. The creator chooses this value due to the soft realtime 
requirements of the system. So the value of HZ is a good estimation of the 
expected reaction time of the system.

o So if I use the value of HZ and say: "if I do busy waiting and polling for 
less than a jiffie, it's giving me fastest possible reaction time, without 
violating the expectation of the overall reaction time of the system".

o If I have to wait for MORE than a jiffie, I start to release computing power 
to other tasks in the system, but continue to poll with a resolution of 
jiffies. So the worst additional delay I impose will be a jiffie, and not 
more. I use the fact that the scheduler prefers friendly processes which
call schedule() often.

> Second, as someone previously pointed out, there's a comment
> there about switching to sleep() calls ... did you explore
> just kicking in schedule_hrtimeout() or somesuch, right at
> that point?

If I use a xxx_timeout() function, there will be fewer pollings because until 
the xxx_timeout function returns, there will be no polling, even if the whole 
system is idle.

And the result of the schedule_hrtimeout() is that the task is in the running 
state afterwards. The next poll of the SD card will happen if the scheduler 
selects this task to actually run. This is no difference to schedule().

So I expect the schedule_hrtimeout() function to perform worse as schedule(), 
because of the fewer polls. (The system may be more idle and conserve power 
during the waiting-for-response-time).  

> Heck, just calling schedule() would cut the busy-wait overhead...

Yepp. That's my primary goal. Some soft realtime tasks need to run in my 
target system...

So the overall result of my patch is:

o if the system is idle (expect for the file-IO-process), SD card IO 
performance will be the same as before, because schedule() will return 
immediately.

o if there are other tasks in the running state beside the file-IO-process, 
these tasks will run (not blocked as before) during the busy time of the SD 
card. Throughput to SD card will suffer a bit, but not notable. (Because the 
long waiting times only kick in if the SD card has to flush its internal 
buffers).

I have a takeMS SDHC card (speed class 6). If you write a continous data 
stream to the card, there is ONE long waiting time of 900ms for each 10s of 
stream writing. This was the worst timing I observed.

Hey, if someone comes with a better patch, I will appreciate it!

best regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
