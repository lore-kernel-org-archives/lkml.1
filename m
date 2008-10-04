Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYJDLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYJDLES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 07:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJDLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 07:04:08 -0400
Received: from www.tglx.de ([62.245.132.106]:46790 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYJDLEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 07:04:07 -0400
Date: Sat, 4 Oct 2008 13:02:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, jesse.brandeburg@intel.com,
       linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Olaf Kirch <okir@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
In-Reply-To: <alpine.LNX.1.10.0810041219130.26779@jikos.suse.cz>
Message-ID: <alpine.LFD.2.00.0810041236250.4404@apollo>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>  <200810021523.45884.jbarnes@virtuousgeek.org>  <20081003.134634.240211201.davem@davemloft.net>  <200810031429.22598.jbarnes@virtuousgeek.org>  <alpine.LNX.1.10.0810032338140.26779@jikos.suse.cz>
 <4807377b0810031628x43f79eferdbb9c9c264a5816e@mail.gmail.com> <alpine.LNX.1.10.0810041219130.26779@jikos.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008, Jiri Kosina wrote:
> On Fri, 3 Oct 2008, Jesse Brandeburg wrote:
> > Our experience is different.  We are also testing with the "protection 
> > patch" reverted.
> > We see that the problem specifically comes and goes when
> > removing/adding the use of set_memory_ro/set_memory_rw to the driver.
> 
> But if this patch (which is an obvious workaround, compared to the other 
> patches which fix real bugs, right?) would be catching some malicious 
> accessess to the mapped EEPROM, there should be stacktraces present in the 
> kernel log, right?

Exactly. The access to a ro region results in a fault. I have nowhere
seen that trigger, but I can reproduce the trylock() WARN_ON, which
confirms that there is concurrent access to the NVRAM registers. The
backtrace pattern is similar to the one you have seen.

There are two possible bad results from that concurrent access:

1) Task A issues command A
				Task B issues command B
   Task A writes data for A
   which end up in B

2) Task A acquires the software flag
   ......

				Task B acquires the software flag

   Task A releases the software flag

   The firmware accesses NVRAM  Task B accesses the NVRAM
  
Both are probably serious enough to result in random NVRAM corruption.
There is no doubt: The missing serialization is a real bug.

Your question why this just happens now, while the bug is there for
ever, is definitely a good one. My opinion on that is that we just
have been lucky or some minor modification somewhere else in the
e1000e code or even in the generic/architecture code removed an
accidental serializing effect.

I was not able to reproduce the trylock warning on Fedora 8, but
Fedora 10-Beta triggers it once in 50 boots. I'm not going to remove
the mutex to verify whether it actually would corrupt the NVRAM :)

In theory we should be able to reproduce the problem with older kernel
versions as well. Maybe not the corruption, but we might see the
mutex_trylock check trigger.

Thanks,

	tglx
