Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504Ab0AZXY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0AZXY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129Ab0AZXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:24:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35770 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0AZXYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:24:25 -0500
X-Authority-Analysis: v=1.0 c=1 a=Yo9lNqkTXJIA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=u2BSxxPh_NlThnDyp6wA:9 a=Q463qIFc4yNTJGQgdM0A:7 a=2BQyszDFvV4k8h4FOQRxs4sNct0A:4 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/5] tracing: Prevent kernel oops with corrupted buffer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100126143223.e4332098.akpm@linux-foundation.org>
References: <20100126220923.534282809@goodmis.org>
	 <20100126221712.447066697@goodmis.org>
	 <20100126143223.e4332098.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 26 Jan 2010 18:24:22 -0500
Message-ID: <1264548262.31321.460.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 14:32 -0800, Andrew Morton wrote:
> On Tue, 26 Jan 2010 17:09:24 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > If the contents of the ftrace ring buffer gets corrupted and the trace
> > file is read, it could create a kernel oops (usualy just killing the user
> 
> "usually" ;)

I used "usually" since that is what happened every time I encountered
the issue. But I don't know 100% if it only oops the user task in every
instance.

> 
> > task thread). This is caused by the checking of the pid in the buffer.
> > If the pid is negative, it still references the cmdline cache array,
> > which could point to an invalid address.
> > 
> > The simple fix is to test for negative PIDs.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/trace.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 0df1b0f..eac6875 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -951,6 +951,11 @@ void trace_find_cmdline(int pid, char comm[])
> >  		return;
> >  	}
> >  
> > +	if (WARN_ON_ONCE(pid < 0)) {
> > +		strcpy(comm, "<XXX>");
> > +		return;
> > +	}
> > +
> >  	if (pid > PID_MAX_DEFAULT) {
> >  		strcpy(comm, "<...>");
> >  		return;
> 
> But why is it WARN_ON_ONCE()?  That will only fix the problem a single
> time.  On the second occurrence, it will oops again.

Frederic correctly answered this.

Thanks,

-- Steve



