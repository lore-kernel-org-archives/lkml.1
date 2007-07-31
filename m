Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbXGaOzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbXGaOzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760392AbXGaOzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:55:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:35290 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759698AbXGaOzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:55:00 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19udj031IJulqYyuSV8F5LtzVutpTa++3JtleF4oc
	dsvtq6V6d929oQ
Date: Tue, 31 Jul 2007 16:54:57 +0200
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, venkatesh.pallipadi@intel.com
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Message-ID: <20070731145456.GB25175@alice>
References: <20070723221630.GA28951@alice> <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com> <20070725113349.GB5469@alice> <200707251250.22469.lenb@kernel.org> <20070725231714.GA24867@alice> <6bffcb0e0707300732s6a63e63g4622ebfbbe26e479@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707300732s6a63e63g4622ebfbbe26e479@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.22.1 (x86_64)
X-Uptime: 16:51:59 up  5:19,  5 users,  load average: 0.40, 0.22, 0.13
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Michal Piotrowski (michal.k.k.piotrowski@gmail.com) wrote:
> Hi Eric,
> 
> On 26/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
> > * Len Brown (lenb@kernel.org) wrote:
> > > > > > > [   13.506890] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
> > > > > > > [   13.507101] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
> > >
> > > Note that these are just noise -- new code being verbose when looking for an optional feature.
> > >
> > > The fact that hitting the power button a bunch of times
> > > to make the system move along suggests some sort of missing interrupt problem --
> > > most likely the timer itself.
> > >
> > > [   13.868574] Probing IDE interface ide0...
> > > [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
> > >
> > > 5-minutes -- a long probe:-)
> > >
> > > > CONFIG_NO_HZ=y
> > >
> > > does CONFIG_NO_HZ=n make a difference?
> >
> > [   41.007654] EXT3 FS on hda1, internal journal
> > [  322.133656] Clocksource tsc unstable (delta = 276476174785 ns)
> > Boot went fine but the system got pretty unresponsive later, 2-3 seconds
> > delay after keypresses on an idle system and a hang during shutdown which i had to resolve by
> > pressing the power button (not to switch it of the hard way, but to keep it rebooting)
> >
> > > > CONFIG_HIGH_RES_TIMERS=y
> > >
> > > does CONFIG_HIGH_RES_TIMERS=n make a difference?
> >
> > doesnt change anything
> >
> > > does "irqpoll" make any difference?
> > > does "notsc" make any difference?
> > > does "idle=poll" make any difference?
> >
> > I tried these with the HIGH_RES_TIMERS=n, irqpoll and notsc dont change
> > a thing, idle=poll makes it boot normally
> 
> Please use git-bisect
> 
> git-bisect start
> git-bisect bad
> git-bisect good 7dcca30a32aadb0520417521b0c44f42d09fe05c


took some time, but i got a scape goat, added venkatesh to the CC list,

greetings, Eric

b8550397f1f3d4b8b2c5257c88dae25d58ed is first bad commit
commit 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Jun 15 19:37:00 2007 -0400

    ACPI: Enable C3 even when PM2_control is zero
    
    On systems that do not have pm2_control_block, we cannot really use
    ARB_DISABLE before C3. We used to disable C3 totally on such systems.
    
    To be compatible with Windows, we need to enable C3 on such systems now.
    We just skip ARB_DISABLE step before entering the C3-state and assume
    hardware is handling things correctly. Also, ACPI spec is not clear
    about pm2_control is _needed_ for C3 or not.
    
    We have atleast one system that need this to enable C3.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

