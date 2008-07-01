Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYGAHMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYGAHMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYGAHMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:12:42 -0400
Received: from saeurebad.de ([85.214.36.134]:50951 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYGAHMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:12:42 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
References: <20080627000445.346130358@saeurebad.de>
	<20080627000805.504878592@saeurebad.de>
	<20080627120350.GB30872@elte.hu>
	<87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
	<20080627124329.GA14576@elte.hu>
	<87d4m3xbzq.fsf@skyscraper.fehenstaub.lan>
	<87od5ms7yh.fsf@skyscraper.fehenstaub.lan>
	<20080630130837.GA332@elte.hu>
	<87abh26u2m.fsf@skyscraper.fehenstaub.lan>
	<20080701061146.GE14658@elte.hu>
Date: Tue, 01 Jul 2008 09:12:04 +0200
In-Reply-To: <20080701061146.GE14658@elte.hu> (Ingo Molnar's message of "Tue,
	1 Jul 2008 08:11:46 +0200")
Message-ID: <871w2e6ptn.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Hi,
>> 
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > * Johannes Weiner <hannes@saeurebad.de> wrote:
>> >
>> >> > +	/*
>> >> > +	 * Wake up the high-prio watchdog task twice per
>> >> > +	 * threshold timespan.
>> >> > +	 */
>> >> > +	if (now > touch_timestamp + softlockup_thresh/2)
>> >> >  		wake_up_process(per_cpu(watchdog_task, this_cpu));
>> >> 
>> >> That defeats patch 1/3 and I think it can be dropped (#1).
>> >
>> > applied this updated patch to tip/core/softlockup. #3 didnt apply - 
>> > could you send a delta patch against tip/core/softlockup please? You can 
>> > pick it up via:
>> >
>> >   http://people.redhat.com/mingo/tip.git/README
>> >
>> > do:
>> >
>> >   git-checkout -b core/softlockup tip/core/softlockup
>> >
>> > to check it out.
>> 
>> Uhm, I see this patch is already in.  Misunderstanding or did you fix 
>> it up yourself?
>
> i applied and tested everything that would apply (modulo trivial 
> conflict resolution) - but not all of your patches applied so if there's 
> still anything missing please send a delta patch against this branch. 
> (or against tip/master, which too has all these changes included)

#1 is crap, #3 is in the tree and here is #2 against tip/core/softlockup:

--
From: Johannes Weiner <hannes@saeurebad.de>
Subject: softlockup: sanitize timestamp comparison

The print_timestamp can never be bigger than the touch_timestamp, at
maximum it can be equal.  And if it is, the second check for
touch_timestamp + 1 bigger print_timestamp is always true, too.

The check for equality is sufficient as we proceed in one-second-steps
and are at least one second away from the last print-out if we have
another timestamp.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 kernel/softlockup.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index d53ab70..7bd8d1a 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -116,11 +116,8 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if ((print_timestamp >= touch_timestamp &&
-			print_timestamp < (touch_timestamp + 1)) ||
-			did_panic) {
+	if (print_timestamp == touch_timestamp || did_panic)
 		return;
-	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
