Return-Path: <linux-kernel-owner+w=401wt.eu-S1764105AbXKTX6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764105AbXKTX6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbXKTX6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:58:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbXKTX6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:58:30 -0500
Message-ID: <4743745A.5090709@zytor.com>
Date: Tue, 20 Nov 2007 15:57:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zach Brown <zach.brown@oracle.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com> <474331B7.6020802@zytor.com> <20071120222227.GH24156@elte.hu> <47436D07.2070203@zytor.com> <20071120234151.GD23667@elte.hu>
In-Reply-To: <20071120234151.GD23667@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>>> Why not just pin down the current ABI that there's 6 syscall 
>>> parameters _and not more_?
>> Because we have already violated it.  There are system calls that need 
>> more than 6 arguments: we need *a* convention.  Worse, we're not 
>> actually talking 6 *arguments*, we're talking 6 *words*; on 32-bit 
>> platforms a single argument can occupy two words.
> 
> i think you are at least partly wrong here. Multiplexing/demultiplexing 
> can go on infinitely - for example sys_write(fd, size, buf) can be 
> thought of as a function call that passes in fd, size and a variable 
> number of arguments of the data to be written.
> 
> in that sense capping function arguments at 6 is _sensible_ because it 
> prefers _simple_ interfaces. When i wrote syslets i did a syscall number 
> of arguments histogram:
> 
>   #args   #syscalls
>   -----------------
>       0       22
>       1       51
>       2       83
>       3       85
>       4       40
>       5       23
>       6        8
> 
> Fortunately what we see today is that 80% of all syscalls have 4 or less 
> parameters. (yes, there are a few 6-parameter syscalls that arguably 
> hurt, but still, it's the exception not the rule)
> 
> this histogram shows a healthy bell curve which is _not_ limited by the 
> arguments limit of 6, but by common sense! If the 6-arguments limit was 
> a problem then we'd see a pile-up of 6-param syscalls.
> 
> so i believe you should start thinking about lots-of-arguments syscalls 
> as an exception not as something that needs to fit into some generic 
> ABI. (Especially as most schemes that were supposed to handle this 
> problem would hurt the sane 4-parameter (or less) syscall case too.)
> 

I guess I'm confused here... all I said was I wanted them to be 
systematic, and not need ad-hoc interfaces.  In particular, I really 
don't want to see an interface where "oh, the fifth parameter is really 
a flags field so it's passed with sys_indirect, and is only accessible 
via a sys_indirect" is the norm.

We don't have all that many; pselect() being the main one (I think there 
might be a handful more on 32-bit platforms, but not positive.)  It 
introduced the convention of pointing argument register 6 to a 
user-space data structure.  Simple, and as you correctly point out, it's 
a comparatively rare case.  In klibc, I currently handle it as a special 
case, but I would prefer to avoid special cases of that sort going forward.

Note that on s390, 6-parameter system calls are already a special case: 
anything with over 5 parameters is invoked via a memory structure.  This 
actually means that for pselect on s390, we indirect via a memory 
structure not once, but twice, for no good reason.

	-hpa

