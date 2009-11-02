Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZKBNQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZKBNQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZKBNQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:16:43 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:38885 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbZKBNQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:16:42 -0500
Message-ID: <4AEEDBBC.40800@gmail.com>
Date: Mon, 02 Nov 2009 14:16:44 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AEEB6D2.7090505@gmail.com> <4AEEBAC6.7020308@gmail.com> <4AEED23A.7070009@gmail.com>
In-Reply-To: <4AEED23A.7070009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 02 Nov 2009 14:16:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> Eric Dumazet wrote:
>> cookie_hash() runs in a non preemptable context. CPU cannot change
>> under us.
>>
>> (or else, we would not use __get_cpu_var(ipv4_cookie_scratch); )
>>
>> And of course, each cpu gets its own scratch area, thanks to
>> __get_cpu_var()
>>
> Interesting.  I'm not sure that running CPU intensive functions like
> SHA1 in
> a non-preemptable context is a good idea.  I'd assumed it wasn't!
> 
> Perhaps you could point at the documentation in the code that explains
> this?

I suggest you read Documentations/ files about softirq

http://docs.blackfin.uclinux.org/kernel/generated/kernel-hacking.xml


Large part of network code is run by softirq handler, and a softirq handler
is not preemptable with another softirq (including itself).


> Perhaps a function header comment that mentions it?

So we are going to add a header to thousand of functions repeating this prereq ?

> 
> All I know is (from testing) that the tcp_minisockets.c caller is sometimes
> called in a fashion that requires atomic allocation, and other times
> does not!

Maybe callers have different contexts (running from softirq handler or
from process context). Atomic ops are expensive and we try to avoid them
if/when possible.

> 
> See my "Subject: query: tcpdump versus atomic?" thread from Oct 14th.

You probably add a bug in your kernel, leaving a function with unpaired lock/unlock
of notallow_something/allow_something

There are books about linux internals that you could read if you want some extra
documentation. Dont ask me details, I never read them :)

