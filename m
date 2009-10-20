Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZJTRL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZJTRL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZJTRL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:11:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:27840 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZJTRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KUvlndrHNrgAoJIp8j8FMDFZkA8u+ILxXxasfTDwA5sO/SPFPglKyU4ktxpmBi1gK5
         aUW1Nb7SGnmJ0fDUo1lQ66Wrf1Kq5uOelPzm3M+zEu5QsSSltHEvh3M3TOqY8qgZZYa8
         rWIz/oCsYATBQmEit1N3QWhNOlQNzh1qDlJ4g=
Date: Tue, 20 Oct 2009 19:11:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly skip
	records
Message-ID: <20091020171147.GA4906@nowhere>
References: <1256054439-24386-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256054439-24386-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 06:00:39PM +0200, Jiri Olsa wrote:
> Hi,
> 
> there's a case where the graph tracer might get confused and displays
> "{}" brackets in a wrong way.
> 
> Sorry for long description, but I found no better way to 
> describe the issue.. ;)
> 


I rather consider this changelog as nicely decribing the issue.

 
> It works ok but for one case. 
> 
> If the "func2()" trace does not make it to the seq_file read buffer, it needs
> to be processed again in the next read.  And here comes the issue: 
> the next read will see following pointers setup for func2 processing:
> 
>             func1 ENTRY
> current ->  func2 ENTRY 
>             func2 RETURN
>    next ->  func1 RETURN
> 
> which will turn to displaying the func2 entry like: "func2() {", since the
> next entry is not RETURN of the same type.  Generaly it is whatever entry 
> that follows, but definitelly not the RETURN entry of the same function.



I see... So that happens when the previous seq write failed, we already have
consume func2 RETURN and because we returned TRACE_PARTIAL_LINE, we reprocess
func2 ENTRY, but the next entry pointer have moved ahead already...

Nice catch!

 
> Following patch fixes the issue by skipping the entry in the last moment,
> bypassing the issue to happen during the sequential reads.
>
> wbr,
> jirka
> 
> 
> NOTE:
> 
> AFAIK patch does not affect "trace_pipe" handling, since the change is
> on the ring_buffer_iter level. However the "trace_pipe" suffers from
> the same issue -> when the read buffer is filled up, the current trace
> entry is not copied to it. Following read will continue with next entry.
> It might be harder to fix this, since "trace_pipe" in order to see next
> record has to eat the current one... 
> 
> I'll look at possible solution, but any ideas are welcome.. :)
> 
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/ftrace_event.h         |    1 +
>  kernel/trace/trace.c                 |   29 +++++++++++++++++++++++++++++
>  kernel/trace/trace_functions_graph.c |    2 +-
>  3 files changed, 31 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index d117704..7b07ad2 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -53,6 +53,7 @@ struct trace_iterator {
>  	struct mutex		mutex;
>  	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
>  	unsigned long		iter_flags;
> +	bool			skip_entry;


Instead of adding this new field to struct trace_iterator,
why not creating a new return value like TRACE_TYPE_HANDLED
but that would consume two entries instead of one?

May be TRACE_TYPE_HANDLED_2? (sorry I suck in naming).

TRACE_TYPE_HANDLED_PAIR?
TRACE_TYPE_HANDLED_COUPLE?

