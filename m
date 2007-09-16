Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbXIPTkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbXIPTkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXIPTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:40:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbXIPTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:40:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Pavel Machek <pavel@ucw.cz>
Subject: Re: regression: fireware causes oops during system
Date: Sun, 16 Sep 2007 21:52:24 +0200
User-Agent: KMail/1.9.5
Cc: Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
References: <20070911190043.GA1577@elf.ucw.cz> <20070916175424.GB11983@elf.ucw.cz> <46ED78DF.2020609@s5r6.in-berlin.de>
In-Reply-To: <46ED78DF.2020609@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162152.24793.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 September 2007 20:41, Stefan Richter wrote:
> (Adding Cc: Rafael, Ingo)
> 
> Pavel Machek wrote:
> >> Dmesg with the oops or/and bisection would be good.
> > 
> > Sorry, had to hand-copy. It is oops at virtual adddress 6b6b6b7b --
> > looks like slab poison to me?
> > 
> > EIP is in task_rq_lock, backtrace is
> > try_to_wake_up
> > highlevel_host_reset
> > ohci_irq_handler
> 
> In reverse order, this trace is most certainly
> 
> 	drivers/ieee1394/ohci1394.c::ohci_irq_handler
> 	drivers/ieee1394/highlevel.c::highlevel_host_reset
> 	drivers/ieee1394/highlevel.c::nodemgr_highlevel.host_reset
> 						== nodemgr_host_reset
> 	kernel/sched.c::wake_up_process(hi->thread);
> 
> with hi->thread being the kthread which executes
> drivers/ieee1394/nodemgr.c::nodemgr_host_thread of the ieee1394 core driver.
> 
> The ieee1394 core has two (or more) threads:  One nodemgr_host_thread
> alias [knodemgrd_*] for each card, and one hpsbpkt_thread alias
> [khpsbpkt] for all cards.  The knodemgrd should be frozen during suspend
> or hibernate, while khpsbpkt should not be frozen in order to let
> transactions to go on in the case of saving the hibernation image to a
> FireWire disk.
> 
> 
> Quoting your other post:
> > On Tue 2007-09-11 21:45:58, Stefan Richter wrote:
> >> Between -rc3 and -rc4:
> >> 
> >> 	ieee1394: sbp2: fix sbp2_remove_device for error cases
> >> 	a2ee3f9bbb0ce57102dad8928d54f59acdc4b8f7
> >> 	should not occur in suspend path
> > 
> > Plus I do not have firewire attached disk here, so sbp2 should not be
> > used, right? 
> 
> Sbp2's host_reset handler would do something if it was loaded even
> without any SBP-2 devices attached,but it wouldn't under any
> circumstances call try_to_wake_up.  Actually with no devices attached it
> would simply "iterate" over an empty list.
> 
> >> Between -rc1 and -rc2:
> >> 
> >> 	ieee1394: sbp2: more correct Kconfig dependencies
> >> 	e4f8cac5e07528f7e0bc21d3682c16c9de993ecb
> >> 	unrelated
> >> 
> >> 	ieee1394: revert "sbp2: enforce 32bit DMA mapping"
> >> 	a9c2f18800753c82c45fc13b27bdc148849bdbb2
> >> 	unrelated
> >> 
> >> 	(not via linux1394-2.6.git)
> >> 	raw1394 __user annotation
> >> 	5b26e64ea39e45802c5736c8261bf8a8704d212f
> >> 	unrelated
> >> 
> >> So it must be something older which was somehow uncovered.
> >> Dmesg with the oops or/and bisection would be good.
> > 
> > The others look even more innocent. I wonder if this may have been
> > responsible?
> > 
> > commit 831441862956fffa17b9801db37e6ea1650b0f69
> > tree b0334921341f8f1734bdd3243de76d676329d21c
> > parent 787d2214c19bcc9b6ac48af0ce098277a801eded
> > author Rafael J. Wysocki <rjw@sisk.pl> Tue, 17 Jul 2007 04:03:35 -0700
> > committer Linus Torvalds <torvalds@woody.linux-foundation.org> Tue, 17
> > Jul 2007 10:23:02 -0700
> > 
> >     Freezer: make kernel threads nonfreezable by default

Well, I don't think so.

nodemgr_host_thread() calls set_freezable() as it should.

Greetings,
Rafael
