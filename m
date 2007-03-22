Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXCVMTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXCVMTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 08:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXCVMTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 08:19:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:19366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030572AbXCVMTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 08:19:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,313,1170662400"; 
   d="scan'208"; a="214089428:sNHT711713331"
Date: Thu, 22 Mar 2007 05:18:17 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, tglx@linutronix.de
Subject: Re: [PATCH 1/2] Add support for deferrable timers
Message-ID: <20070322121816.GA15473@linux-os.sc.intel.com>
References: <20070321202217.GA29367@linux-os.sc.intel.com> <20070322031826.55d483e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322031826.55d483e4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 03:18:26AM -0800, Andrew Morton wrote:
> On Wed, 21 Mar 2007 13:22:17 -0700 Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > 
> > Introduce a new flag for timers - 'deferrable timer'
> > Timers that work normally when system is busy. But, will not cause CPU to
> > come out of idle (just to service this timer), when CPU is idle. Instead,
> > this timer will be serviced when CPU eventually wakes up with a subsequent
> > non-deferrable timer or any other event.
> > 
> > The main advantage of this is to avoid unnecessary timer interrupts when
> > CPU is idle. If the routine currently called by a timer can wait until next
> > event without any issues, this new timer can be used while setting up timer
> > for that routine. This, with dynticks, allows CPUs to be lazy, allowing them
> > to stay in idle for extended period of time by reducing unnecesary wakeup and
> > thereby reducing the power consumption.
> > 
> > This patch:
> > Builds this new timer on top of existing timer infrastructure. It uses
> > last bit in 'base' pointer of timer_list structure to store this
> > deferrable timer flag. __next_timer_interrupt() function
> > skips over these deferrable timers when CPU looks for
> > next timer event for which it has to wake up.
> > 
> > This is exported by a new interface init_timer_deferrable() that can
> > be called in place of regular init_timer().
> > 
> 
> These patches cause a lockup during execuion of `halt -p'.  See phuzzy foto
> at http://userweb.kernel.org/~akpm/s5000486.jpg
> 
> It's fairly obvious why, when one looks at lock_timer_base().

Hmm.. Wonder how it worked for me and why I did not see this hang.
I had thought I covered all accesses to ->base. Obviously, I have missed
this "base == timer->base" check here. Will fix it and respin a patch later
today with below suggestions as well.

Thanks,
Venki
