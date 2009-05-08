Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZEHLDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZEHLDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZEHLD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:03:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42841 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZEHLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nlV1H5PBJ9TskO1gQO023gHwQzLPsrzTSQZdSfG9rysa3AUy86B5cYo5czcbvbRoo9
         rMJdkPmZAPu++MRdhhxY9HsK+wfbuNyqXowrnPTd0AvG92ohm6TAeUzhvdeuKb8E0Rt2
         ZitXgXg2foSkNkubHF+NRmYoQWpBoBR4esi0M=
Date: Fri, 8 May 2009 13:03:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/events: simplify system_enable_read()
Message-ID: <20090508110324.GB6417@nowhere>
References: <4A03998E.3020503@cn.fujitsu.com> <4A0399A5.2080603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0399A5.2080603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 10:32:05AM +0800, Li Zefan wrote:
> A smarter way to figure out the output of an enable file.
> 
> [ Impact: clean up ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events.c |   40 ++++++----------------------------------
>  1 files changed, 6 insertions(+), 34 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 45f1099..df394bc 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -414,10 +414,11 @@ static ssize_t
>  system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
> +	const char set_to_char[4] = { '?', '0', '1', 'X' };
>  	const char *system = filp->private_data;
>  	struct ftrace_event_call *call;
>  	char buf[2];
> -	int set = -1;
> +	int set = 0;
>  	int ret;
>  
>  	mutex_lock(&event_mutex);
> @@ -433,47 +434,18 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		 * or if all events or cleared, or if we have
>  		 * a mixture.
>  		 */
> -		if (call->enabled) {
> -			switch (set) {
> -			case -1:
> -				set = 1;
> -				break;
> -			case 0:
> -				set = 2;
> -				break;
> -			}
> -		} else {
> -			switch (set) {
> -			case -1:
> -				set = 0;
> -				break;
> -			case 1:
> -				set = 2;
> -				break;
> -			}
> -		}
> +		set |= (1 << !!call->enabled);
> +
>  		/*
>  		 * If we have a mixture, no need to look further.
>  		 */
> -		if (set == 2)
> +		if (set == 3)
>  			break;
>  	}
>  	mutex_unlock(&event_mutex);
>  
> +	buf[0] = set_to_char[set];
>  	buf[1] = '\n';
> -	switch (set) {
> -	case 0:
> -		buf[0] = '0';
> -		break;
> -	case 1:
> -		buf[0] = '1';
> -		break;
> -	case 2:
> -		buf[0] = 'X';
> -		break;
> -	default:
> -		buf[0] = '?';
> -	}
>  
>  	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
>  
> -- 
> 1.5.4.rc3
> 

Nice!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

