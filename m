Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbXCaREK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbXCaREK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXCaREK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:04:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbXCaREI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:04:08 -0400
Date: Sat, 31 Mar 2007 19:02:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
Message-ID: <20070331170245.GA9244@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <460BBD1B.4040308@ru.mvista.com> <200703291531.18253.maximlevitsky@gmail.com> <200703291546.48996.maximlevitsky@gmail.com> <1175356272.28263.27.camel@localhost.localdomain> <Pine.LNX.4.64.0703310908160.6730@woody.linux-foundation.org> <1175358800.28263.36.camel@localhost.localdomain> <Pine.LNX.4.64.0703310943190.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703310943190.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 31 Mar 2007, Thomas Gleixner wrote:
> > 
> > Right, but clock - sources/events need to be extremly late suspended and
> > early resumed. How can we ensure this ?

[...]
> So the only thing that needs to be done is to make sure that we add 
> the timer devices early during bootup - something we have to do 
> *anyway*. If a device is added early in bootup, that automatically 
> means that it will be suspended late, and resumed early - because we 
> maintain that order all the way through..

IIRC hpet is particularly hard to initialize early on in the bootup 
sequence. So the way the clockevents code works is that it will always 
try to make the best out of all available devices, and dynamically 
adapts things as devices 'arrive' or 'depart' - no matter how late that 
happens. (That way there's no dependency on how late a device gets 
registered - it will only delay the switch to high-res mode for 
example.) A given time device might 'depart' because for example the 
watchdog mechanism finds that its quality is not good enough, or because 
someone initiated cpufreq which breaks the TSC clocksource.

i dont think there's any particular problem here because suspend/resume 
wont be done during bootup - but we might need a way to move a device to 
earlier spots in the device tree, even if they got registered later on - 
instead of forcing the time devices to be registered very early?

	Ingo
