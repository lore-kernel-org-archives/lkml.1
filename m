Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZELNtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZELNtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZELNtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:49:24 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:34086 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZELNtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:49:23 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 09:49:23 EDT
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: john stultz <johnstul@us.ibm.com>
Cc: George Spelvin <linux@horizon.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ulrich.windl@rz.uni-regensburg.de, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
References: <1242094321.7214.156.camel@localhost.localdomain>
Date: Tue, 12 May 2009 17:20:00 +0400
In-Reply-To: <1242094321.7214.156.camel@localhost.localdomain> (john stultz's
	message of "Mon, 11 May 2009 19:12:01 -0700")
Message-ID: <87d4aejw5b.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:

> Once the tsc_khz value is set in grub, the box will always boot with the
                                                      ^^^^^^
> same value, so the NTP drift value prior to reboot will still be correct
> after rebooting.
No, it won't, because...

>  	tsc_khz = calibrate_tsc();
> +
> +	/*
> +	 * If the calibrated TSC freq and user specified
> +	 * TSC freq are close enough, pick the what the
> +	 * user told us.
> +	 */
> +	difference = abs(tsc_khz - tsc_khz_specified);
> +	if (difference <= tsc_khz >> 10) {      /* 1/1024 = 976 ppm */
> +		printk(KERN_INFO "Using user defined TSC freq: %lu.%03lu MHz\n",
> +			tsc_khz_specified/1000,
> +			tsc_khz_specified%1000);
> +		tsc_khz = tsc_khz_specified;
> +	}
> +

... of this "if".

Please *please* don't set arbitrary limits.  Just use user supplied value.

Or at the very least print big red warning if you are going to ignore a user
supplied option (and have another tsc_khz_really= option to override faulty
calibration routine).
