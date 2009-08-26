Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZHZTPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZHZTPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZHZTPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:15:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZHZTPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:15:12 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090826164624.GA21456@Krystal>
References: <20090825102215.GC26801@elte.hu>
	 <1251196359.7538.1133.camel@twins> <20090825103907.GB28287@elte.hu>
	 <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins>
	 <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins>
	 <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com>
	 <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com>
	 <20090826164624.GA21456@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 21:14:06 +0200
Message-Id: <1251314046.18584.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 12:46 -0400, Mathieu Desnoyers wrote:
> Registering tracepoints even when no tracepoint definition is currently
> visible is the intended allowed behavior. Let's say we need to trace
> something happening in module init: if we disallow registering the tp
> callback before the module is initialized, we run in a chicken and egg
> problem.
> 
> So I am trying to figure out the problem source there. Is it that
> modules containing the tp callbacks need to know if those are actually
> connected to an instrumented module ? Or is it that the instrumented
> module needs to know if a probe module is connected to is ? Or is it the
> teardown of the probe module ? No refcount is needed there, because we
> surround the probe call by preempt disable/enable, and we use
> synchronize_sched() before removing the module which contains probe
> callbacks.
> 
> Mathieu-trying-to-figure-out-what-this-whole-thread-is-about :)

OK, so the whole point seems to be that tracepoints have the funny thing
you describe above, whereas the things ftrace makes out of TRACE_EVENT()
get instantiated along with modules.

The reason why I rejected the initial patch (and I still think that that
fix is at the wrong layer) is that I, as a consumer of whatever
TRACE_EVENT() offers, should never need to consider modules.


