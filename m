Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZBTOmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZBTOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZBTOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:42:38 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:57767 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZBTOmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vooiW6ajHOouC4BUsPr41+TPvRagjAgTkhkEvdxpsIz4Umg2X879Wmmpy1IbgxIUz8
         n2AOfAtuu+tYt8YsSTLoiIBkgXAZ4hBeGDLweQ4WHa1Z7W+kxsBcQtxMVo3/N8o8AUzN
         NIx+fYUxQk9qS9WJewDrpM0MASMLKSyhcYZaU=
Date: Fri, 20 Feb 2009 15:42:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/function-graph-tracer: make set_graph_function
	file support ftrace regex
Message-ID: <20090220144231.GB5732@nowhere>
References: <499dc97d.257d420a.0f93.1be5@mx.google.com> <20090220104004.GC28581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220104004.GC28581@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 11:40:04AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: trace only functions matching a pattern
> > 
> > The set_graph_function file let one to trace only one or several
> > chosen functions and follow all their code flow.
> > 
> > Currently, only a constant function name is allowed so this patch
> > allows the ftrace_regex functions:
> > 
> > _ matches all functions that end with "name":
> >   echo *name > set_graph_function
> > 
> > _ matches all functions that begin with "name":
> >   echo name* > set_graph_function
> > 
> > _ matches all functions that contains "name":
> >   echo *name* > set_graph_function
> > 
> > Example:
> > 
> > echo mutex* > set_graph_function
> > 
> >  0)               |  mutex_lock_nested() {
> >  0)   0.563 us    |    __might_sleep();
> >  0)   2.072 us    |  }
> >  0)               |  mutex_unlock() {
> >  0)   1.036 us    |    __mutex_unlock_slowpath();
> >  0)   2.433 us    |  }
> >  0)               |  mutex_unlock() {
> >  0)   0.691 us    |    __mutex_unlock_slowpath();
> >  0)   1.787 us    |  }
> >  0)               |  mutex_lock_interruptible_nested() {
> >  0)   0.548 us    |    __might_sleep();
> >  0)   1.945 us    |  }
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/ftrace.c |   56 +++++++++++++++++++++++++++++++++---------------
> >  1 files changed, 38 insertions(+), 18 deletions(-)
> 
> Applied, thanks Frederic!
> 
> I'm wondering about the following: the whole set_graph_function 
> method is limited (to FTRACE_GRAPH_MAX_FUNCS, 32 entries), is 
> not scalable (we walk the array of functions at every function 
> trace point), has a separate API, etc.
> 
> Wouldnt we off better with a good, generic function attributes 
> hash, and an extension to the generic regexp parser to enable 
> the setting of those attributes? One such attribute could be the 
> 'expand child function'
> 
> 	Ingo

And well, you are answering this question I couldn't solve yesterday.
One of my goal was to be able to trace easily the syscalls:

echo sys_* > set_graph_function

But this array is static. And making it runtime resizable resulted in other problems:
locking? but doing that for each function is unacceptable. rcu was a good
candidate but I wonder that rcu would have been traced too, occuring tracing recursion.

Well, using such generic hashtable with such an attribute is really a good idea.

