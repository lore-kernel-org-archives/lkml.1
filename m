Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbZGPQLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbZGPQLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932549AbZGPQLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:11:03 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:40793 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbZGPQLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b2EbV6PaHAt1h4CSRmlowDigZ4Vsrhc4X7JUN5fboLTWjsdCzXGJ9oiGE/IkYhx7II
         ghPZJNZthHRn0/ljPuT1Vo9FNhhXrgMKOFHlq2JUhuzo89fqMguT3XVwqgJJEmDo9FZx
         3WrgmChLLfXowS1Cqwch064vYpOqAM3vCslZM=
Date: Thu, 16 Jul 2009 12:10:57 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip V2] ring_buffer: fix warning
Message-ID: <20090716161055.GC8043@nowhere>
References: <4A5C3549.7000905@cn.fujitsu.com> <4A5D90B1.3020304@cn.fujitsu.com> <4A5D92F2.1010007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5D92F2.1010007@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 04:27:30PM +0800, Lai Jiangshan wrote:
> Sorry for missing Reviewed-by and Acked-by, so I resend it.
> 
> Subject: [PATCH -tip V2] ring_buffer: fix warning
> 
> kernel/trace/ring_buffer.c: In function 'rb_tail_page_update':
> kernel/trace/ring_buffer.c:849: warning: value computed is not used
> kernel/trace/ring_buffer.c:850: warning: value computed is not used
> 
> Add "(void)"s to fix this warning.
> 
> Changed from V1:
>   Add a comment(which is written by Steven) for it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>


Queued for .32, thanks!


> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index e648ba4..51633d7 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -845,9 +845,14 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
>  		 * This will only succeed if an interrupt did
>  		 * not come in and change it. In which case, we
>  		 * do not want to modify it.
> +		 *
> +		 * We add (void) to let the compiler know that we do not care
> +		 * about the return value of these functions. We use the
> +		 * cmpxchg to only update if an interrupt did not already
> +		 * do it for us. If the cmpxchg fails, we don't care.
>  		 */
> -		local_cmpxchg(&next_page->write, old_write, val);
> -		local_cmpxchg(&next_page->entries, old_entries, eval);
> +		(void)local_cmpxchg(&next_page->write, old_write, val);
> +		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
>  
>  		/*
>  		 * No need to worry about races with clearing out the commit.
> 

