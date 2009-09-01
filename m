Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZIAJQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZIAJQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZIAJQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:16:20 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41246 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbZIAJQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:16:20 -0400
Date: Tue, 1 Sep 2009 11:20:12 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Dillow <dave@thedillows.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
Message-ID: <20090901092012.GA3662@electric-eye.fr.zoreil.com>
References: <20090826213024.GA20428@electric-eye.fr.zoreil.com> <m1hbvu45jq.fsf@fess.ebiederm.org> <20090827052423.GA1709@electric-eye.fr.zoreil.com> <m1ocq1ke9u.fsf@fess.ebiederm.org> <20090827232024.GA30119@electric-eye.fr.zoreil.com> <m1d46gka9e.fsf@fess.ebiederm.org> <1251422978.21865.2.camel@obelisk.thedillows.org> <20090830203735.GA24912@electric-eye.fr.zoreil.com> <m17hwl2fct.fsf@fess.ebiederm.org> <1251775996.3345.5.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251775996.3345.5.camel@obelisk.thedillows.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> :
[...]
> I've not been able to reproduce my lockups under medium testing with
> Francois's patch applied, so I'm a little more comfortable with it.

Nice :o)

> At the same time, I'm worried that the timing just changed enough to
> make it harder to trigger, as was the case when I did the patch IIRC.

It is a legitimate concern.

> The kernel's interrupt handling changed in a manner that made it much
> easier to hit about that time. The testing I did in May pointed strongly
> at us failing to ACK an interrupt source, causing the MSI generation to
> stop, so I need to think about things some more.

It can be understood as us claiming to perform some work we didn't too.

In this regard, a "ack everything and perform no work loop in the irq
handler" design would require some work : it races with the - supposedly
fast, register read free - napi handler which does not check that
unprocessed events are acked.

As the current patch was provided with almost no explanation :
- the irq handler and the napi handler are allowed / assumed / expected
  to race
- the napi and irq handlers ack respectively their own events (IntrStatus).
  They do not ack their friend ones.
- everybody acks (IntrStatus) before the work is done
- napi irqs are disabled before napi is (tentatively) scheduled.
  napi irqs are only expected to be disabled most of the time the napi
  handler runs.
- the napi handler enables its irqs, tests new events and conditionaly
  schedules itself.

-- 
Ueimor
