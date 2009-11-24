Return-Path: <linux-kernel-owner+w=401wt.eu-S933920AbZKXWSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbZKXWSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZKXWSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:18:04 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:55606 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbZKXWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nxfVGmP2cgTBJuq4PSxZJsch58drbXfE/nfl7eow3J9CEaqcWN43CfZN9Ik0ZqAb7K
         X6JJs55qa6EXZVg9R4yKwRec7LPyfY4dLY16yPcbcO50Wwly/lSRs7Qk3G2XPCtY1TBE
         xYNQtLOctHslvt9b7Gr+eTtD+bGtGWDqC0PqA=
Date: Tue, 24 Nov 2009 23:17:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
	failed entries
Message-ID: <20091124221748.GA5208@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com> <1259082845.22249.1110.camel@gandalf.stny.rr.com> <20091124211423.GE5071@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124211423.GE5071@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:14:36PM +0100, Frederic Weisbecker wrote:
> But I guess it doesn't happen because the function graph tracer
> has too large entries, or it would do an endless loop while
> reading the trace file.


Ah actually it won't as we don't check the return value
of trace_print_line() from the seq show handler.
There is no retry.

And also there is no need to retry. The buffer gets never
entirely filled in the trace file reading path, as it
is flushed after each entry. And no single trace fills the
whole buffer. I just made some tests and we never reach that
point (no TRACE_TYPE_PARTIAL_LINE) returned. So no overflow
as far as I tested (there might be rare corner cases).

But it happens with trace_pipe reading.

There is another bug. Here is a sample from
trace reading:

 0)               |  sys_newfstat() {
 0)               |    vfs_fstat() {
 0)   1.187 us    |      fget();
 0)               |      vfs_getattr() {
 0)               |        security_inode_getattr() {
 0)   0.608 us    |              }
 0)   2.951 us    |            }
 0) + 65.349 us   |          }
 0)               |          path_put() {
 0)   0.608 us    |            dput();
 0)   0.548 us    |            mntput_no_expire();
 0)   2.748 us    |          }
 0) + 74.472 us   |        }


I think we are loosing some traces here, between security_inode_getattr()
and path_put().

I'm not sure why. The problem related by Olsa would explain such
symptoms, and what olsa reported is a real bug, but only
in trace_pipe. There is also something else, probably more
related to the fast path.

