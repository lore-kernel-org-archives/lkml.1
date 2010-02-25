Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0BYGGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 01:06:45 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:50214 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0BYGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 01:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gxmzXozlmyYshckjWc7uwNP7xhQcsPTbLoDlghH+ZTU1Pp1NUntcc7SjrJ1EXKmmG2
         5PkxWRaW1/q6KHLPrneUuGu3P0i6KE7ro9EUpQ6ysVGjK8ECMqiXOSdCAFeuPcC2NJ5A
         X7B6dLofpEqQSQ4HJDqP2439+AQxONsqegu+Y=
Subject: Re: [PATCH 12/12] perf trace/scripting: add perf-trace-python
 Documentation
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
In-Reply-To: <20100225013720.GB7491@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
	 <1264580883-15324-13-git-send-email-tzanussi@gmail.com>
	 <20100225013720.GB7491@nowhere>
Content-Type: text/plain
Date: Thu, 25 Feb 2010 00:06:38 -0600
Message-Id: <1267077998.6611.137.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 02:37 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 27, 2010 at 02:28:03AM -0600, Tom Zanussi wrote:
> > +from perf_trace_context import *
> > +from Core import *
> > +
> > +def trace_end():
> > +	print "in trace_end"
> > +
> > +def raw_syscalls__sys_enter(event_name, context, common_cpu,
> > +	common_secs, common_nsecs, common_pid, common_comm,
> > +	id, args):
> > +----
> > +
> > +In trace_end(), we'll simply print the results, but first we need to
> > +generate some results to print.  To do that we need to have our
> > +sys_enter() handler do the necessary tallying until all events have
> > +been counted.  A hash table indexed by syscall id is a good way to
> > +store that information; every time the sys_enter() handler is called,
> > +we simply increment a count associated with that hash entry indexed by
> > +that syscall id:
> > +
> > +----
> > +  syscalls = autodict()
> > +
> > +  try:
> > +    syscalls[id] += 1
> > +  except TypeError:
> > +    syscalls[id] = 1
> > +----
> > +
> > +The syscalls 'autodict' object is a special kind of Python dictionary
> > +(implemented in Core.py) that implements Perl's 'autovivifying' hashes
> > +in Python i.e. with autovivifying hashes, you can assign nested hash
> > +values without having to go to the trouble of creating intermediate
> > +levels if they don't exist e.g syscalls[comm][pid][id] = 1 will create
> > +the intermediate hash levels and finally assign the value 1 to the
> > +hash entry for 'id' (because the value being assigned isn't a hash
> > +object itself, the initial value is assigned in the TypeError
> > +exception.  Well, there may be a better way to do this in Python but
> > +that's what works for now).
> 
> 
> That's smart. I wish python had a native type for that.
> 
> And looking how you made it easily....
> 
> def autodict():
>     return defaultdict(autodict)
> 

Yeah, being used to Perl hashes, I was surprised that Python dicts
didn't also allow that, or at least have an 'autovivify' option.

I guess defaultdicts, added later, are Python's answer to that
shortcoming (depending on how you look at it - I know a lot of people
hate them, but it sure makes aggregating trace data a lot easier).


