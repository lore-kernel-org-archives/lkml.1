Return-Path: <linux-kernel-owner+w=401wt.eu-S936077AbXHLR3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936077AbXHLR3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761103AbXHLR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:29:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759741AbXHLR3U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:29:20 -0400
Date: Sun, 12 Aug 2007 10:27:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IklscG8gSuRydmluZW4i?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: v2.6.23-rc2 locks up during boot (without acpi=off)
Message-Id: <20070812102754.a785e78a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708122003590.25605@kivilampi-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0708012131480.1479@kivilampi-30.cs.helsinki.fi>
	<20070812012826.cfc9f5bb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708121154150.31747@kivilampi-30.cs.helsinki.fi>
	<20070812092708.23d0c21c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708122003590.25605@kivilampi-30.cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 20:15:51 +0300 (EEST) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> On Sun, 12 Aug 2007, Andrew Morton wrote:
> 
> > On Sun, 12 Aug 2007 14:20:46 +0300 (EEST) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> > > On Sun, 12 Aug 2007, Andrew Morton wrote:
> > > > On Sat, 11 Aug 2007 15:39:30 +0300 (EEST) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> > > > 
> > > > > I noticed that v2.6.23-rc1 locks up during boot, same thing happens now 
> > > > > with the latest linus' tree (+net-2.6.24 and tcp-2.6 tree stuff on top 
> > > > > of it; in -rc1 test they weren't though). The exact location of hang
> > > > > varies a bit though. No OOPS, does not respond to sysrq or anything else 
> > > > > besides reset. Last known bootable one is something like 2.6.22-rc4 
> > > > > (I usually run 2.6.21.5 on this machine, haven't tried any 2.6.22 on
> > > > > this after those rcs). Problem seems to start after this line:
> > > > > 
> > > > > Time: acpi_pm clocksource has been installed.
> > > > > 
> > > > > ...the power led starts blinking (not periodic cycle but more or less 
> > > > > varying on-off cycle, never seen that led blink before at all, didn't know 
> > > > > that one can make it blink :-)) and the machine gets consideably slower 
> > > > > too. Never have it been able to complete booting all they way up to login 
> > > > > prompt before lock up.
> > > > > 
> > > > > Tried with acpi=off, boots just fine.
> > > >
> > > > It'd be great if you could run a git bisection search please.
> > > 
> > > [...snip...]
> > > 
> > > ...didn't bother to go any further as the other one just deals with printk 
> > > string... So this is the main suspect:
> > > 
> > > commit 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
> > > Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > Date:   Fri Jun 15 19:37:00 2007 -0400
> > > 
> > >     ACPI: Enable C3 even when PM2_control is zero
> > >     
> > >     On systems that do not have pm2_control_block, we cannot really use
> > >     ARB_DISABLE before C3. We used to disable C3 totally on such systems.
> > >     
> > >     To be compatible with Windows, we need to enable C3 on such systems now.
> > >     We just skip ARB_DISABLE step before entering the C3-state and assume
> > >     hardware is handling things correctly. Also, ACPI spec is not clear
> > >     about pm2_control is _needed_ for C3 or not.
> > >     
> > >     We have atleast one system that need this to enable C3.
> > >     
> > >     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > > 
> > 
> > OK, that's great, thanks.  So just to double-check, could you please
> > confirm that the below reversion fixes this post-2.6.22 regression?
> 
> Hmm, it was really worth of it, I did:
> $ git-fetch linus
> $ git-reset --hard linus
> [...make & install & boot...]
> 
> ...and voila, the problem went away, so something else seems to have
> fixed it between: ac07860264bd and 963c6527e0a0e. As you can notice,
> I didn't even have to revert it (I was just double checking current
> mainline first).
> 
> Is there a need to get a more detailed view about the cause or something, 
> or are details of this issue clear enough to everyone? I can do some more 
> research if necessary, though expect a bit longer latencies during the 
> next week...
> 
> In case none, thanks everyone, this issue seems solved. :-)
> 

We just had an acpi commit.  Something like ed3110efb538d7acbf635095c1382118f7414f75
might have fixed this.

