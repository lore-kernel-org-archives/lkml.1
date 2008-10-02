Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYJBPD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYJBPD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYJBPDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:03:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:49990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbYJBPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:03:47 -0400
From: Olaf Kirch <okir@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
Date: Thu, 2 Oct 2008 17:03:42 +0200
User-Agent: KMail/1.9.9
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com> <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021703.43770.okir@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 16:28:42 Jiri Kosina wrote:
>
> 15:50:52 linux-pr0e kernel: WARNING: at drivers/net/e1000e/ich8lan.c:424 e1000_acquire_swflag_ich8lan+0x5a/0xdc [e1000e]()
> 15:50:52 linux-pr0e kernel: e1000e mutex contention. Owned by pid 4162
> 15:50:52 linux-pr0e kernel: Call Trace:
> 15:50:52 linux-pr0e kernel:  [<ffffffff8020e41e>] show_trace_log_lvl+0x41/0x58
> 15:50:52 linux-pr0e kernel:  [<ffffffff80493716>] dump_stack+0x69/0x6f
> 15:50:52 linux-pr0e kernel:  [<ffffffff8023ee54>] warn_slowpath+0xb4/0xdc
> 15:50:52 linux-pr0e kernel:  [<ffffffffa022ce2e>] e1000_acquire_swflag_ich8lan+0x5a/0xdc [e1000e]
> 15:50:52 linux-pr0e kernel:  [<ffffffffa02317ba>] e1000e_read_phy_reg_igp+0x19/0x64 [e1000e]
> 15:50:52 linux-pr0e kernel:  [<ffffffffa02319f8>] e1000e_phy_has_link_generic+0x50/0xcc [e1000e]
> 15:50:52 linux-pr0e kernel:  [<ffffffffa02306f9>] e1000e_check_for_copper_link+0x24/0x86 [e1000e]
> 15:50:52 linux-pr0e kernel:  [<ffffffffa0236982>] e1000_watchdog_task+0x5c/0x5eb [e1000e]
> 15:50:52 linux-pr0e kernel:  [<ffffffff8024ecdb>] run_workqueue+0xa4/0x14c
> 15:50:52 linux-pr0e kernel:  [<ffffffff8024ee5b>] worker_thread+0xd8/0xe7
> 15:50:52 linux-pr0e kernel:  [<ffffffff80251fe5>] kthread+0x47/0x73
> 15:50:52 linux-pr0e kernel:  [<ffffffff8020d7a9>] child_rip+0xa/0x11

Looks like the e1000 watchdog racing with some dhclient activity (upping the interface).

I just noticed that the driver actually uses register pages. So it looks like it's
possible to have something like this without the mutex:

	process A selects page A
	process B selects page B
	process A writes to register at offset A'

So we may end up writing to the wrong register. I think I heard Vojtech mention
that the e1000e also has a register based interface to erase/rewrite the NVM
programmatically. Do we know at which offsets these registers live?

Olaf
-- 
Neo didn't bring down the Matrix. SOA did.
				--soafacts.com

