Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbYDQQpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbYDQQpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYDQQpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:45:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbYDQQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:45:45 -0400
Message-ID: <48077EB2.9030009@firstfloor.org>
Date: Thu, 17 Apr 2008 18:45:38 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v3)
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <20080416162810.GA20450@Krystal> <48063E19.9090701@goop.org> <20080417162932.GA23351@Krystal>
In-Reply-To: <20080417162932.GA23351@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>> Mathieu Desnoyers wrote:
>>> "This way lies madness. Don't go there."
>>>   
>> It is a large amount of... stuff.  This immediate values thing makes a big 
>> improvement then?
>>
> 
> As ingo said : the nmi-safe traps and exception is not only usefu lto
> immediate values, but also to oprofile. 

How is it useful to oprofile?

> On top of that, the LTTng kernel
> tracer has to write into vmalloc'd memory, so it's required there too.

All this effort changing really critical (and also fragile) code paths
used all the time is to handle setting markers into NMI functions. Or
actually the special case of setting markers in there that access
vmalloc() without calling vmalloc_sync().

NMI are maybe 5-6 functions all over the kernel.

I just don't think it makes any sense to put markers in there.
It is a really small part of the kernel the kernel that is unlikely
to be really useful for anybody. You should rather first solve the
problem of tracing the other 99.999999% of the kernel properly.

And then you could actually set the markers in there if you're
crazy enough, just call vmalloc_sync().

Mathieu argued earlier that markers should be set everywhere but
that is also bogus because there is enough other code where
you cannot set them either (one example would be early boot code[1])

And to do anything in NMI context you cannot use any locks so you would
have to write all data structures used by the markers lock less. I did
that for the the new mce code, but it's a really painful and bug prone
experience that I cannot really recommend to anybody.

And then NMIs (and machine checks) are a really obscure case, very
rarely used.

I think the right way is just to say that you cannot set markers
into NMI and machine check. Even with this patch it is highly unlikely
the resulting code will be correct anyways. Actually you could probably
set them without the patch with some effort (like calling vmalloc_sync),
but for the basic reasons mentioned above (lock less code is really
hard, nmi type functions are less than hundred lines in the millions
of kernel LOCs) it is just a very very bad idea.

-Andi


[1] Now that I mentioned it I still have enough faith to assume nobody
will be crazy enough to come up with some horrible hack to set markers
in early boot code too. But after seeing this patchkit ending up in a
git tree I'm not sure.
