Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116Ab0AZWjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0AZWjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770Ab0AZWjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:39:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:25119 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0AZWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N6ys89WLXmjiwIwty/p30Dq1WVZo7F24rQNlic2+UTpccUIhYecF1utod3O+7kWMLx
         R9Vj+GlsOOtgRU0jSz3BmVgNzIDpFS+gFrV+zs+WCsn9nr1P0a1QHCu/hTw7qFKtyC5h
         movNrri72e00B7odUmfBcO/S9ofy+nXuIjjVM=
Date: Tue, 26 Jan 2010 23:39:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/5] tracing: Prevent kernel oops with corrupted buffer
Message-ID: <20100126223900.GA5223@nowhere>
References: <20100126220923.534282809@goodmis.org> <20100126221712.447066697@goodmis.org> <20100126143223.e4332098.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126143223.e4332098.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 02:32:23PM -0800, Andrew Morton wrote:
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



The warning will be produced only once, but after that,
the condition is still checked like a simple if:

#define WARN_ON_ONCE(condition)	({				\
	static bool __warned;					\
	int __ret_warn_once = !!(condition);			\
								\
	if (unlikely(__ret_warn_once))				\
		if (WARN_ON(!__warned)) 			\
			__warned = true;			\
	unlikely(__ret_warn_once);				\
})


And since this function can be called anytime we have a trace
to print to the user, we don't want to encumber with thousands
of warnings.

