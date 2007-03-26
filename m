Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbXCZQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbXCZQ1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXCZQ1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 12:27:19 -0400
Received: from www.osadl.org ([213.239.205.134]:42638 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752924AbXCZQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 12:27:17 -0400
Subject: Re: [3/6] 2.6.21-rc4: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <b6a2187b0703252237l4f662fb3n7f57dfb10360c4f6@mail.gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184919.GW752@stusta.de>
	 <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
	 <20070326040509.GU16477@stusta.de>
	 <b6a2187b0703252237l4f662fb3n7f57dfb10360c4f6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 18:26:47 +0200
Message-Id: <1174926407.7911.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 13:37 +0800, Jeff Chua wrote:
> On 3/26/07, Adrian Bunk <bunk@stusta.de> wrote:
> 
> > > Resume from RAM (s2ram) still broke (tried with or without
> > > CONFIG_NO_HZ). Suspend to RAM seems ok, but upon resume, the screen
> > > will only display "inu" and only after pressing the power button will
> > > the system return to console. But "date" still doesn't advance.
> >
> > This might be related to the following regression:
> >
> > Subject    : first disk access after resume takes several minutes
> >              ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
> > References : http://lkml.org/lkml/2007/3/8/117
> >              http://lkml.org/lkml/2007/3/25/20
> > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> >              Ingo Molnar <mingo@elte.hu>
> > Status     : problem is being debugged
> 
> Adrian,
> 
> It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
> suspend and resume from RAM (s2ram). Even better, it works
> with/without CONFIG_NO_HZ.

Does the patch below fix the HPET_TIMER=y case ?

	tglx

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index f3ab61e..76afea6 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -197,7 +197,7 @@ static int hpet_next_event(unsigned long delta,
 	cnt += delta;
 	hpet_writel(cnt, HPET_T0_CMP);
 
-	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0);
+	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
 }
 
 /*



