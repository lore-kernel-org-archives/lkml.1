Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXCaRTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXCaRTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbXCaRTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:19:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbXCaRTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:19:06 -0400
Date: Sat, 31 Mar 2007 19:17:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, tglx@linutronix.de,
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
Message-ID: <20070331171740.GA11750@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703291546.48996.maximlevitsky@gmail.com> <1175356272.28263.27.camel@localhost.localdomain> <200703311956.35922.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703311004310.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703311004310.6730@woody.linux-foundation.org>
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

> Umm.. WHy not make the device tree look like this:
> 
> 	    -- "clocksource" -- +-- HPET
> 				|
> 				+-- TSC
> 				|
> 				+-- i8259
> 				|
> 				+-- lapic timer
> 				|
> 				.. whatever else
> 
> and use the "struct device" that we *have* for this? The whole "struct 
> device" is literally designed to do this, and to be embedded into 
> whatever bigger structures you have that describes higher-level 
> behaviour. Ie you'd put a "struct device" inside the "struct 
> clocksource".

yeah. There's some practical problems that need to be sorted out: much 
of the current GTOD code is irq-driven (and all GTOD locks are 
irq-safe), while the sysfs code needs to run in process-context level. 

Clocksources 'arrive' and 'depart' in hardirq context (which is the 
primary place where we notice their breakage, determine that they are 
now verified to be usable, etc.). This came partly from legacy: the 
gradual conversion of the monolithic time code, and the need to preserve 
GTOD and non-GTOD architectures without too much duplication. It also 
came partly because there's also a fundamental need to have accurate 
time, which is better served from irq context.

i very much agree that this should and must be cleaned up, but it needs 
quite a bit more logistics than it might appear at first sight. 
Clockevents basically just followed (and had to follow) the direction of 
clocksources in this regard.

	Ingo
