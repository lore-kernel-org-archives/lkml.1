Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZHJHcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZHJHcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZHJHcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:32:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:44986 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZHJHcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uX/J3/15aafxm1shcZlssInJt5v8SNw2dcGC8+r7+pjBf4Dsxe5scEGG1s2uNmA/mq
         RYvxilSfxUQTvaQ94wCu+PSdz54WA06iBeU78a1NpLSXrJx9xZ9t8UkvDRQJwn8Hz1TC
         O0xmQx78amqxSdzBdLnOcVsLQ7Dx2ClpeLpvo=
Date: Mon, 10 Aug 2009 09:32:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/3] perfcounter: Align ftrace events raw samples to 8
	bytes
Message-ID: <20090810073247.GA5508@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com> <1249698400-5441-6-git-send-email-fweisbec@gmail.com> <1249888437.17467.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249888437.17467.42.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 09:13:57AM +0200, Peter Zijlstra wrote:
> On Sat, 2009-08-08 at 04:26 +0200, Frederic Weisbecker wrote:
> > Align the ftrace events raw samples to 8 bytes so that they meet the
> > perf output event alignements requirements.
> > 
> > Reported-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Paul Mackerras <paulus@samba.org>
> > ---
> >  include/trace/ftrace.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 80e5f6c..7b0834c 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -687,7 +687,7 @@ static void ftrace_profile_##call(proto)				\
> >  	pc = preempt_count();						\
> >  									\
> >  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> > -	__entry_size = __data_size + sizeof(*entry);			\
> > +	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
> >  									\
> >  	do {								\
> >  		char raw_data[__entry_size];				\
> 
> Make sure to clear the trailing few bytes, otherwise we've got a stack
> data leak here.


Oh, right.


 
> Also, tracepoints using __string() could still easily overflow the stack
> here and cause great havoc, esp since the tracepoint could already be
> deep into a call-chain.


I know yeah, I'll think about a way to store the string parts as pointers
and copy their content on perf_output only.

