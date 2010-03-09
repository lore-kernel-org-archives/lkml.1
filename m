Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0CIR2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:28:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0CIR22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:28:28 -0500
X-Authority-Analysis: v=1.0 c=1 a=drjUTJznMZEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=o5mDadrZ7CDX2YIRyYYA:9 a=8-KR4Qr1445dAb82hEL1V2VGHloA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <4B95C1FC.9030307@cn.fujitsu.com>
References: <4B94936B.8030409@cn.fujitsu.com>
	 <4B949E43.2010906@cn.fujitsu.com>
	 <1268060596.10871.1805.camel@gandalf.stny.rr.com>
	 <1268060858.10871.1807.camel@gandalf.stny.rr.com>
	 <4B95C1FC.9030307@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 09 Mar 2010 12:28:23 -0500
Message-ID: <1268155703.10871.1872.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 11:35 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:
> > On Mon, 2010-03-08 at 10:03 -0500, Steven Rostedt wrote:
> > 
> >>> ringbuffer resizing and reseting will increase the ->record_disabled
> >>> and then wait until a rcu_shced grace period passes.
> >>>
> >>> Contrarily, testing ->record_disabled should be at the same
> >>> preempt disabled critical region as writing into ringbuffer, otherwise
> >>> it will leave a window break ringbuffer resizing or reseting.
> >> So the resizing and the resetting need a synchronize_sched() after the
> >> disabling of the buffers, right?
> > 
> > Looking at the code, the synchronize_sched() is already done in
> > ring_buffer_resize, and the caller (trace.c:tracing_reset() ) also
> > disables the ring buffer and calls synchronize_sched().
> > 
> > With that, what other window is still opened (after this fix)?
> > 
> 
> This window is still opened: (RCU vs IDLE vs Tracing)
> 
> synchronize_sched() does not protect preempt_disable()/enable() for
> idle process. But tracing(function_graph, function) introduce more
> preempt_disable()/enable() for idle process. It brings windows.
> 
> I bet that this bug is not come from this window.
> (I added some strict code to RCU and did stress test,
> bug was still occurred.)

With Li's test, I was able to trigger the ring_buffer warning about
resetting while committing. I was still able to trigger it with your
patch to move the ring buffer disable code. But I did not trigger it
with both the ring buffer disable code _and_ your RCU fix.

But I was able to trigger the segfault that Li is seeing. That is most
likely a separate issue. I'm currently writing special debug code to
find out why that is happening.

Thanks!

-- Steve



