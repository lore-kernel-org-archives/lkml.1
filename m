Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXB0JZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXB0JZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965057AbXB0JZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:25:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:41808 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964863AbXB0JZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:25:08 -0500
X-Provags-ID: V01U2FsdGVkX18uCm1R+eIuCrrDoMAKYIhHq2NRBMI3V0ru0zdv6k
	a+aw==
Subject: Re: [patch] Re: linux-2.6.today: rtc_cmos init oops/panic in
	rtc_sysfs_remove_device()
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: a.zummo@towertech.it
In-Reply-To: <1172392313.6888.23.camel@Homer.simpson.net>
References: <1171967177.6939.10.camel@Homer.simpson.net>
	 <1172392313.6888.23.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 10:25:05 +0100
Message-Id: <1172568305.7009.39.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 09:32 +0100, Mike Galbraith wrote:

> Fix NULL pointer dereference in cmos_rtc registration failure path.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 7a0d8ee..9201786 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -113,10 +113,10 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
>   */
>  void rtc_device_unregister(struct rtc_device *rtc)
>  {
> +	class_device_unregister(&rtc->class_dev);
>  	mutex_lock(&rtc->ops_lock);
>  	rtc->ops = NULL;
>  	mutex_unlock(&rtc->ops_lock);
> -	class_device_unregister(&rtc->class_dev);
>  }
>  EXPORT_SYMBOL_GPL(rtc_device_unregister);

However, re-enabling CONFIG_DEBUG_SLAB which somehow got disabled
emitted the below.

[   36.765977] rtc_cmos 00:03: rtc intf: sysfs
[   36.779301] rtc_cmos 00:03: rtc intf: proc
[   36.792557] rtc_cmos 00:03: rtc intf: dev (239:0)
[   36.806139] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   36.821017] rtc_cmos 00:03: i/o registers already in use
[   36.834992] rtc_cmos 00:03: removing char 239:0
[   36.848268] pnp: Device 00:03 does not support disabling.
[   36.862282] rtc_cmos: probe of 00:03 failed with error -16
[   36.876394] md: linear personality registered for level -1
[   36.890508] md: raid0 personality registered for level 0
[   36.904563] md: raid1 personality registered for level 1
[   36.918454] md: raid10 personality registered for level 10
[   36.949187] raid6: int32x1    722 MB/s
[   36.978092] raid6: int32x2    800 MB/s
[   37.006101] raid6: int32x4    917 MB/s
[   37.034047] raid6: int32x8    671 MB/s
[   37.062030] raid6: mmxx1     2371 MB/s
[   37.090000] raid6: mmxx2     3066 MB/s
[   37.118001] raid6: sse1x1    1449 MB/s
[   37.145964] raid6: sse1x2    2699 MB/s
[   37.172947] raid6: sse2x1    2222 MB/s
[   37.199912] raid6: sse2x2    3375 MB/s
[   37.210371] raid6: using algorithm sse2x2 (3375 MB/s)
[   37.222143] md: raid6 personality registered for level 6
[   37.234127] md: raid5 personality registered for level 5
[   37.245889] md: raid4 personality registered for level 4
[   37.257313] raid5: automatically using best checksumming function: pIII_sse
[   37.274853]    pIII_sse  :  3812.000 MB/sec
[   37.284947] raid5: using function: pIII_sse (3812.000 MB/sec)
[   37.296648] md: multipath personality registered for level -4
[   37.308377] Slab corruption: start=dfede248, len=512
[   37.319200] Redzone: 0x5a2cf071/0x5a2cf071.
[   37.329211] Last user: [<c03c8ab2>](rtc_device_release+0x31/0x34)
[   37.341274] 0b0: 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b
[   37.353894] Prev obj: start=dfede03c, len=512
[   37.364285] Redzone: 0x5a2cf071/0x5a2cf071.
[   37.374409] Last user: [<c0408643>](skb_release_data+0x57/0x79)
[   37.386402] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[   37.399116] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[   37.411788] Next obj: start=dfede454, len=512
[   37.422309] Redzone: 0x170fc2a5/0x170fc2a5.
[   37.432642] Last user: [<c0350168>](device_create+0x2b/0xa3)
[   37.444670] 000: 01 00 00 00 00 00 00 00 5c e4 ed df 5c e4 ed df
[   37.457532] 010: 73 f2 34 c0 ff f0 34 c0 00 00 00 00 00 00 00 00
[   37.470429] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com

Darn.

	-Mike

