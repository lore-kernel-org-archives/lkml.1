Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbXIPSmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbXIPSmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXIPSmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:42:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55414 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXIPSml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:42:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46ED78DF.2020609@s5r6.in-berlin.de>
Date: Sun, 16 Sep 2007 20:41:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: regression: fireware causes oops during system
References: <20070911190043.GA1577@elf.ucw.cz> <1189537716.7620.192.camel@cunning> <46E6ECAA.30601@s5r6.in-berlin.de> <46E6F076.5000006@s5r6.in-berlin.de> <20070916175424.GB11983@elf.ucw.cz>
In-Reply-To: <20070916175424.GB11983@elf.ucw.cz>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Cc: Rafael, Ingo)

Pavel Machek wrote:
>> Dmesg with the oops or/and bisection would be good.
> 
> Sorry, had to hand-copy. It is oops at virtual adddress 6b6b6b7b --
> looks like slab poison to me?
> 
> EIP is in task_rq_lock, backtrace is
> try_to_wake_up
> highlevel_host_reset
> ohci_irq_handler

In reverse order, this trace is most certainly

	drivers/ieee1394/ohci1394.c::ohci_irq_handler
	drivers/ieee1394/highlevel.c::highlevel_host_reset
	drivers/ieee1394/highlevel.c::nodemgr_highlevel.host_reset
						== nodemgr_host_reset
	kernel/sched.c::wake_up_process(hi->thread);

with hi->thread being the kthread which executes
drivers/ieee1394/nodemgr.c::nodemgr_host_thread of the ieee1394 core driver.

The ieee1394 core has two (or more) threads:  One nodemgr_host_thread
alias [knodemgrd_*] for each card, and one hpsbpkt_thread alias
[khpsbpkt] for all cards.  The knodemgrd should be frozen during suspend
or hibernate, while khpsbpkt should not be frozen in order to let
transactions to go on in the case of saving the hibernation image to a
FireWire disk.


Quoting your other post:
> On Tue 2007-09-11 21:45:58, Stefan Richter wrote:
>> Between -rc3 and -rc4:
>> 
>> 	ieee1394: sbp2: fix sbp2_remove_device for error cases
>> 	a2ee3f9bbb0ce57102dad8928d54f59acdc4b8f7
>> 	should not occur in suspend path
> 
> Plus I do not have firewire attached disk here, so sbp2 should not be
> used, right? 

Sbp2's host_reset handler would do something if it was loaded even
without any SBP-2 devices attached,but it wouldn't under any
circumstances call try_to_wake_up.  Actually with no devices attached it
would simply "iterate" over an empty list.

>> Between -rc1 and -rc2:
>> 
>> 	ieee1394: sbp2: more correct Kconfig dependencies
>> 	e4f8cac5e07528f7e0bc21d3682c16c9de993ecb
>> 	unrelated
>> 
>> 	ieee1394: revert "sbp2: enforce 32bit DMA mapping"
>> 	a9c2f18800753c82c45fc13b27bdc148849bdbb2
>> 	unrelated
>> 
>> 	(not via linux1394-2.6.git)
>> 	raw1394 __user annotation
>> 	5b26e64ea39e45802c5736c8261bf8a8704d212f
>> 	unrelated
>> 
>> So it must be something older which was somehow uncovered.
>> Dmesg with the oops or/and bisection would be good.
> 
> The others look even more innocent. I wonder if this may have been
> responsible?
> 
> commit 831441862956fffa17b9801db37e6ea1650b0f69
> tree b0334921341f8f1734bdd3243de76d676329d21c
> parent 787d2214c19bcc9b6ac48af0ce098277a801eded
> author Rafael J. Wysocki <rjw@sisk.pl> Tue, 17 Jul 2007 04:03:35 -0700
> committer Linus Torvalds <torvalds@woody.linux-foundation.org> Tue, 17
> Jul 2007 10:23:02 -0700
> 
>     Freezer: make kernel threads nonfreezable by default
> 
> Or this one?
> 
> commit 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
> tree 415c4453d2b17a50abe7a3e515177e1fa337bd67
> parent 64fb98fc40738ae1a98bcea9ca3145b89fb71524
> author Paul Mundt <lethal@linux-sh.org> Fri, 20 Jul 2007 10:11:58
> +0900
> committer Paul Mundt <lethal@linux-sh.org> Fri, 20 Jul 2007 10:11:58
> +0900
> 
>     mm: Remove slab destructors from kmem_cache_create().
> 
>     Slab destructors were no longer supported after Christoph's
>     c59def9f222d44bb7e2f0a559f2906191a0862d7 change. They've been
>     BUGs for both slab and slub, and slob never supported them
>     either.

Both of these went in during the merge window between 2.6.22 and 2.6.23-rc1.

The bug could have been introduced by a change outside of the ieee1394
subsystem, like freezer or scheduler.  The try_to_wake_up in your
backtrace would be directed towards a thread which should be frozen at
some point.
-- 
Stefan Richter
-=====-=-=== =--= =----
http://arcgraph.de/sr/
