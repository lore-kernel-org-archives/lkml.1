Return-Path: <linux-kernel-owner+w=401wt.eu-S934406AbZKYIr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406AbZKYIr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933564AbZKYIrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:47:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933533AbZKYIrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:47:55 -0500
Date: Wed, 25 Nov 2009 09:47:53 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
Message-ID: <20091125084753.GB1940@jolsa.lab.eng.brq.redhat.com>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
 <20091124211423.GE5071@nowhere>
 <20091124221748.GA5208@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124221748.GA5208@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:17:51PM +0100, Frederic Weisbecker wrote:
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

well, as I said in previous email, it's the seq_file
that overflows and causes another read syscall...

> 
> But it happens with trace_pipe reading.
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
> 
> I'm not sure why. The problem related by Olsa would explain such
> symptoms, and what olsa reported is a real bug, but only
> in trace_pipe. There is also something else, probably more
> related to the fast path.
> 
please call me jirka :) can you see the issue with the patch applied?
if not I believe it's the issue I described

jirka
