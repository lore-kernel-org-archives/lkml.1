Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZGUBfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZGUBfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZGUBfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:35:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZGUBfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:35:12 -0400
Date: Mon, 20 Jul 2009 21:35:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
In-Reply-To: <4A651907.1090805@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907202131390.11494@gandalf.stny.rr.com>
References: <4A63D485.7030703@cn.fujitsu.com> <alpine.DEB.2.00.0907201207390.7595@gandalf.stny.rr.com> <alpine.DEB.2.00.0907201230320.7595@gandalf.stny.rr.com> <4A651907.1090805@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Li Zefan wrote:
> 
> But I did not change the read semantic. For example, when
> subsystem filter is not set at all:
> 
>  # echo 'irq == 5' > irq_handler_entry/filter
>  # echo 'vec == 1' > softirq_entry/filter
>  # cat filter
>  none
> 
> It'll show "none".

Ah, good point. Makes me feel even better about applying your patch ;-)

> 
> > I can keep this version, since I do find it useful (I've now come to the 
> > conclusion that having the filter work only for those filters that it 
> > would work for is fine). But the top level filter should show all filters.
> > 
> 
> As I said in an old mail, I think the subsystem filter is much more
> useful in "write" than in "read".
> 
> I have no strong option about its read semantic, but I can do what
> you like.
> 
> Suppose:
>   irq_handler_entry/filter ->  irq == 5
>   irq_handler_exit/filter  ->  none
>   softirq_entry/filter     ->  vec == 1
>   softirq_exit/filter      ->  vec == 2
> 
> Proposal 1:
> 
>   # cat filter
>   irq == 5
>   vec == 1
>   vec == 2

That's a bit confusing.

> 
> Proposal 2:
> 
>   # cat filter
>   irq_handler_entry: irq == 5
>   irq_handler_exit: none
>   softirq_entry: vec == 1
>   softirq_exit: vec == 2

I like proposal 2, it is very intuitive.

> 
> Which do you think is better? Or do you have some better idea?
> 
> And in the failure case:
> 
>   # echo 'irq == not_num' > filter
>   bash: echo: write error: Invalid argument
> 
> 1:
>   # cat filter
>   (still shows filters in each event like above)
> 
> or shows error message (the current behavior)

No need to show error messages of failed filter modifications in the 
"filter" file.

> 
> 2:
>   # cat filter
>   irq == not_num
>   ^
>   parse_error: Couldn't find or set field in one of a subsystem's events

This looks good, BUT, it is too much. If you want to implement an error 
message like the above, it should probably be a "pr_info()" thing.

-- Steve

