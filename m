Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZABPsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZABPsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZABPsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:48:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:45092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbZABPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XlH3qgba3SY9uBroHi/v0VGDZFyohRxvgatDo6oxwmNdmO8a8EXxXnKVWo0lmvg505
         UFD1BkKuGvOy5wCQztLPY3SxH+IyAje501Zi0lfqmTjw1gHV3xY3KO9idFSvUeOa4AzD
         A/GclHH5yyqHNvMS4L8IKi9gEzIKaWl3absd0=
Date: Fri, 2 Jan 2009 16:48:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: unsigned idx cannot be less than 0
Message-ID: <20090102154805.GA6833@nowhere>
References: <495E2987.3070501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E2987.3070501@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 03:49:43PM +0100, Roel Kluin wrote:
> // vi kernel/trace/ftrace.c +787
> struct ftrace_iterator {
> ...
>         unsigned                idx;
> ...
> };
> 
> idx is unsigned and cannot be less than 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 2f32969..a344add 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -842,7 +842,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
>  	void *p = NULL;
>  
>  	if (*pos > 0) {
> -		if (iter->idx < 0)
> +		if (iter->idx == 0)
>  			return p;
>  		(*pos)--;
>  		iter->idx--;


Hi Roel,

I'm not sure this is the right fix.
If you look at t_next, if there is no more page to look at,
iter_idx takes -1.

A 0 value would mean: we are in the first index on the page, which means
there is something to read and we don't want to return NULL.

I guess that would be better to turn idx into a signed int.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

