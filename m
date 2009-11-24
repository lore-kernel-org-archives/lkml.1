Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbZKXW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbZKXW0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934028AbZKXW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:26:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678AbZKXW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:26:38 -0500
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091124221748.GA5208@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
	 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
	 <20091124211423.GE5071@nowhere>  <20091124221748.GA5208@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 17:26:42 -0500
Message-Id: <1259101602.22249.1122.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 23:17 +0100, Frederic Weisbecker wrote:
> On Tue, Nov 24, 2009 at 10:14:36PM +0100, Frederic Weisbecker wrote:
> > But I guess it doesn't happen because the function graph tracer
> > has too large entries, or it would do an endless loop while
> > reading the trace file.
> 
> 
> Ah actually it won't as we don't check the return value
> of trace_print_line() from the seq show handler.
> There is no retry.
> 
> And also there is no need to retry. The buffer gets never
> entirely filled in the trace file reading path, as it
> is flushed after each entry. And no single trace fills the
> whole buffer. I just made some tests and we never reach that
> point (no TRACE_TYPE_PARTIAL_LINE) returned. So no overflow
> as far as I tested (there might be rare corner cases).

As I expected ;-)

> 
> But it happens with trace_pipe reading.

Yep, but I think we should be able to handle it without modifying
trace_seq.

> 
> There is another bug. Here is a sample from
> trace reading:
> 
>  0)               |  sys_newfstat() {
>  0)               |    vfs_fstat() {
>  0)   1.187 us    |      fget();
>  0)               |      vfs_getattr() {
>  0)               |        security_inode_getattr() {
>  0)   0.608 us    |              }
>  0)   2.951 us    |            }
>  0) + 65.349 us   |          }
>  0)               |          path_put() {
>  0)   0.608 us    |            dput();
>  0)   0.548 us    |            mntput_no_expire();
>  0)   2.748 us    |          }
>  0) + 74.472 us   |        }
> 
> 
> I think we are loosing some traces here, between security_inode_getattr()
> and path_put().

Sure the buffer didn't just wrap there? Is this a trace_pipe output?

Also note, with the reader page of the ring buffer there could also be
another symptom. Once the writer is off the reader page, it will never
come back on it (unless a reader swaps where the writer is, but that
only happens on a lightly filled buffer).

Thus, even if we freeze recording, when the reader finishes its reader
page and goes off into the main buffer, there may be a gap between the
last read and the next (main buffer) due to the writer wrapping it.

If you are using the trace_pipe while the function tracer is on, you
will probably see this a lot.

> 
> I'm not sure why. The problem related by Olsa would explain such
> symptoms, and what olsa reported is a real bug, but only
> in trace_pipe. There is also something else, probably more
> related to the fast path.

Are you looking at this while the function_graph tracer is running? Or
do you disable tracing (tracing_on = 0)

-- Steve


