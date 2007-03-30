Return-Path: <linux-kernel-owner+w=401wt.eu-S1750881AbXC3Rqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881AbXC3Rqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXC3Rqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:46:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41633 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbXC3Rqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:46:31 -0400
Date: Fri, 30 Mar 2007 19:46:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known regressions"
Message-ID: <20070330174619.GA12589@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070330141639.GA10387@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330141639.GA10387@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> >  BUG: at drivers/base/driver.c:187 driver_unregister()
> >   [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
> >   [<c01063e2>] show_trace+0x12/0x14
> >   [<c01063f8>] dump_stack+0x14/0x16
> >   [<c063f7e6>] driver_unregister+0x3d/0x43
> >   [<c0488048>] pci_unregister_driver+0x10/0x5f
> >   [<c1b5f7c7>] slgt_init+0x9b/0x1ca
> >   [<c1b31a2d>] init+0x15d/0x2bd
> >   [<c0105bc3>] kernel_thread_helper+0x7/0x10

> Yes, we should allow the ability to call unregister_driver from within 
> the module_init function.
> 
> But I don't understand what is causing you to see this problem.  Who 
> is holding the reference on the struct device at this point in time?  
> Is it the fact that userspace has some files open and it hasn't 
> released them yet?

at least in the slgt_init() case the affected codepath is trivial:

        if ((rc = pci_register_driver(&pci_driver)) < 0) {
                printk("%s pci_register_driver error=%d\n", driver_name, rc);
                return rc;
        }
        pci_registered = 1;

        if (!slgt_device_list) {
                printk("%s no devices found\n",driver_name);
                pci_unregister_driver(&pci_driver);
                return -ENODEV;

slgt_device_list is NULL because no matching PCI ID is on my system (i 
dont have this hardware), so the ->probe() function did not get called 
at all.

i.e. a pure pci_register_driver() + pci_unregister_driver() sequence 
seems to cause a hang. I.e. it seems to be a pure driver-base-core 
matter.

	Ingo
