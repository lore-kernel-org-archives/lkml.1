Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZAFUQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZAFUQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZAFUQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:16:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:17349 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZAFUQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:16:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,221,1231142400"; 
   d="scan'208";a="420158155"
From: "Luck, Tony" <tony.luck@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>, Robin Holt <holt@sgi.com>
Date: Tue, 6 Jan 2009 12:15:34 -0800
Subject: RE: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Thread-Topic: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Thread-Index: AclwG7um2g/C/4qwQWiNq7qih4pgjwAHlLjg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com>
References: <20090106162741.GA7991@sgi.com>
In-Reply-To: <20090106162741.GA7991@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Turn on CONFIG_HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN.
>
> SGI Altix has unsynchronized itc clocks.  This results in rq->clock
> occasionally being set to a time in the past by a remote cpu.

SGI Altix is definitely the worst offender here. On heterogeneneous
systems with different model cpus across nodes the itc rate may differ
by hundreds of megahertz.  Even when all cpus are at the same rated
speed, different nodes are driven from different crystals, so the itc
values will slowly drift apart (Linux discovers this from SAL and so
doesn't bother to synchronize them).

> Note that it is possible that this problem may exist for other ia64
> machines as well, based on the following comment for sched_clock() in
> arch/ia64/kernel/head.S:
>
> * Return a CPU-local timestamp in nano-seconds.  This timestamp is
> * NOT synchronized across CPUs its return value must never be
> * compared against the values returned on another CPU.  The usage in
> * kernel/sched.c ensures that.

When sched_clock() was first created this was part of its definition.
It meant that sched_clock could be simple & fast because it didn't
need to be synchronized across cpus.

It seems that new uses have grown for it that no longer allow that
flexibility.

All ia64 systems are potentially affected ... but perhaps you might
never see the problem on most because the itc clocks are synced as close
as s/w can get them when cpus are brought on line.

-Tony
