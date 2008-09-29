Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYI2TO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYI2TO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYI2TOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:14:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:58183 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYI2TOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=W/Wb9Idkv11ZHnk9g84+Fm/oiuJwBrvyzCpcqlhYwB39ogVdxr9kAOcj5snhjfbimd
         e4QLpKqorDcWXBvsmH7XJ9NeI2phgdSe63IogRIXHAuRCQGoIUOVOGMgG49EwoFFWhep
         K3gKlEpItebSotNUZyE0FbI88rO0G4HZS+vKs=
Date: Mon, 29 Sep 2008 22:14:39 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       rostedt@goodmis.org
Subject: A style question: repeated return value check
Message-ID: <20080929221439.547d65ec@daedalus.pq.iki.fi>
In-Reply-To: <48E11BFA.1070503@gmail.com>
References: <48E11BFA.1070503@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 20:18:34 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> We need a kind of disambiguation when a print_line callback
> returns 0.
> 
> _There is not enough space to print all the entry. 
>  Please flush the seq and retry.
> _I can't handle this type of entry
> 
> This patch changes the type of this callback for better information.
> 
> Also some changes have been made in this V2.
> 
> _ Only relay to default functions after the print_line callback fails.
> _ This patch doesn't fix the issue with the broken pipe (see patch 2/4 for that)
> 
> Some things are still in discussion:
> 
> _ Find better names for the enum print_line_t values
> _ Change the type of print_trace_line into boolean.
> 
> Patches to change that can be sent later.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c |   77 ++++++++++++++++++++++++++-----------------------
>  kernel/trace/trace.h |   10 ++++++-
>  2 files changed, 50 insertions(+), 37 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6ada059..61f33da 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
[...]
> @@ -1633,24 +1633,24 @@ static int print_trace_fmt(struct trace_iterator *iter)
>  
>  	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;
>  	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
>  	if (!ret)
> -		return 0;
> +		return TRACE_TYPE_PARTIAL_LINE;

Off-thread style question: Would it be better or worse to write the
above as

	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
	ret = ret && trace_seq_printf(s, "[%03d] ", iter->cpu);
	ret = ret && trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
	if (!ret)
		return TRACE_TYPE_PARTIAL_LINE;

which would do exactly the same, but is more compact.
Good or bad style?

Well, it could be rolled into a single trace_seq_printf() call, too.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
