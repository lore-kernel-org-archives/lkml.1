Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZD1UrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZD1UrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZD1UrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:47:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZD1UrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:47:08 -0400
Date: Tue, 28 Apr 2009 16:47:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: BUG: Function graph tracer hang
In-Reply-To: <20090428203244.GE7337@nowhere>
Message-ID: <alpine.DEB.2.00.0904281645020.8066@gandalf.stny.rr.com>
References: <20090417144055.857407604@goodmis.org> <20090417151135.GG23493@elte.hu> <20090417151303.GA18267@elte.hu> <20090428111223.GA20526@elte.hu> <20090428203244.GE7337@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Apr 2009, Frederic Weisbecker wrote:

> 
> Note that the branch profiler does that:
> 
> ______f.miss_hit[______r]++;
> 
> Which is a read + write on the cacheline.
> If each "if" are profiled in the timer interrupt, we can
> have the cachelines doing a ping-pong of dirtifying since the above
> variable is shared.
> 
> Then the timer interrupt becomes slower. The function graph tracer itself makes
> it slower.
> Moreover it is traced itself. So not only the "if" in code are traced, but also
> each "if" processed by the function graph tracer on function calls and returns.
> 
> Which means a fair amount of cacheline dirtifying.
> 
> Then if the timer interrupt is slowed, and we have a lot of them (1000 Hz),
> the system spends all of its time inside it.
> 
> At least we need the branch tracing to be done per cpu, I guess.

This can be done by basically reimplementing what percpu does. This is 
because the data is saved off in its own section at every if statement. We 
could copy that section per cpu and add code to the incrementors to add 
only to their own CPU buffers.

This is low in my priority of things to do, but I'll at least add it to my 
"to do" list.

-- Steve

