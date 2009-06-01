Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZFAOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZFAOdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFAOdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:33:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZFAOdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:33:41 -0400
Subject: Re: linux-next: manual merge of the kmemcheck tree with the
	tracing tree
From: Steven Rostedt <srostedt@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090601175539.67317265.sfr@canb.auug.org.au>
References: <20090601175539.67317265.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 01 Jun 2009 10:33:19 -0400
Message-Id: <1243866799.18138.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-06-01 at 17:55 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kmemcheck tree got a conflict in
> kernel/trace/ring_buffer.c between commit
> aa20ae8444fc6c318272c643f856d8d8ad3e198d ("ring-buffer: move big if
> statement down") from the tracing tree and commits
> 9b7ff384ee76ced9638ab236db588a6f13916336 ("trace: annotate bitfields in
> struct ring_buffer_event") and 3467e18b1cf34c7d316af5717e7053ce845d014e
> ("kmemcheck: make bitfield annotations be valid C") from the kmemcheck
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I'm not great at reading git conflict diffs.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc kernel/trace/ring_buffer.c
> index 3611706,c22506f..0000000
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@@ -1154,156 -1156,132 +1155,157 @@@ static unsigned rb_calculate_event_leng
>   	return length;
>   }

[...]

>  +	/*
>  +	 * The actual tail page has moved forward.
>  +	 */
>  +	if (tail < BUF_PAGE_SIZE) {
>  +		/* Mark the rest of the page with padding */
>  +		event = __rb_page_index(tail_page, tail);
> ++		kmemcheck_annotate_bitfield(event, bitfield);

Is this...

>  +		rb_event_set_padding(event);
>  +	}
>   
>  -		/*
>  -		 * The actual tail page has moved forward.
>  -		 */
>  -		if (tail < BUF_PAGE_SIZE) {
>  -			/* Mark the rest of the page with padding */
>  -			event = __rb_page_index(tail_page, tail);
>  -			kmemcheck_annotate_bitfield(event, bitfield);
>  -			rb_event_set_padding(event);
>  -		}

[...]

>   
> @@@ -1311,12 -1289,9 +1313,13 @@@
>   		return NULL;
>   
>   	event = __rb_page_index(tail_page, tail);
> + 	kmemcheck_annotate_bitfield(event, bitfield);

and this the only changes you needed to fix?

-- Steve

>   	rb_update_event(event, type, length);
>   
>  +	/* The passed in type is zero for DATA */
>  +	if (likely(!type))
>  +		local_inc(&tail_page->entries);
>  +
>   	/*
>   	 * If this is a commit and the tail is zero, then update
>   	 * this page's time stamp.

