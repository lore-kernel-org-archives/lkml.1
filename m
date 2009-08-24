Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZHXWn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZHXWn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZHXWnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:43:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43083 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbZHXWnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:43:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.5338.992510.245918@cargo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 08:31:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with enable_on_exec
In-Reply-To: <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	<1251121618.7538.262.camel@twins>
	<7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> As you indicated the issue is with the timing information and I think
> it is not related to enable_on_exec. It is more related to the fact
> that to enable a group with a single ioctl() you enable ALL BUT the
> leader. But that means that the time_enabled for the !leader is
> ticking. Thus scaling won't be as expected yet it is correct
> given what happens internally.

No, time_enabled shouldn't be increasing for a counter that's in a
group whose leader is disabled.

I'll try out your test program today.

> I think there needs to be a distinction between 'enabled immediately
> but cannot run because group is not totally enabled' and 'cannot run
> because the group has been multiplexed out yet all could be dispatched
> because all events were dispatched'. In the former, it seems you don't
> want time_enabled to tick, while in the latter you do. In other words,
> time_enabled ticks for each event if the group is 'dispatch-able' (or
> runnable in your terminology) otherwise it does not. time_enabled reflects
> the fact that the group could run but did not have access to the PMU
> resource because of contention with other groups.

Right.  That is exactly what the code is supposed to do.  If it
doesn't there's a bug.

Paul.
