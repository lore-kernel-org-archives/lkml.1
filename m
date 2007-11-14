Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbXKNH5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbXKNH5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXKNH5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:57:23 -0500
Received: from www.tglx.de ([62.245.132.106]:43371 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXKNH5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:57:23 -0500
Date: Wed, 14 Nov 2007 08:57:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "David P. Reed" <dpreed@reed.com>
cc: linux-kernel@vger.kernel.org, Allessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] time: fix typo that makes sync_cmos_clock erratic
In-Reply-To: <4738872D.7020706@reed.com>
Message-ID: <alpine.LFD.0.9999.0711140850210.3265@localhost.localdomain>
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com>
 <1184274754.12353.254.camel@chaos> <4738872D.7020706@reed.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, 12 Nov 2007, David P. Reed wrote:

> From: David P. Reed
> 
> Fix a typo in ntp.c that has caused updating of the persistent (RTC) clock
> when synced to NTP to behave erratically.

Good catch.

> Signed-off-by: David P. Reed

Whitespace damaged as well. Please fix and resend

> ---
> When debugging a freeze that arises on my AMD64 machines when I run the 
> ntpd service, I added a number of printk's to monitor the sync_cmos_clock
> procedure.  I discovered that it was not syncing to cmos RTC every 11 minutes
> as documented, but instead would keep trying every second for hours at a time.
> The reason turned out to be a typo in sync_cmos_clock, where it attempts to
> ensure that update_persistent_clock is called very close to 500 msec. after a
> 1 second boundary (required by the PC RTC's spec). That typo referred to
> "xtime" in one spot, rather than "now", which is derived from "xtime" but not
> equal to it.  This makes the test erratic, creating a "coin-flip" that decides
> when update_persistent_clock is called - when it is called, which is rarely,
> it may be at any time during the one second period, rather than close to 500
> msec, so the value written is needlessly incorrect, too.

Please put the explanation into the changelog.

> The patch works in 2.6.24rc2, but it should also work in 2.6.23.

Yup
 
> @@ -205,7 +206,10 @@ static void sync_cmos_clock(unsigned lon
>         return;
> 
>     getnstimeofday(&now);
> -    if (abs(xtime.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)

Can we just s/xtime/now/ ? There is no value in an extra variable.

Thanks,

	tglx

