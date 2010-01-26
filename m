Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663Ab0AZWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0AZWcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060Ab0AZWce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:32:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab0AZWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:32:33 -0500
Date: Tue, 26 Jan 2010 14:32:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/5] tracing: Prevent kernel oops with corrupted buffer
Message-Id: <20100126143223.e4332098.akpm@linux-foundation.org>
In-Reply-To: <20100126221712.447066697@goodmis.org>
References: <20100126220923.534282809@goodmis.org>
	<20100126221712.447066697@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 17:09:24 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> If the contents of the ftrace ring buffer gets corrupted and the trace
> file is read, it could create a kernel oops (usualy just killing the user

"usually" ;)

> task thread). This is caused by the checking of the pid in the buffer.
> If the pid is negative, it still references the cmdline cache array,
> which could point to an invalid address.
> 
> The simple fix is to test for negative PIDs.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 0df1b0f..eac6875 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -951,6 +951,11 @@ void trace_find_cmdline(int pid, char comm[])
>  		return;
>  	}
>  
> +	if (WARN_ON_ONCE(pid < 0)) {
> +		strcpy(comm, "<XXX>");
> +		return;
> +	}
> +
>  	if (pid > PID_MAX_DEFAULT) {
>  		strcpy(comm, "<...>");
>  		return;

But why is it WARN_ON_ONCE()?  That will only fix the problem a single
time.  On the second occurrence, it will oops again.

