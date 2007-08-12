Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbXHLDUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbXHLDUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXHLDUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:20:43 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:34900 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXHLDUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:20:42 -0400
Message-ID: <46BE7BB6.2010607@gmail.com>
Date: Sun, 12 Aug 2007 05:17:10 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>	 <46BE621E.9090509@gmail.com> <9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
In-Reply-To: <9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2007 03:52 AM, Jesper Juhl wrote:

> On 12/08/07, Rene Herman <rene.herman@gmail.com> wrote:
>> On 08/12/2007 03:08 AM, Jesper Juhl wrote:
>>
>>> This may be a little off topic, but I think it's interresting enough
>>> to warrent a single mail.
>>>
>>> I just saw a news article (http://www.theinquirer.net/?article=41610)
>>> about a 3 Socket Opteron motherboard and couldn't help but wonder if
>>> we are prepared to deal with such a beast, so I thought I'd inform
>>> everyone :-)
>>>
>>> I'm guessing equipping such a board with 3 single core CPU's could
>>> show up some interresting corner cases in schedular code and
>>> elsewhere, I'll bet we have some assumptions somewhere about
>>> nr_of_cpus being an even number...
>> I would hope the N=1 case will have flushed out enough of those... :-|
>>
> Hehe, true, but I was thinking more of nr_of_cpus is an odd number > 1. :-)
> Just thinking of having to divide things by 3 makes me worry ;-)  ...

It's not a hugely strange worry no. Grepping around (for num_online_cpus for 
example) didn't throw up any glaring bugs I believe.

A possible problem in mm/vmstat.c:calculate_threshold() where 3 CPUs would 
be treated as 2 through an fls(). No idea about that code and if that would 
be a problem.

The line just below where it does that _does_ seem to have a problem:

         /*
          * Maximum threshold is 125
          */
         threshold = min(125, threshold);

as either the comment or the code is wrong and it seems it's the code. Added 
Andrew Morton to the CC for that.

CFS (v19.1) has an ilog2 on num_online_cpus() in 
kernel/sched.c:sched_init_granularity() but this seems not a problem. Added 
Ingo Molnar.

Rene.
