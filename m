Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYGSMLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYGSMLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYGSML3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:11:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYGSML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:11:28 -0400
Date: Sat, 19 Jul 2008 08:11:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Theodore Ts'o" <tytso@MIT.EDU>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Ftraced always polls once a minute even when no tracer is active
In-Reply-To: <E1KJzHJ-0003Yj-68@closure.thunk.org>
Message-ID: <Pine.LNX.4.58.0807190801530.11122@gandalf.stny.rr.com>
References: <E1KJzHJ-0003Yj-68@closure.thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jul 2008, Theodore Ts'o wrote:

>
> I noticed with powertop that ftraced waks up once a second, even if no
> tracer is active.  Is there a reason why the kernel thread can't be
> suspended in that case?

That's for the dynamic tracer. It is actually stopped when a tracer is
active ;-)

CONFIG_FTRACE enables the "-pg" option in the kernel compile that enables
the mcount profiler. This adds a call to a function called "mcount" at the
start of every function. With a simple "ret" from mcount, this still adds
up to a 18% overhead.

What the dynamic ftrace does is to have the mcount function call a
"register_ip" function, that adds the caller into a hash table if it is
not already there.

Once a second the "ftraced" kernel thread wakes up and checks to see if
there are any new functions that have been called and recorded. If there
has been, it calls kstop_machine and changes the call to mcount into a
nop. This keeps the system to a 0% overhead (well, probably not 0% but it
is not measurable ;-).

I should add code to stop the kthread when the system is low. I notice
that the thread still wakes up but goes to sleep even when ftraced_enabled
is zero.

I'm currently traveling and I'm trying to finish up the ftrace tutorial
for OLS. I'll have to look more into this when I get back.

Thanks,

-- Steve

