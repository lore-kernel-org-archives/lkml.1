Return-Path: <linux-kernel-owner+w=401wt.eu-S1751117AbZLSFGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbZLSFGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 00:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZLSFGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 00:06:22 -0500
Received: from smtp102.biz.mail.mud.yahoo.com ([68.142.200.237]:25561 "HELO
	smtp102.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750825AbZLSFGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 00:06:21 -0500
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: ._ZibnsVM1nVGnURSljs_XYXCwnP0TO18ORuzB1erC0Ez8Jz6ZCVwz_7g9ZoDKJcdNv7cfDlHKRjl6yPJIjl9dH2umudVy5puOQ0pdTpQWLqKmqz6U5N48KUU7w8V.p8pb_EqUMDtisabAcf5qgMN_ic0JTkh0DmffNTxU0c2ECOhAoy_wYkxzDNydgiO3Y8mZJOEGBLfC.LQAx4jTFGrDf2_grSI_sOA3c6Mx5qpOA2.VSyxZ9QbfgWXcm5iyAVdKdkzVKuws2E_v3HF1IQ0OH1nN7k2qP1BqV7cpDPhQVi31K_pNT2C5PjL3NGnIu71t8IRWkkxsZZy4vE1oMRxSnP6UgVcMD14uz_lXrSxP6k2ERrivO9BHXyejRApKjo4NyyCr.7XA--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
Date: Fri, 18 Dec 2009 21:06:18 -0800
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
References: <200912181813.44220.sfking@fdwdc.com> <200912181920.12905.sfking@fdwdc.com> <1261195463.4115.126.camel@localhost.localdomain>
In-Reply-To: <1261195463.4115.126.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912182106.18709.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009 08:04:23 john stultz wrote:
> On Fri, 2009-12-18 at 19:20 -0800, Steven King wrote:
> > On Friday 18 December 2009 06:44:44 john stultz wrote:
> > > On Fri, Dec 18, 2009 at 6:13 PM, Steven King <sfking@fdwdc.com> wrote:
> > > > Attach is the .config; it works on v2.6.32 but fails to boot on
> > > > .33-rc1; but if I deselect hrtimers && tickless then it works.
> > >
> > > Sorry for the dup, forgot to cc lkml on my reply.
> > >
> > > Fails to boot all together? Or does it hang at some point in the dmesg
> > > that you can point out?
> >
> > fails to boot all together; nothing on the serial console.
> >
> > > Could you run the following so we can narrow down which clocksource
> > > your using? cat
> > > /sys/devices/system/clocksource/clocksource0/current_clocksource cat
> > > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > >
> > > Then with the kernel that doesn't boot, go through the clocksources
> > > listed in available_clocksources and try booting w/
> > > "clocksource=<clock name>" and see if the behavior changes.
> >
> > on the working .32 kernel:
> >
> > # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > pit
> > # cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > pit
> >
> > just to be sure, I tried clocksource=pit on the .33-rc1 kernel.  It didnt
> > make any difference.
>
> Hrmm.. So looking at the code in arch/m68knommu/platform/coldfire/pit.c,
> I'm a little confused on how this got marked as a continuous clocksource
> (CLOCK_SOURCE_IS_CONTINUOUS), especially as it seems it couldn't handle
> skipping an interrupt.
>
> That said, I'm not sure how it worked in 2.6.32, as its been that way
> for awhile it seems.  Maybe my assumptions on how the PIT works is wrong
> (or just biased in how it works on x86)?
>
> Greg, could you clarify how the PIT can be used as a clocksource if its
> also being used in oneshot mode?
>
> Steven, I assume the patch below avoids the issue (by disabling highres
> timers and nohz)?

Yes.

I suspect it wasnt working correctly on earlier kernels, we just got away with 
it; I had recently added ntpclient to this target but the time reported by 
date was always off by some odd amount, I had assume that it was a busybox or 
ntpclient issue but hadnt gotten around to tracking it down.  With your patch 
(or, as I just now verified, on .32 without no_hz and hrtimers) the system 
time is now correct.  I probably never would have made the connection.

Thank you John!

-- 
Steven King -- sfking at fdwdc dot com
