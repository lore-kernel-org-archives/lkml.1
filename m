Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZLUPlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZLUPlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZLUPlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:41:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:46256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZLUPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:41:15 -0500
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>,
       eranian@google.com
In-Reply-To: <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 16:40:40 +0100
Message-ID: <1261410040.4314.178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 12:59 +0100, stephane eranian wrote:

> There is a major difference between PPC and X86 here. PPC has a
> centralized register to control start/stop. This register  uses
> bitmask to enable or disable counters. Thus, in hw_perf_enable(), if
> n_added=0, then you just need to use the pre-computed bitmask.
> Otherwise, you need to recompute the bitmask to include the new
> registers. The assignment of events and validation is done in
> hw_group_sched_in().
> 
> In X86, assignment and validation is done in hw_group_sched_in().
> Activation is done individually for each counter. There is no
> centralized register used here, thus no bitmask to update.

intel core2 has the global control reg, but for all intents and purposes
the perf_enable/disable calls emulate this global enable/disable.

> Disabling a counter does not trigger a complete reschedule of events.
> This happens only when hw_group_sched_in() is called.
> 
> The n_events = 0 in hw_perf_disable() is used to signal that something
> is changing. It should not be here but here. The problem is that
> hw_group_sched_in() needs a way to know that it is called for a
> completely new series of group scheduling so it can discard any
> previous assignment. This goes back to the issue I raised in my
> previous email. You could add a parameter to hw_group_sched_in() that
> would indicate this is the first group. that would cause n_events =0
> and the function would start accumulating events for the new
> scheduling period.

I'm not really seeing the problem here...


 perf_disable() <-- shut down the full pmu

 pmu->disable() <-- hey someone got removed (easy free the reg)
 pmu->enable()  <-- hey someone got added (harder, check constraints)

 hw_perf_group_sched_in() <-- hey a full group got added 
                              (better than multiple ->enable)

 perf_enable() <-- re-enable pmu


So ->disable() is used to track freeing, ->enable is used to add
individual counters, check constraints etc..

hw_perf_group_sched_in() is used to optimize the full group enable.

Afaict that is what power does (Paul?) and that should I think be
sufficient to track x86 as well.

Since sched_in() is balanced with sched_out(), the ->disable() calls
should provide the required information as to the occupation of the pmu.
I don't see the need for more hooks.

Paul, could you comment, since you did all this for power?

