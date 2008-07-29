Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYG2Air@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYG2Air (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYG2Aij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:38:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:26825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYG2Aii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:38:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,269,1215414000"; 
   d="scan'208";a="365530663"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Date: Mon, 28 Jul 2008 17:36:57 -0700
Subject: RE: [RFC] Imprecise timers.
Thread-Topic: [RFC] Imprecise timers.
Thread-Index: Acjrp614s2SPymxUQLGojLGKSVa62QFaDOOw
Message-ID: <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
In-Reply-To: <1216695757.18980.16.camel@shinybook.infradead.org>
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



>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of David
>Woodhouse
>Sent: Monday, July 21, 2008 8:03 PM
>To: linux-kernel@vger.kernel.org
>Cc: Thomas Gleixner; Ingo Molnar; arjan@infradead.org
>Subject: [RFC] Imprecise timers.
>
>Many users of timers don't really care too much about exactly
>when their
>timer fires -- and waking a CPU to satisfy such a timer is a waste of
>power. This patch implements a 'range' timer which will fire
>at a 'convenient'
>moment within given constraints.
>
>It's implemented by a deferrable timer at the beginning of the range,
>which will run some time later when the CPU happens to be awake. And a
>non-deferrable timer at the hard deadline, to ensure it really does
>happen by then.
>

One concern I have is drivers using range_timers thinking that they need
some upper bound, while all they need is a simple deferrable timer. With that
we will have multiple timers waking up the CPU all the time (say, on
different CPUs) problem again. Even without the timers waking up all
the time problem, we have extra overhead of one or more spinlocks
just to delete one extra unused timer. I don't how, but
we will have to restrict this somehow to only code that really needs this
kind of deadline.

Regarding implementation, I am thinking mod_range_timer should use
ret &= mod_timer(). That is, if one of the timers has already fired and
the other one is pending mod_range_timer return value should say it has
already fired. Right?

Also, do we need both mod_range_timer and __mod_range_timer.
Original mod_timer version talks about optimization for networking code.
I think we can do with only one of the two here...

Thanks,
Venki

