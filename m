Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYIYPJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYIYPJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYIYPJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:09:24 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:17697 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYIYPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=Wd/7OlKJwcSfuUlPhZ4f62UOo09gpueftZPaWtxKNOGtV2RZASZ5ollPlqZ6qB1yaU
         tmxsuYQeIbzYHA+lrk5ct24RBPM0NpASwhQmPyE+z1P8iYs5lzPmgi7jecTCWo29K6bM
         pYmzODrhTOmsn9gpGElymqWrR02Bn9YJi1o+4=
Date: Thu, 25 Sep 2008 18:09:16 +0300
From: Pekka Paalanen <pq@iki.fi>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Message-ID: <20080925180916.75d3c9ec@daedalus.pq.iki.fi>
In-Reply-To: <48DBA683.8000708@gmail.com>
References: <48DB81BA.2050204@gmail.com>
	<20080925123802.GA6900@elte.hu>
	<48DBA683.8000708@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 15:56:03 +0100
Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Correct the coding style in the commit 
> 803294369973b740f4c346553850b56e4b0c3c8a
> And remove the ret variable since print functions
> only return 0 or 1.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---

Frederic, in the future, could you just copy the patch
into the email body (watch out for line wraps and other damage),
attachments are not usually included in "reply with quote",
so commenting on them is a tiny bit harder. Thanks.

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6ada059..50ac334 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1904,20 +1904,27 @@ static int trace_empty(struct trace_iterator *iter)
>  
>  static int print_trace_line(struct trace_iterator *iter)
>  {
> +	int ret;
> +
>  	if (iter->trace && iter->trace->print_line)
> -		return iter->trace->print_line(iter);
> +		if ((ret = iter->trace->print_line(iter)))
> +			return ret;

NACK.

IMHO this breaks the trace_seq handling. trace_seq may contain
the output of several entries, as far as they fit in it as a whole.
E.g. trace_seq_printf() does not print partial lines but returns 0,
so that the entry is not consumed right now. The user space reader
must consume trace_seq content, before trace_seq_printf()
is attempted again, hopefully with enough space in trace_seq to
succeed. See tracing_read_pipe().

print_line() callback works the same way. Returning 0 means "could
not print it this time, call me back later". You can't use that to
say "use the default output function instead". Note, that possibly
the default output function will fail, too, so it could actually
try many of the default output functions and still fail, eventually
leading by luck to the correct behaviour in most cases.

Note, that mmiotrace follows this convention: it deliberatly
returns 1 without processing when it wants the entry discarded, and
it returns 0 when there was not enough space to process the entry.
This is explained in my other email.

What is the supposed return value of print_trace_line(), I do not
know. Looks like it is used as boolean, so maybe the type should be
changed to bool. Unless we want three options:
- 0: could not print now, try again
- 1: success, entry processed, it can be thrown away
- 2: fall back to the default output formatting
Cases 0 and 1 must exist like that, I do not know how useful 2 is,
but it must be distinct from the first two.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
