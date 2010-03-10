Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0CJNwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:52:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab0CJNwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:52:05 -0500
X-Authority-Analysis: v=1.0 c=1 a=4u-V8yTdJKsA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=3qK13iZtj4ldCiNUXlkA:9 a=nAdQphpCwpfPSMSZXCPihhu5n3QA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] rcu: don't ignore preempt_disable() in the idle
 loop
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, josh@joshtriplett.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B96EE8A.5050003@cn.fujitsu.com>
References: <4B962D57.1000406@cn.fujitsu.com>
	 <1268139138.10871.1868.camel@gandalf.stny.rr.com>
	 <4B96EE8A.5050003@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 10 Mar 2010 08:51:53 -0500
Message-ID: <1268229113.4471.678.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 08:57 +0800, Lai Jiangshan wrote:

> No, this can not fix the bug we found with the ring buffer code.
> I think the bug is not come from this issue or from RCU.

Looking at the stress test, I believe the bug is not at the ring buffer
layer, but the ftrace layer above it.

There are some restrictions that are suppose to be implemented with
various actions of the ring buffer.

1) When using the iterator (reading the non-consuming trace file), the
ring buffer is not to be modified.

2) Same is true with resize and reset. The buffer should not be modified
during these actions, but more importantly, they should not happen while
an iterator is active.

3) Ftrace uses two ring buffers (one to store max latencies), when a max
is hit it switches buffers. I'm thinking that there may be cases we are
starting an operation on one and finishing it on another.

I've already found a few cases that ftrace does not protect against the
above, with the operations that this stress test does.

The main issue I see is that it is switching the tracer (which resets)
and it is also resizing the buffer, while the trace file is being read.
This may cause the iterator to be pointing to false pages. I'm going see
if disabling resizing and switching tracers when the trace file is open
prevents the crash. If this does prevent the crashes, then I'll see if I
can make the iterator more robust, if not, then we will have to prevent
these actions while someone has the trace file opened.

Thanks,

-- Steve


