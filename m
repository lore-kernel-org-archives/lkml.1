Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbXKEOeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbXKEOeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbXKEOeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:34:01 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:40722 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbXKEOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:34:00 -0500
Subject: [ANNOUNCE] Updated Logdev for internal Linux kernel debugging
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       sebastien.dugue@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       Clark Williams <clark.williams@gmail.com>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 09:32:50 -0500
Message-Id: <1194273170.8827.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, I was able to spend some time to clean up logdev for the latest
kernels (2.6.23.1, 2.6.24-rc1"x86 merged" and 2.6.23.1-rt5 "Real-Time").

http://rostedt.homelinux.com/logdev/



What is logdev?

It is an internal ring buffered log trace system, to help debug those
really hard to debug areas, like interrupts and the scheduler.  It uses
an internal memory ring buffer to load the information to and it will
dump it out on a system panic, oops, nmi lockup, and most other crashes.
You can also trigger the dump with a "sysrq-g" or read it straight from
userland utilities.



What makes logdev special

"Everyone has written their own memory logging device" - tglx

logdev is special because I just happen not to delete the internal
memory device when I was done with it and I've actively maintained it
since early 2.2 kernels.

This means that I tried hard to make it as easy to port as possible. So
it is very non intrusive in the kernel.  When debugging a kernel, the
first thing I usually do when the bugs are not obvious is to port logdev
to that kernel.

Once logdev is there, there are several options to make it easy to
trace.

One add the logdev.h header

  #include <linux/logdev.h>

then simply use the macros to recode what you want in printk like
statements.

  lfcnprint("hello world");

can produce this:

 [   15.177033] cpu:1 (swapper:1) do_basic_setup:742   hello world

It shows you the timestamp, the CPU that it was called on, the process
"comm" and pid, as well as the function and line number where the
lfcnprint was made, and then the printk like string.

This debugging tool has become invaluable for debugging for me (and
others http://www.gatago.org/linux/kernel/53143673.html)

I don't care if you use it or not, but since I find it so helpful, I
like to share it with anyone else that might find it useful too.

For more details on use look here:
  http://rostedt.homelinux.com/logdev/README




Why not use relay (aka. relayfs)?

After posting this a while ago, Ingo Molnar suggested that I look into a
similar utility called relayfs (now called relay).  I started some
correspondence with Tom Zanussi about using relay as my back end for
logdev.

Unfortunately, relay is focused very much so for fast interaction with
userland. It is split up in pages that are mapped special so that
userland can map these pages and do the consumer work too.  It is quite
complex to handle all the interactions that are needed for working with
and efficiently with userland.

relay is for things like LTT which is a complex tool to help developers
and users alike analyze their systems.

logdev is for debugging. It should never be turned on for production
systems.

One advantage that logdev has over relay is that, since it is specific
for debugging, it isn't such a high priority to be efficient. So it can
interleave its per cpu buffers with a single atomic counter so that the
output is guaranteed to be in the order of occurrences. logdev never
trusts timestamps for this purpose.  But its for debugging, so who cares
about a little cache line bouncing ;-)

Also, Tom Zanussi was kind enough to spend some time trying to make
relay a back end for logdev (still there). But because logdev is so
kernel centric and relay is very much user centric, the two didn't seem
to fit well at all.

One thing that logdev still does nicely is that it dumps its buffers out
to console (printk) whenever there's a bug or crash.  This happens to be
the most useful part that I find, and the part that I use most often.
When I'm developing a feature in the kernel scheduler or something, and
I'm crashing or locking up, adding logdev to it shows nicely what is
happening, and because its a ring buffer, you see what has happened most
recently, which usually includes the area that has the bug.

I even used logdev to prove to tglx that there was a nasty race
condition in his early versions of hrtimers.



Why not use Mathieu's Markers?

Heh, well actually, I want to ;-)

I'm just waiting to see the final version of them when they are in
2.6.24. After that, I'll add hooks into logdev to use them. Currently,
logdev has markers that are similar, but they were only created as a
proof of concept for Mathieu to try out some other ideas.  The logdev
markers are obviously not in mainline.




Do you want logdev to be in the Linus tree?

No. (really, I don't).  The Linus tree is for distributions to take and
put into production products.  As I said, logdev is a nice tool for
kernel hackers, but not much else. For users that want the features of
logdev, relay is a much better way to go.  I'm posting this so other
kernel hackers can play.


That said...



Do you want logdev to be in Andrew Mortons -mm tree?

Yes!  Well, it's really up to Andrew. But I remember him once saying,
that if there was a tool to help debugging, and wasn't meant to be in
Linus's tree, but  it was non intrusive and well maintained, he would
consider holding it in the -mm tree.

Well, logdev is for hackers and debuggers, and the -mm tree seems to fit
that category, not to mention that logdev is easily ported form one
kernel to the next (I've been doing it since 2.2). I think this might be
a good place for it to live.

But this is really up to Andrew to decide.


Well, that's it. Comments, questions, flames, all welcomed.

-- Steve




