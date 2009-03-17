Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbZCQHrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbZCQHrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZCQHrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:47:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38319 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311AbZCQHrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:47:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18879.21884.162961.690031@cargo.ozlabs.ibm.com>
Date: Tue, 17 Mar 2009 18:47:08 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC 1/2] perfcounters: provide a way to read the
 current value of interrupting counters
In-Reply-To: <1237275169.5189.58.camel@laptop>
References: <18879.14425.221429.861838@drongo.ozlabs.ibm.com>
	<1237275169.5189.58.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> I'm not sure I understand why. It seems to me you're either interested
> in sample data, that is {tid,ip,counter} like things, or you want raw
> count values.

It was specifically requested by people porting PAPI to PCL, and it
seems like a reasonable request.

> This seems unrelated, what will stop us now from adding record_type
> values? PERF_RECORD_CALLCHAIN is one in particular I'd like to add soon.

I think we should make record_type a bitset rather than a single
value, and define bits for recording the callchain as well as various
other interesting things.

> This is a bit bothersome, as we then have no unique identifier anymore.
> 
> Currently the group record type writes things like {hw_event->type,
> counter} which is ambiguous since we really have a 65bit id space. So I
> was thinking of making that {fd, counter} to at least have a unique
> identifier in there.

The fd is already not a unique identifier - think about dup().

The hw_event->type values are not really necessary, in fact, since the
group members will always be read out in the order that they were
added to the group.  The only time there might be any possibility of
confusion is if a new member is added after some samples have already
been taken (or a member is removed) - then we'll get new records being
added to the event queue being a different size from those already in
the queue.  But that's a somewhat different problem which isn't really
solved by having the type values in there.

Paul.
