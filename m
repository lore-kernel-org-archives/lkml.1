Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0BCWHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:07:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0BCWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iugyiH2dsjbt//ymNePGw5FLR/FSX0GIcFwDP7YIHWNSwhFZCzSdVDoOX7k8Da7baP
         /0e/FosvCbqzFQzQAp1111XP+iEGTx4AwhMx39RroDaHUvQuMGIxqpAVjqrxvrU/XcGa
         AekWlwzi9/U9iMx8OciCSGZqKhGtZNzHyygyc=
Date: Wed, 3 Feb 2010 23:07:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100203220735.GD5068@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265193196.24455.390.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265193196.24455.390.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 11:33:16AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> > - event injection support
> 
> I like the idea, I'm just not sure about the name and API details.
>
> I would like to call it something like collection support, and the API
> should have an iterator like interface. 
> 
> That is, it should not blindly dump all events from a collection at
> once, praying the output buffer is large enough, but either dump a
> specified number and/or stop dumping when the buffer is full. Allowing a
> second invocation to continue where it left off after the buffer content
> has been consumed.


Yeah I agree. But my worry is there are induced races in this scheme.
But probably tight enough that we don't care much.

Consider dumping the task list content:

A -> B -> C -> D

You open a "task" event. And ask to inject it one by one,
you first dump A, and B disappear, then you'll miss it
but you can still get C and D if they don't disappear.

As I said it is tight enough that we don't care. If B disappears
so early, it means it won't have a determinant role in the profiling
anyway (at worst few isolated events in the beginning).

The fact is the async injection will always have such misses by
its nature anyway, you can still dump the whole at once, and you will
miss events that just disappeared before the injection call, so whatever...


> 
> Which brings us to the ioctl() interface, we can do the above using
> ioctl()s, but it seems to me we're starting to get ioctl() heavy and
> should be looking at alternative ways of extending this.
> 
> Anybody any bright ideas?
> 


Using ioctl, we can basically have such structure:

struct perf_inject_req {
	int start; (in)
	int len;   (in)
	int *read;  (out)
};

Using an idx will often imply rewalk a whole object list from
the beginning, which is perfectly fine.

If you prefer an alternate syscall, I can make it. I've been
told about ioctl drawbacks by the past, I personally think
ioctl has not only drawbacks: it avoids a proliferation
of syscalls. But that's how you prefer.

