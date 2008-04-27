Return-Path: <linux-kernel-owner+w=401wt.eu-S1763678AbYD0T3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763678AbYD0T3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763274AbYD0T3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:29:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:35235 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762903AbYD0T3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=OEZ7VFu9+s0kv4yTKj7vue2P5gsM0KX/D9M+6/HgfacWytQBvTPnsaF2wQ3iuzcZ/U2iE7p1PN6NPXcIa3xcaoaGMQsubweBKGeCFrbzAULBLXzdiZTy49NLeQcEuXjuu5roA/hSbLdTmekfzGv/uWg7LF0mobX9T8F9sosz6dQ=
Date: Sun, 27 Apr 2008 22:29:25 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 0/5] updates to ftrace framework and mmiotrace
Message-ID: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

here starts a little patch series that finally makes mmiotrace produce good
trace logs with the ftrace framework. There are some caveats which I note
below. Also, the marker feature (as in inserting user comments into the log)
is still missing.

I believe I should try to make a full patch containing everything of
mmiotrace for review, but it might be tricky and not apply to any public
git tree, as it depends on new features in sched-devel, especially ftrace.
We'll see.

On Sat, 26 Apr 2008 20:33:06 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> On Mon, 21 Apr 2008 17:09:37 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch adds a method for open_pipe and open_read to the pluggins
> > so that they can add a header to the trace pipe call.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> In addition to this, I think I need tracer::close method called on
> tracing_release_pipe(). Use case: the reader closes the pipe before
> I have printed all of my header, i.e. walked through all PCI devices,
> so I need to properly destroy trace_iterator::private.

This is still broken. The close method is there, but it is not called,
as far as I can tell.

> I also intend to use trace_iterator::seq for printing my header, so I
> am looking if I can reuse code from tracing_read_pipe(). Looks like I'll
> extract the "return any leftover data" part into a separate function.

This resulted in the function trace_seq_to_user() which comes in the
first patch. Just like the code I refactored, it does not touch filp
or ppos. I trust the original author better than myself in this one :-)

> To check trace_iterator::overrun, I'd like to be able to use
> for_each_tracing_cpu(), but that is local to trace.c.

I'm using for_each_online_cpu() and trace_iterator::overrun for now.
It works, but I think the "events lost" trace log messages come too
late, like I explained earlier. On the other hand, the precise point
in the stream is not important, if one is aiming for a complete trace.

The patches will follow.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
