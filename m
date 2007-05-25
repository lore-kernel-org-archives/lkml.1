Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbXEYTsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbXEYTsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXEYTsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:48:42 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45548 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850AbXEYTsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:48:41 -0400
Date: Fri, 25 May 2007 21:48:39 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/7] ps3: Storage Driver Probing
In-Reply-To: <200705251818.03964.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0705252143270.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.474400000@sonycom.com>
 <200705251818.03964.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Arnd Bergmann wrote:
> On Friday 25 May 2007, Geert.Uytterhoeven@sonycom.com wrote:
> > +static u64 ps3stor_wait_for_completion(u64 devid, u64 tag,
> > +				       unsigned int timeout)
> > +{
> > +	unsigned int retries = 0;
> > +	u64 res = -1, status;
> > +
> > +	for (retries = 0; retries < timeout; retries++) {
> > +		res = lv1_storage_check_async_status(NOTIFICATION_DEVID, tag,
> > +						     &status);
> > +		if (!res)
> > +			break;
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +		schedule_timeout(1);
> > +	}
> 
> Any reason not to use msleep(1) instead of the schedule_timeout?

Not really. I'll change it.

> > +	switch (dev_type) {
> > +	case PS3_DEV_TYPE_STOR_DISK:
> > +		match_id = PS3_MATCH_ID_STOR_DISK;
> > +		break;
> > +
> > +	case PS3_DEV_TYPE_STOR_ROM:
> > +		match_id = PS3_MATCH_ID_STOR_ROM;
> > +		break;
> > +
> > +	case PS3_DEV_TYPE_STOR_FLASH:
> > +		match_id = PS3_MATCH_ID_STOR_FLASH;
> > +		break;
> > +
> > +	default:
> > +		return 0;
> > +	}
> 
> Why do you have separate constants for PS3_DEV_TYPE_* and
> PS3_MATCH_ID_*? If you don't do any conversion, this driver
> will immediately work for additional types as well, if more
> get added later.

The PS3_DEV_TYPE_* IDs are imposed by the repository, as created by the
hypervisor.
The PS3_MATCH_ID_* IDs are created by us, for all PS3-specific devices.
As Geoff already pointed out, we may be able to use PS3_DEV_TYPE_* IDs for
everything, but unfortunately not all PS3-specific devices are present in the
repository.

> > +
> > +//		pr_debug("%s:%u: Checking for new storage devices...\n",
> > +//			 __func__, __LINE__);
> 
> Should be removed, or not in comments, either way is fine, as pr_debug
> normally does not get compiled in anyway.

Oops, forgot to uncomment it (it was a bit noisy while I lived with DEBUG
defined ;-)

> > +		msleep_interruptible(ms);
> > +		if (ms < 60000)
> > +			ms <<= 1;
> 
> Is this timeout only for the disk spinup, or also for detecting media
> added at run time, like inserting a DVD? One minute timeout for
> detecting a DVD would sound very long to me.

It's not for inserting DVDs, only for new devices showing up in the repository.
Apparently new devices may keep on showing up a while after boot up, but I
think this matters only for the kboot kernel, that's why I went with the
exponential back-off with upper limit.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
