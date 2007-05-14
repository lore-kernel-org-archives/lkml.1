Return-Path: <linux-kernel-owner+w=401wt.eu-S1030684AbXENLEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030684AbXENLEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965915AbXENLE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:04:26 -0400
Received: from holomorphy.com ([66.93.40.71]:48808 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965795AbXENLEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:04:24 -0400
Date: Mon, 14 May 2007 04:05:00 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514110500.GV19966@holomorphy.com>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514103120.GA23766@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 02:03:58PM +0530, Srivatsa Vaddagiri wrote:
>>> 	I have been brooding over how fair clock is computed/used in
>>> CFS and thought I would ask the experts to avoid wrong guesses!
>>> As I understand, fair_clock is a monotonously increasing clock which
>>> advances at a pace inversely proportional to the load on the runqueue.
>>> If load = 1 (task), it will advance at same pace as wall clock, as 
>>> load increases it advances slower than wall clock.
>>> In addition, following calculations depend on fair clock: task's wait
>>> time on runqueue and sleep time outside the runqueue (both reflected in
>>> p->wait_run_time).

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> It's not hard to see that that's a mistake. [...]

On Mon, May 14, 2007 at 12:31:20PM +0200, Ingo Molnar wrote:
> please clarify - exactly what is a mistake? Thanks,

The variability in ->fair_clock advancement rate was the mistake, at
least according to my way of thinking. The queue's virtual time clock
effectively stops under sufficiently high load, possibly literally in
the event of fixpoint underflow. The waiting time is impossible to
scale properly in the presence of a variable time rate (at least under
the memory allocation constraints of a scheduler), and the deadlines
computed as offsets from ->fair_clock come out clustered.

Basically it needs to move closer to EEVDF in these respects.

This detail sailed right past me when it went in; sorry about that.


-- wli
