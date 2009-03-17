Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZCQHdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZCQHdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZCQHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:33:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:44291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZCQHdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:33:06 -0400
Subject: Re: [PATCH/RFC 1/2] perfcounters: provide a way to read the
 current value of interrupting counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18879.14425.221429.861838@drongo.ozlabs.ibm.com>
References: <18879.14425.221429.861838@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 08:32:49 +0100
Message-Id: <1237275169.5189.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 16:42 +1100, Paul Mackerras wrote:
> Impact: new feature
> 
> At present, if the user specifies hw_event->record_type ==
> PERF_RECORD_IRQ or PERF_RECORD_GROUP when creating a counter, reads from
> the counter will return records from the interrupt event queue for the
> counter.  This means that there is no way to find out the current value
> of the counter.  Also, using the record_type is slightly problematic in
> that what actually determines whether the counter generates interrupts
> is whether hw_event->irq_period is non-zero or not.

I've never found that to be a problem, I've always read PERF_RECORD_IRQ
as PERF_RECORD_SINGLE or somesuch in that it will give a single counter
output, as opposed to PERF_RECORD_GROUP which will give a tuple.

> This provides a way for users to get a second fd for an interrupting
> counter, which has a different set of file operations, set up so that
> reads on the second (or "clone") fd return the counter value rather than
> reading the interrupt event queue.  The way to get the clone fd is like
> this:
> 
> 	clone_fd = sys_perf_counter_open(NULL, 0, 0, counter_fd, 0);

I'm not sure I understand why. It seems to me you're either interested
in sample data, that is {tid,ip,counter} like things, or you want raw
count values.

These two cases seem clearly distinct and provided for. Why are you
mixing them?

> This will enable us to use a wider range of values in record_type in
> future, allowing the user to specify what information they want recorded
> on an interrupt.

This seems unrelated, what will stop us now from adding record_type
values? PERF_RECORD_CALLCHAIN is one in particular I'd like to add soon.

> Internally, we now potentially have multiple struct files pointing to
> the one struct counter, which could lead to lifetime issues.  We avoid
> any such issues by having the clone files keep a reference to the
> original file.  The reference is dropped when the clone file is closed.
> Thus the original file can never be released while there is any clone
> file still open.

This is a bit bothersome, as we then have no unique identifier anymore.

Currently the group record type writes things like {hw_event->type,
counter} which is ambiguous since we really have a 65bit id space. So I
was thinking of making that {fd, counter} to at least have a unique
identifier in there.



