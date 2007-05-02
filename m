Return-Path: <linux-kernel-owner+w=401wt.eu-S2993439AbXEBQHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993439AbXEBQHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993430AbXEBQHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:07:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:45824 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993439AbXEBQHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:07:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,480,1170662400"; 
   d="scan'208";a="82696724"
Message-ID: <4638B748.40007@intel.com>
Date: Wed, 02 May 2007 09:07:36 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Michel Lespinasse <walken@zoy.org>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com> <20070502084146.GA6089@zoy.org>
In-Reply-To: <20070502084146.GA6089@zoy.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2007 16:07:36.0726 (UTC) FILETIME=[002D1B60:01C78CD4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> On my system, every e1000_watchdog() invocation calls e1000_read_phy_reg()
> twice: first near the top of e1000_check_for_link() within the
> e1000_media_type_copper && hw->get_link_status condition, then within
> e1000_update_stats() to read and update the idle_errors statistic.
> Each call results in a 100ms delay. The second call is enclosed within
> an spin_lock_irqsave()..spin_unlock_irqrestore() section, so it results
> in 100ms of lost ticks too.

Unfortunately we need the spinlock here. I'm not 100% sure the irqsave is no 
longer needed since we recently modified the watchdog to run as a task (out of 
interrupt context), but this code hasn't made it upstream yet (it's sitting in 
mm if you're interested).

> Now I have no idea how to fix that, but it does seem like it must be an
> initialisation issue. Possibly it might be a matter of telling the firmware
> "management engine" to keep its paws off of the adapter, I dont know.
> If you want me to add logging within the init functions, let me know.

please don't, see below

> The other operations - like all the E1000_READ_REG() calls within
> e1000_update_stats() - seem to take negligible time compared to the
> two failing e1000_read_phy_reg() calls.
> 
>> I've had good results with 2.6.21.1 (even running tickless :)) on these 
>> NICs. Have you tried that yet?
> 
> Not yet. Coming up... I'd prefer not to rely on new kernels at this
> point though - but I can certainly try it just to report on current status.

I currently suspect that (on this NIC) you're being bitten by a initialization 
bug that was fixed in later patches that made it into 2.6.21. The best thing to 
try for you is attempt to run 2.6.21 in the same configuration and see if that 
fixes it for you. It has to do with a patch I sent to fix the firmware takeover 
bits at startup, something that was definately broken in 2.6.19 and probably 2.6.20.

Auke
